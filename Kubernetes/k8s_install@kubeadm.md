# kubeadm 部署 Kubernetes（k8s）集群环境

</br>
</br>

![202503100815440](https://gitee.com/librarookie/picgo/raw/master/img/202503100815440.png)

## 一、环境准备

> kubeadm 安装 kubernetes 集群要求最少2核，建议环境配置如下：4核心，8GB内存，100G硬盘空间

服务器规划如下：

| ROLE | IP | 组件 |
| ---- | ---- | ---- |
| master | 192.168.31.110 | containerd, kubeadm, kubelet, kubectl |
| node01 | 192.168.31.111 | containerd, kubeadm, kubelet [, kubectl] |
| node02 | 192.168.31.112 | containerd, kubeadm, kubelet [, kubectl] |
| harbor | 192.168.31.113 |  |

- 一台或多台机器，操作系统CentOS7.x-86_x64
- 硬件配置：2GB 或更多RAM，2 个CPU 或更多CPU，硬盘30GB 或更多
- 集群中所有机器之间网络互通
- 可以访问外网，需要拉取镜像
- 禁止swap 分区

### 1.1 系统基本配置

```sh
#1. 关闭防火墙
#sudo systemctl stop firewalld
#sudo systemctl disable firewalld
sudo systemctl disable --now firewalld  # 上面两个命令效果

#2. 关闭 seliux
sudo sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
sudo setenforce 0

#3. 关闭交换空间 swap
sudo sed -i '/swap/s/^/#/' /etc/fstab
sudo swapoff -a

#4. 设置主机名 (hostname: master/node01/node02)，以 master为例：
sudo hostnamectl set-hostname master && bash

#5. 配置 hosts
sudo tee -a /etc/hosts <<-EOF
192.168.31.110 master
192.168.31.111 node01
192.168.31.112 node02
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
#1. 启用网络桥接和转发功能
sudo tee /etc/modules-load.d/containerd.conf <<-EOF
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

#2. 加载网桥过滤和内核转发模块（将桥接的 IPv4流量传递到 iptables的链）
sudo tee /etc/sysctl.d/kubernetes.conf <<-EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system
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

| Kubernetes 版本 | 推荐/最低 containerd 版本 | 推荐 pause 镜像版本 | 关键变化 |
| ---- | ---- | ---- | ---- |
| 1.24.x | 1.6.x /  1.5.x | pause:3.6+ | 移除 dockershim，必须使用 CRI v1 运行时。 |
| 1.25.x-1.27.x | 1.7.x / 1.6.x | pause:3.8+ | 稳定性优化，支持新 CRI 特性。 |
| 1.28.x | 1.7.x / 1.6.x | pause:3.9 | 默认沙箱镜像升级至 3.9（官方公告）。 |
| 1.29.x-1.30.x | 1.7.x 或 2.0.x / 1.7.x | pause:3.10 | containerd 2.0 开始支持新功能（如镜像加 密）。 |

[常用软件兼容版本参考](https://blog.csdn.net/oSmileAngel/article/details/143252624)

### 2.1 安装容器运行时（CRI）

#### 2.1.1 安装 containerd.io

[Docker CE 镜像](https://developer.aliyun.com/mirror/docker-ce "阿里云镜像")

```sh
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

[Containerd 离线安装](https://www.cnblogs.com/nolenlinux/articles/18437173)

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

`sudo sed -i '/config_path/s|""|"/etc/containerd/certs.d"|' /etc/containerd/config.toml`

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

> <https://developer.aliyun.com/mirror/kubernetes?spm=a2c6h.13651102.0.0.560a1b11KBf3Cq>

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

# Step 3: 设置 kubelet 自启并启动
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
debug: false
EOF
```

#### 2.3 停止软件更新（选配）

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

</br>

## 三、K8S 集群搭建

### 3.1 初始化控制面板（master）

> 以下初始化以主机名："master"，IP："192.168.31.110"，k8s版本："1.28.15" 为例。

```sh
#创建 k8s 资源目录
mkdir -p $HOME/kube-home

## 方式一：以配置文件的方式初始化 master（推荐）
#1. 生成初始化配置文件
kubeadm config print init-defaults > $HOME/kube-home/kubeadm-config.yaml

#2. 初始化配置
## 指定初始化参数
sed -i -e '/advertiseAddress/s/1.2.3.4/192.168.31.110/' \
    -e '/name: node/s/node/master/' \
    -e '/imageRepository/s|registry.k8s.io|registry.aliyuncs.com/google_containers|' \
    -e '/kubernetesVersion/c\kubernetesVersion: 1.28.15' \
    -e '/serviceSubnet/a\ \ podSubnet: 10.244.0.0\/16' $HOME/kube-home/kubeadm-config.yaml

## 指定 CgroupDriver (从 v1.22 开始，kubeadm创建集群默认 cgroupDriver: systemd)
## systemd配置：<https://kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/>
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

#3. 检验配置文件，--dry-run 试运行
sudo kubeadm init --config $HOME/kube-home/kubeadm-config.yaml --dry-run --v=5

#4. 提前下载镜像文件
# kubeadm config images list --config $HOME/kube-home/kubeadm-config.yaml   #查看镜像
sudo kubeadm config images pull --config $HOME/kube-home/kubeadm-config.yaml

#5. 初始化控制面板（master）
sudo kubeadm init --config $HOME/kube-home/kubeadm-config.yaml

## 方式二：以传参的方式初始化 master
#sudo kubeadm init --apiserver-advertise-address=192.168.31.110 \
#        --image-repository=registry.aliyuncs.com/google_containers \
#        --kubernetes-version=v1.28.15 \
#        --pod-network-cidr=10.244.0.0/16

## 参数介绍：
# --apiserver-advertise-address：指定 Master Api组件监听的ip地址，与其他地址通信的地址，通常是master节点的IP地址
# --image-repository：指定镜像仓库，默认访问google下载源，所以需要指定一个国内的下载源
# --kubernetes-version：指定 kubernetes 版本（默认使用最新版本号，可能会存在兼容问题）
# --service-cidr：指定 service 网络的ip地址段，可以理解为同一类 pod 负载均衡的虚拟ip（默认：10.96.0.0/12）
# --pod-network-cidr：指 pod 网络的ip地址段，分配给每个pod (calico 默认：192.168.0.0/16，flannel默认：10.244.0.0/16)
```

- Kubernetes v1.28 支持自动检测 cgroup 驱动程序。
- Kubernetes官方推荐使用cgroup driver 为 systemd 。
- 从 v1.22 开始，在使用 kubeadm 创建集群时，如果用户没有在 KubeletConfiguration 下设置 cgroupDriver 字段，kubeadm 默认使用 systemd。

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

# 工作节点（node）加入集群的 join 命令，后面在工作节点中执行即可加入
Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.31.110:6443 --token abcdef.0123456789abcdef \
        --discovery-token-ca-cert-hash sha256:ea128656e12b2a88328158686d071907785599f0ed82f0e18f9603b7690b11f7 
```

#### 3.1.2 手动修改代理模式为 ipvs

> 如果初始化的时候，忘记了指定代理模式，则可以手动修改配置来指定 mode为 ipvs

1. 修改配置

    在 kube-proxy 的 ConfigMap 配置中，将 mode 字段的值更新为 "ipvs"

    `kubectl get configmaps -n kube-system kube-proxy -o yaml |sed 's/mode: ""/mode: "ipvs"/' |kubectl apply -f -`

    ```yaml
    apiVersion: v1
    data:
    config.conf: |-
        apiVersion: kubeproxy.config.k8s.io/v1alpha1
        ...
        kind: KubeProxyConfiguration
        ...
        #将 mode: "" 修改为 mode: "ipvs"
        mode: "ipvs"
        ...
    ```

2. 配置生效

    ```sh
    # 由于 kube-proxy 是以 Pod 形式运行的，修改完 ConfigMap 后，Kubernetes 将自动重新启动 kube-proxy Pod 以应用新的配置。
    kubectl get pods -n kube-system --show-labels |grep kube-proxy    #筛选
    # 或者手动删除 kube-proxy 的 Pod ，使其立即以应用新的配置重新创建，如下：
    kubectl delete pods -n kube-system -l k8s-app=kube-proxy    #删除
    ```

3. 验证功能

    检查日志，以 `kube-proxy-7wxcn` 为例：

    `kubectl logs -n kube-system kube-proxy-7wxcn |grep ipvs`

    ```sh
    I0821 03:07:27.736909       1 server others.go:269] "Using ipvs Proxier"
    I0821 03:07:27.736956       1 server others.go:271] "Creating dualstackProxier for ipvs"
    ```

    日志中出现此内容，则表示已经使用并创建了ipvs。

    验证 ipvs 功能是否正常

    `sudo ipvsadm -Ln`

    ```sh
    ...
    TCP  10.96.0.1:443 rr
    TCP  10.96.0.10:53 rr
    ```

### 3.2 加入工作节点（node）

在工作节点（node）中执行

- 添加工作节点

    ```sh
    #加入集群，在工作节点（node）上，分别执行 master 初始化日志中 join 命令
    sudo kubeadm join 192.168.31.110:6443 --token abcdef.0123456789abcdef \
            --discovery-token-ca-cert-hash sha256:ea128656e12b2a88328158686d071907785599f0ed82f0e18f9603b7690b11f7 

    #如果 join 命令忘记了，或者 token 过期，则去控制节点（master）重新创建新 token， 命令如下：
    sudo kubeadm token create --print-join-command
    ## 此结果与 master 初始化日志中的 join 命令同理（token有效期为24h）
    ```

- 配置工作节点 kubectl 工具环境（选配）

    ```sh
    #1. 将 master节点的 /etc/kubernetes/admin.conf 分别发送到工作节点（node）中，以 node01为例：
    sudo scp root@master:/etc/kubernetes/admin.conf /etc/kubernetes/

    #2. 配置 kubectl 工具环境
    echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> $HOME/.bashrc

    #3. 配置 admin.conf 文件权限
    sudo chown $USER /etc/kubernetes/admin.conf

    #4. 激活环境
    source $HOME/.bashrc
    ```

- 移除工作节点

    ```sh
    # Step 1：列出所有nodes
    kubectl get node -o wide

    # Step 2：删除节点 node02 （在控制平面节点 master 上）
    kubectl drain node02 --delete-emptydir-data --force --ignore-daemonsets
    #该命令的主要目的是安全地将 node02 节点上的 Pod 驱逐到集群中的其他节点，以便对该节点进行维护或升级。
    kubectl delete node node02

    # Step 3：重置配置（在移除的节点上执行）
    sudo kubeadm reset

    # Step 4：重新加入集群（join）
    ```

  - --delete-emptydir-data：删除使用 emptyDir 卷的 Pod 的数据
    - 默认情况下，drain 会保留 emptyDir 卷的数据
    - 使用此标志表示你确认可以删除这些临时数据
  - --force：强制排空，即使某些 Pod 不受 ReplicationController、ReplicaSet、Job、DaemonSet 或 StatefulSet 管理（通常用于排空那些没有控制器管理的 Pod）
  - --ignore-daemonsets：忽略 DaemonSet 管理的 Pod
    - 默认情况下，drain 不会处理 DaemonSet Pod（因为它们设计为在特定节点上运行）
    - 此标志明确告诉 kubectl 忽略它们而不是报错

### 3.3 重置节点配置

1. 重置节点

    当 master 节点初始化失败，或 node 节点加入集群失败，则重置

    `sudo kubeadm reset`

2. 清理配置

    ```sh
    #1. 清理残留文件（可选但推荐）
    sudo rm -rf /etc/cni/net.d        #清理 CNI 配置
    sudo rm -rf /var/lib/kubelet      #清理 kubelet 数据
    sudo rm -rf /var/lib/etcd         #如果节点曾是 etcd 成员
    sudo rm -rf /etc/kubernetes       #清理 kubeconfig 等配置
    sudo rm -rf $HOME/.kube           #清理 kubectl 配置
    
    #2. 清理 IPVS 表（如果使用 IPVS）
    sudo ipvsadm --clear
    
    #3. 重置网络接口（如有必要）
    #如果使用了 Calico、Flannel 等 CNI 插件，可能需要手动清理网络接口和 iptables 规则：
    sudo ip link delete [name] 接口名
    sudo iptables -F && sudo iptables -t nat -F
    ```

### 3.4 安装 Pod 网络插件（CNI）

- [Calico 安装文档](https://docs.tigera.io/calico/3.28/getting-started/kubernetes/self-managed-onprem/onpremises "Install Calico")
- [Calico 版本兼容](https://docs.tigera.io/calico/3.28/getting-started/kubernetes/requirements#kubernetes-requirements "Kubernetes requirements")

```sh
# [Calico-v3.25版本的yaml文件](https://docs.projectcalico.org/manifests/calico.yaml)

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
```

- calico 默认 pod 网络地址：192.168.0.0/16
- [flannel 插件](https://github.com/flannel-io/flannel/blob/master/Documentation/kube-flannel.yml) 默认 pod 网络地址：10.244.0.0/16

</br>

## 四、K8S 集群测试

### 4.1 查看集群状态

`kubectl get nodes [-o wide]`

### 4.2 部署 nginx 测试

```sh
#1. 部署 nginx
kubectl create deployment nginx-app --image=nginx

#2. 查看 nginx 状态
kubectl get deployment nginx-app

#3. 将 deployment 暴露出去
kubectl expose deployment nginx-app --type=NodePort --port=80
## 采用 NodePort 的方式（这种方式会在每个节点上开放同一个端口，外部可以通过节点 ip+port 的方式进行访问）

#4. 检查 service 的状态
kubectl get svc nginx-app
kubectl describe svc nginx-app
kubectl get pod,svc

#5. 访问 nginx
# nginx 副本扩容
kubectl scale deployment nginx --replicas=3
kubectl get pods
```

</br>

## 五、可视化工具部署（kuboard）

[安装 Kubernetes 多集群管理工具 - Kuboard v3](https://kuboard.cn/install/v3/install.html "Kuboard v3")



### FAQ

1. kuboard-v3 无法启动："transport: Error while dialing dial tcp: missing address"

编辑 ConfigMap kuboard-v3-config 配置，将 KUBOARD_SERVER_NODE_PORT 配置项改成 KUBOARD_ENDPOINT 如下：

```sh
#KUBOARD_SERVER_NODE_PORT: '30080' 
KUBOARD_ENDPOINT: 'http://your-node-ip-address:30080'
```

notes:

- <https://github.com/eip-work/kuboard-press/issues/328>
- <https://github.com/eip-work/kuboard-press/issues/449>


</br>
</br>

Via

- <https://znunwm.top/archives/k8s-xiang-xi-jiao-cheng>
- <https://huangzhongde.cn/istio/Chapter1/Chapter1-3.html>
- <https://zhaoyb-coder.github.io/k8s/2146b0>
- <https://www.cnblogs.com/nolenlinux/articles/18437173>
