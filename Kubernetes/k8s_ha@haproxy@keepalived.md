# Kubernetes 高可用集群部署（keepalived + haproxy）

> 高可用(HA)Kubernetes集群意味着控制平面(control plane)的多个实例分布在不同的节点上，确保即使一个或多个节点故障，集群仍能正常运行。

Kubernetes 高可用集群通常有以下两种架构：

1. 堆叠式(Stacked)高可用拓扑：

   - etcd节点 与控制平面节点 共存
   - 每个控制平面节点运行一个etcd成员
   - 需要至少3个控制平面节点

2. 外部etcd高可用拓扑：

   - etcd集群与控制平面分离
   - 需要至少3个控制平面节点和3个etcd节点

系统要求：

- 至少3台符合 Kubernetes 要求的 Linux 主机(控制平面节点)
- 建议操作系统 CentOS-7.6.1810 及以上的版本，配置2核CPU、2GB内存以上
- 所有节点间网络互通
- 唯一的主机名、MAC地址和product_uuid
- 禁用交换分区
- 所需端口开放（或禁用防火墙）

## 一、环境准备

服务器规划如下：

| IP | Role | CPU | 内存 | 系统盘 | 数据盘 |
| --- | --- | --- | --- | --- | --- |
| 192.168.31.110 | k8s-m1 | 4 | 8G | 50G | 50G |
| 192.168.31.111 | k8s-m2 | 4 | 8G | 50G | 50G |
| 192.168.31.112 | k8s-m3 | 4 | 8G | 50G | 50G |
| 192.168.31.113 | node01 | 4 | 8G | 100G | - |
| 192.168.31.120 | harbor | 4 | 8G | 100G | - |

k8s-m1, k8s-m2, k8s-m3 既是 master 同时也是 node 节点

前提条件

- 两台或多台满足 Kubernetes 最低要求的 Linux 服务器
- 每台服务器有静态 IP 地址
- 所有节点之间网络互通
- 所有节点已禁用交换空间 swap
- 所有节点已设置正确的主机名和 hosts 文件
- 所有节点之间时间同步
- 所有节点已安装容器运行时 (如 Docker、containerd)

### 1.1 系统基本配置

```sh
#1. 关闭防火墙
sudo systemctl disable --now firewalld

#2. 关闭 seliux
sudo sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
sudo setenforce 0

#3. 关闭交换空间 swap
sudo sed -i '/swap/s/^/#/' /etc/fstab
sudo swapoff -a

#4. 设置主机名 (hostname: k8s-m1/node01/node02)，以 k8s-m1为例：
sudo hostnamectl set-hostname k8s-m1 && bash

#5. 配置 hosts
sudo tee -a /etc/hosts <<-EOF
192.168.31.110 k8s-m1
192.168.31.111 k8s-m2
192.168.31.112 k8s-m3
192.168.31.113 node01
EOF

#6. 配置时间同步
#设置时区
sudo timedatectl set-timezone Asia/Shanghai
#安装 NTP 服务
sudo yum -y install chrony
sudo systemctl enable --now chronyd
```

系统时间同步参考：[Linux 系统时间同步 -- Chrony](https://www.cnblogs.com/librarookie/p/18886055 "chrony 用法")

### 1.2 配置内核转发及网桥过滤

```sh
#1. 加载网桥过滤和内核转发模块（将桥接的 IPv4流量传递到 iptables的链）
sudo tee /etc/sysctl.d/k8s.conf <<-EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

#2. 启用网络桥接和转发功能
sudo tee /etc/modules-load.d/k8s.conf <<-EOF
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
```

- overlay: 文件系统支持，允许创建多个覆盖层（overlay），对容器技术有帮助
- br_netfilter: 桥接网络的包过滤功能，用于 kubernetes 集群管理 pod 网络
- modprobe：临时加载模块，如：sudo modprobe overlay

### 1.3 配置 ipvs 功能（选配）

> Kubernetes 的 kube-proxy 支持 iptables（默认） 和  IPVS（IP Virtual Server） 两种模式，来实现 Pod 同集群内外的应用进行通信;
> </br> 其中 "ipvs mode" 的通信效率更高；但是使用它，要求 Kubernetes 版本为 1.9 或以上，而且需要手动载入ipvs模块。

加载 ipvs 环境

```sh
#1. 安装 ipset 和 ipvsadm
sudo yum -y install ipset ipvsadm

#2. 配置开机加载
sudo tee /etc/modules-load.d/k8s-ipvs.conf <<-EOF
ip_vs
ip_vs_rr
ip_vs_wrr
ip_vs_sh
nf_conntrack
EOF

#3. 手动加载
for mod in "ip_vs ip_vs_rr ip_vs_wrr ip_vs_sh nf_conntrack"; do
    sudo modprobe $mod
done
```

tips: 高版本的 centos 内核 nf_conntrack_ipv4 被 nf_conntrack 替换了

</br>

## 二、软件安装

Kubernetes、containerd 与 pause 镜像版本对照表

| Kubernetes 版本 | 推荐/最低 containerd 版本 | 推荐 pause 镜像版本 | 关键变化                            |
| ------------- | ------------------- | ------------- | ------------------------------- |
| 1.24.x        | 1.6.x /  1.5.x      | pause:3.6+    | 移除 dockershim，必须使用 CRI v1 运行时。  |
| 1.25.x-1.27.x | 1.7.x / 1.6.x       | pause:3.8+    | 稳定性优化，支持新 CRI 特性。               |
| 1.28.x        | 1.7.x / 1.6.x       | pause:3.9     | 默认沙箱镜像升级至 3.9（官方公告）。            |
| 1.29.x-1.30.x | 2.0.x / 1.7.x       | pause:3.10    | containerd 2.0 开始支持新功能（如镜像加 密）。 |

[常用软件兼容版本参考](https://blog.csdn.net/oSmileAngel/article/details/143252624)

### 2.1 安装容器运行时（CRI）

#### 2.1.1 安装 containerd.io

[Docker CE 镜像](https://developer.aliyun.com/mirror/docker-ce "阿里云镜像")

```sh
#离线安装：
wget https://github.com/containerd/containerd/releases/download/v1.6.32/cri-containerd-1.6.32-linux-amd64.tar.gz
tar -zxvf cri-containerd-cni-1.6.32-linux-amd64.tar.gz -C /
mkdir -p /etc/containerd

#在线安装：
# Step 1: 安装必要的一些系统工具
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# Step 2: 添加软件源信息
sudo yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# Step 3: 更新并安装
sudo yum makecache fast
#查找可用版本
# yum list containerd.io --showduplicates |sort -V
#安装指定版本
sudo yum -y install containerd.io-1.6.32

# Step 4: 设置开机自启并启动
sudo systemctl enable --now containerd
```

#### 2.1.2 初始化 containerd 配置

> <https://github.com/containerd/containerd/blob/main/docs/cri/config.md>
> </br> <https://kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/>

```sh
#1. 备份配置文件
sudo cp /etc/containerd/config.toml /etc/containerd/config.toml.bak

#2. 生成初始化配置文件
containerd config default |sudo tee /etc/containerd/config.toml

#3. 编辑配置文件
## 3.1 更新沙箱（pause）镜像，更新为国内镜像
## 3.2 修改 cgroup driver为 systemd
sudo sed -i -e '/sandbox_image/s|registry.k8s.io/pause:3.6|registry.aliyuncs.com/google_containers/pause:3.9|' \
    -e '/SystemdCgroup/s/false/true/' /etc/containerd/config.toml

#4.查看当前配置
containerd config dump
# containerd config dump | grep 'sandbox_image\|SystemdCgroup'
```

#### 2.1.3 配置 containerd 容器镜像加速

> 参考链接：<https://www.orchome.com/17176>

`sudo sed -i '0,/config_path/s|""|"/etc/containerd/certs.d"|' /etc/containerd/config.toml`

```sh
# docker.io 镜像
sudo mkdir -p /etc/containerd/certs.d/docker.io

cat <<'EOF' | sudo tee /etc/containerd/certs.d/docker.io/hosts.toml > /dev/null
server = "https://docker.io"
[host."https://dockerproxy.com"]
    capabilities = ["pull", "resolve"]

[host."https://docker.m.daocloud.io"]
    capabilities = ["pull", "resolve"]

[host."https://hub-mirror.c.163.com"]
    capabilities = ["pull", "resolve"]
EOF

# registry.k8s.io 镜像
sudo mkdir -p /etc/containerd/certs.d/registry.k8s.io

cat <<'EOF' | sudo tee /etc/containerd/certs.d/registry.k8s.io/hosts.toml > /dev/null
server = "https://registry.k8s.io"
[host."https://k8s.m.daocloud.io"]
    capabilities = ["pull", "resolve"]
EOF

# k8s.gcr.io 镜像
sudo mkdir -p /etc/containerd/certs.d/k8s.gcr.io

cat <<'EOF' | sudo tee /etc/containerd/certs.d/k8s.gcr.io/hosts.toml > /dev/null
server = "https://k8s.gcr.io"
[host."k8s-gcr.m.daocloud.io"]
    capabilities = ["pull", "resolve"]
EOF
```

重启生效

```sh
sudo systemctl daemon-reload
sudo systemctl restart containerd
```

### 2.2 安装 Kubernetes

#### 2.2.1 安装 kubelet kubeadm kubectl
 [Kubernetes镜像下载安装-开源镜像站-阿里云](https://developer.aliyun.com/mirror/kubernetes)

```sh
# Step 1: 添加软件源信息
cat <<-EOF |sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes-new/core/stable/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes-new/core/stable/v1.28/rpm/repodata/repomd.xml.key
EOF
#刷新 yum源
# sudo yum clean all && sudo yum makecache

# Step 2: 安装软件
setenforce 0
#查找可用版本
# yum list kubelet --showduplicates |sort -V
#安装指定版本
sudo yum install -y kubelet-1.28.15 kubeadm-1.28.15 kubectl-1.28.15

# Step 3: 配置 kubelet
#debain: /etc/default/kubelet
#centos: /etc/sysconfig/kubelet
#KUBELET_EXTRA_ARGS="--cgroup-driver systemd"
sudo sed -i 's/KUBELET_EXTRA_ARGS=/&"--cgroup-driver systemd"/' /etc/sysconfig/kubelet

# Step 4: 设置 kubelet 自启并启动
sudo systemctl enable --now kubelet
```
#### 2.2.2 配置 crictl 工具环境（选配）

> [crictl 工具中文文档（k8s工具，通常在 Kubernetes 节点上使用）](https://kubernetes.io/zh-cn/docs/tasks/debug/debug-cluster/crictl "crictl 文档")
> </br> [crictl 工具环境初始化](https://www.cnblogs.com/LILEIYAO/p/17169234.html)
> </br> crictl 是 CRI 兼容的容器运行时命令行接口。 你可以使用它来检查和调试 Kubernetes 节点上的容器运行时和应用程序。

```sh
# 生成 crictl 配置文件（/etc/crictl.yaml） 例如，使用 containerd 容器运行时的配置会类似于这样：
crictl config runtime-endpoint unix:///var/run/containerd/containerd.sock

# 或者直接新建配置
cat <<-EOF |sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///var/run/containerd/containerd.sock
image-endpoint: unix:///var/run/containerd/containerd.sock
timeout: 10
debug: true
EOF
```

### 2.3 停止软件更新（选配）

- CentOS

```sh
#1. 安装插件
sudo yum install yum-plugin-versionlock
#2. 添加锁定的软件 
yum versionlock add <pkg_name>[-version] 

# 锁定 containerd，kubeadm，kubelet，kubectl
sudo yum versionlock add containerd.io-1.6.32 \
	kubeadm-1.28.15 kubelet-1.28.15 kubectl-1.28.15
```

- Ubuntu

`sudo apt-mark hold containerd.io kubeadm kubelet kubectl`

更多 yum/apt 命令参考：<https://www.cnblogs.com/librarookie/p/18617956>

### 2.4 安装 Keepalived + Haproxy

在所有控制节点（master）上执行

```sh
#安装
sudo yum install -y keepalived haproxy

#自启
sudo systemctl enable --now keepalived
sudo systemctl enable --now haproxy
```

</br>

## 三、K8S 高可用集群搭建

### 3.1 Keepalived 配置

> Keepalived 参考链接：<https://www.cnblogs.com/librarookie/p/18615518>

1. 配置文件 keepalived.cfg 备份

`sudo cp /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.bak`

2. 在控制节点的 “主节点” 中配置

```sh
sudo tee /etc/keepalived/keepalived.conf <<-EOF
global_defs {
	router_id k8s-m1    #服务器路由标识（默认为hostname）
}

vrrp_script check_haproxy {
	script "/usr/bin/killall -0 haproxy"    #检查 haproxy 服务
	timeout 1       #脚本超时时间
	interval 3      #脚本执行间隔
	fall 3      #连续失败 3 次，标记失败
	rise 2      #连续成功 2 次，标记成功
}

vrrp_instance VI_1 {
	state MASTER        #角色类型（MASTER/BACKUP）
	interface eth0      #虚拟网卡桥接的真实网卡
	virtual_router_id 51    #虚拟路由ID标识，同一VRRP实例中主备设置必须一致
	priority 100        #初始优先级设定
	advert_int 1
	authentication {
		auth_type PASS
		auth_pass 1111
	}
	virtual_ipaddress {
		192.168.31.99   # #对外提供的虚拟IP
	}

	track_script {      #根据vrrp_script结果，调整服务
		check_haproxy   #健康检查
	}
}
EOF
```

3. 在控制节点的 “备用节点” 中配置

```sh
sudo tee /etc/keepalived/keepalived.conf <<-EOF
global_defs {
	router_id k8s-m2    #服务器路由标识
}

vrrp_script check_haproxy {
	script "/usr/bin/killall -0 haproxy"
	timeout 1
	interval 3
	fall 3
	rise 2
}

vrrp_instance VI_1 {
	state BACKUP        #角色类型（MASTER/BACKUP）
	interface eth0
	virtual_router_id 51
	priority 90        #初始优先级设定（小于 MASTER）
	advert_int 1
	authentication {
		auth_type PASS
		auth_pass 1111
	}
	virtual_ipaddress {
		192.168.31.99
	}

	track_script {
		check_haproxy
	}
}
EOF
```

  其他备用节点同理，virtual_router_id 相同，priority值小于 MASTER。

4. 验证

```sh
# keepavlied 服务重启生效
sudo systemctl restart keepvlived

#停止 主节点的 haproxy 服务
sudo systemctl stop haproxy

#查看网卡，检查 vip 是否漂移
ip addr show eth0
```

### 3.2 Haproxy 配置

> Haproxy 参考链接：<https://www.cnblogs.com/librarookie/p/18876474>

1. 配置文件备份

`sudo cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak`

2. 配置 haproxy.cfg

在所有控制节点中配置

```sh
sudo tee /etc/haproxy/haproxy.cfg <<-EOF
global
	log     127.0.0.1 local2    #日志
	chroot  /var/lib/haproxy    #haproxy根目录
	user    haproxy
	group   haproxy
	daemon              #后台运行

defaults
	mode    http
	log     global
	option  httplog
	option  dontlognull         #不记录空连接
	option  http-server-close   #客户端保持长连接
	option  redispatch          #允许失败发往其他节点
	retries 3                   #连续失败 3次，标记不可用

	timeout http-request    10s
	timeout queue           1m
	timeout connect         10s
	timeout client          1m
	timeout server          1m
	timeout http-keep-alive 10s
	timeout check           10s
	maxconn                 3000

listen k8s-apiserver
	bind    0.0.0.0:16443    #配置负载均衡的端口（这里配置kubeadm --control-plane-endpoint 端口）
	mode    tcp
	log     global
	option  tcplog
	timeout client 1h
	timeout connect 1h

	balance roundrobin      #轮询
	server  k8s-m1 192.168.31.110:6443 check
	server  k8s-m2 192.168.31.111:6443 check
	server  k8s-m3 192.168.31.112:6443 check
EOF
```

  配置完重启 haproxy 服务生效

### 3.3 初始化控制面板（master）

> 初始化以下面参数为例
> 主机名："k8s-m1"，
> IP："192.168.31.110"，
> VIP："192.168.31.99:16443",
> k8s版本："1.28.15"

方式一：以配置文件的方式初始化 master（推荐）

```sh
#创建 k8s 资源目录
mkdir -p $HOME/kube-home

#1. 生成初始化配置文件
kubeadm config print init-defaults > $HOME/kube-home/kubeadm-config.yaml

#2. 初始化配置
#2.1 指定初始化参数
sed -i -e '/advertiseAddress/s/1.2.3.4/192.168.31.110/' \
    -e '/controllerManager/i\controlPlaneEndpoint: 192.168.31.99:16443' \
    -e '/name: node/s/node/k8s-m1/' \
    -e '/imageRepository/s|registry.k8s.io|registry.aliyuncs.com/google_containers|' \
    -e '/kubernetesVersion/c\kubernetesVersion: 1.28.15' \
    -e '/serviceSubnet/a\ \ podSubnet: 10.244.0.0\/16' $HOME/kube-home/kubeadm-config.yaml

#2.2 指定CgroupDriver
tee -a $HOME/kube-home/kubeadm-config.yaml <<-EOF
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cgroupDriver: "systemd"
---
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
mode: "ipvs"
EOF

#3. 初始化控制面板（master）
#3.1 检验配置文件，--dry-run 试运行（可选）
sudo kubeadm init --config $HOME/kube-home/kubeadm-config.yaml --upload-certs --dry-run --v=5

#3.2 提前下载镜像文件，list/pull：查看/下载（可选）
sudo kubeadm config images pull --config $HOME/kube-home/kubeadm-config.yaml

sudo kubeadm init --config $HOME/kube-home/kubeadm-config.yaml --upload-certs
```

  - Kubernetes v1.28 支持自动检测 cgroup 驱动程序。
  - Kubernetes官方推荐使用cgroup driver 为 systemd 。
  - [从 v1.22 开始，在使用 kubeadm 创建集群时，如果用户没有在 `KubeletConfiguration` 下设置 `cgroupDriver` 字段，kubeadm 默认使用 `systemd`。](https://kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/#systemd-cgroup-driver)

方式二：以传参的方式初始化 master

```sh
sudo kubeadm init --control-plane-endpoint=192.168.31.99:16443 --upload-certs \
        --image-repository=registry.aliyuncs.com/google_containers \
        --kubernetes-version=v1.28.15 \
        --pod-network-cidr=10.244.0.0/16
```

参数介绍：
  - `--control-plane-endpoint`：标志应该被设置成负载均衡器的地址或 DNS 和端口（使用了此参数，就不用--apiserver-advertise-address参数）
  - `--upload-certs`：将证书保存到 kube-system 名称空间下名为 extension-apiserver-authentication 的 configmap 中，这样其他控制平面加入的话只要加上 `--control-plane和--certificate-key` 并带上相应的key就可以拿到证书并下载到本地。
  - `--image-repository`：指定镜像仓库，默认访问google下载源，所以需要指定一个国内的下载源
  - `--kubernetes-version`：指定 kubernetes 版本（默认使用最新版本号，可能会存在兼容问题）
  - `--service-cidr`：指定 service 网络的ip地址段，可以理解为同一类 pod 负载均衡的虚拟ip（默认：10.96.0.0/12）
  - `--pod-network-cidr`：指 pod 网络的ip地址段，分配给每个pod (`calico` 默认：192.168.0.0/16，`flannel` 默认：10.244.0.0/16)

日志如下：

```log
...

Your Kubernetes control-plane has initialized successfully!

# 配置控制节点 kubectl 工具环境
To start using your cluster, you need to run the following as a regular user:（普通用户）

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:（root用户）

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of the control-plane node running the following command on each as root:（master节点join命令）

  kubeadm join 192.168.31.99:16443 --token abcdef.0123456789abcdef \
        --discovery-token-ca-cert-hash sha256:c86def262486917457d9e7a4b47962a390270130613e53ca91d69104c6cd5661 \
        --control-plane --certificate-key 28af77afc066211ce24b30114d92f018204e56172b1057fa504ed3feccfef597

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:（node节点join命令）

kubeadm join 192.168.31.99:16443 --token abcdef.0123456789abcdef \
        --discovery-token-ca-cert-hash sha256:c86def262486917457d9e7a4b47962a390270130613e53ca91d69104c6cd5661 
```

### 3.2 加入节点

### 3.2.1 加入控制节点（master）

```sh
#加入集群，在新控制节点（master）上，执行日志中 join 命令，如下：
sudo kubeadm join 192.168.31.99:16443 --token abcdef.0123456789abcdef \
        --discovery-token-ca-cert-hash sha256:c86def262486917457d9e7a4b47962a390270130613e53ca91d69104c6cd5661 \
        --control-plane --certificate-key 28af77afc066211ce24b30114d92f018204e56172b1057fa504ed3feccfef597

#如果需要，可以使用来重新加载证书。
sudo kubeadm init phase upload-certs --upload-certs
#请注意，证书密钥可访问群集敏感数据，因此请保密！作为一种保障措施，上传的证书将在两小时后删除；

# 如果 join 命令忘记了，或者 token 过期，则重新创建新 token， 命令如下：
sudo kubeadm token create --print-join-command
## 此结果与 master 初始化日志中的 join 命令同理（token有效期为24h）
```

日志如下：

```log
...

This node has joined the cluster and a new control plane instance was created:

* Certificate signing request was sent to apiserver and approval was received.
* The Kubelet was informed of the new secure connection details.
* Control plane label and taint were applied to the new node.
* The Kubernetes control plane instances scaled up.
* A new etcd member was added to the local/stacked etcd cluster.

# 配置控制节点 kubectl 工具环境
To start administering your cluster from this node, you need to run the following as a regular user:

        mkdir -p $HOME/.kube
        sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
        sudo chown $(id -u):$(id -g) $HOME/.kube/config

Run 'kubectl get nodes' to see this node join the cluster.
```

### 3.2.2 加入工作节点（node）

```sh
# 加入集群，在工作节点（node）上，分别执行 master 初始化日志中 join 命令
sudo kubeadm join 192.168.31.99:16443 --token abcdef.0123456789abcdef \
        --discovery-token-ca-cert-hash sha256:c86def262486917457d9e7a4b47962a390270130613e53ca91d69104c6cd5661 

# 如果 join 命令忘记了，或者 token 过期，则重新创建新 token， 命令如下：
sudo kubeadm token create --print-join-command
## 此结果与 master 初始化日志中的 join 命令同理（token有效期为24h）
```

日志如下：

```log
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
```

### 3.3 移除节点

```sh
# Step 1：列出所有nodes
kubectl get node -o wide

# Step 2：删除节点 node02 （在控制平面节点 master 上）
kubectl drain node02 --delete-emptydir-data --force --ignore-daemonsets
#该命令的主要目的是安全地将 node02 节点上的 Pod 驱逐到集群中的其他节点，以便对该节点进行维护或升级。
kubectl delete node node02

# Step 3：重置配置（在移除的节点上执行）
yes | sudo kubeadm reset

# Step 4：重新加入集群（join）
```

  - --delete-emptydir-data：删除使用 emptyDir 卷的 Pod 的数据
    - 默认情况下，drain 会保留 emptyDir 卷的数据
    - 使用此标志表示你确认可以删除这些临时数据
  - --force：强制排空，即使某些 Pod 不受 ReplicationController、ReplicaSet、Job、DaemonSet 或 StatefulSet 管理（通常用于排空那些没有控制器管理的 Pod）
  - --ignore-daemonsets：忽略 DaemonSet 管理的 Pod
    - 默认情况下，drain 不会处理 DaemonSet Pod（因为它们设计为在特定节点上运行）
    - 此标志明确告诉 kubectl 忽略它们而不是报错

### 3.4 安装 Pod 网络插件（CNI）

- [Calico 安装文档](https://docs.tigera.io/calico/3.28/getting-started/kubernetes/self-managed-onprem/onpremises "Install Calico")
- [Calico 版本兼容](https://docs.tigera.io/calico/3.28/getting-started/kubernetes/requirements#kubernetes-requirements "Kubernetes requirements")
- [Calico-v3.25版本的yaml文件](https://docs.projectcalico.org/manifests/calico.yaml)

```sh
#1. 安装 Tigera Calico 运算符
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.5/manifests/tigera-operator.yaml
## 离线的话，可以先将 tigera-operator.yaml 下载，然后再使用 kubectl create

#2. 下载 Calico 的自定义文件（通过创建必要的自定义资源来安装 Calico）
curl -O https://raw.githubusercontent.com/projectcalico/calico/v3.28.5/manifests/custom-resources.yaml

# 编辑 yaml 文件，修改 POD 网络（calico默认是192.168.0.0/16，需要和master初始化时pod网络一致）
sed -i '/cidr/s|192.168.0.0/16|10.244.0.0/16|' custom-resources.yaml

#3. 安装 Tigera Calico 自定义资源定义
kubectl create -f custom-resources.yaml

#4. 查看 CNI 状态
kubectl get pods -n calico-system [-o wide] -w

#5. 查看集群状态
# 稍微等待一会，等 calico-node pod 运行起来
kubectl get nodes
```

- calico 默认 pod 网络地址：192.168.0.0/16
- [flannel 插件](https://github.com/flannel-io/flannel/blob/master/Documentation/kube-flannel.yml) 默认 pod 网络地址：10.244.0.0/16

</br>
