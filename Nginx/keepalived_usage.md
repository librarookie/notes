# Keepalived 的高可用配置与使用

</br>
</br>

> Keepalived 是一个免费开源的，用C编写的类似于layer3, 4 & 7交换机制软件，具备我们平时说的第3层、第4层和第7层交换机的功能。主要提供 loadbalancing（负载均衡）和 high-availability（高可用）功能，负载均衡实现需要依赖Linux的虚拟服务内核模块（ipvs），而高可用是通过VRRP协议实现多台机器之间的故障转移服务。

Keepalived 是一款专注于提升网络服务可靠性的开源软件，特点如下：

- 核心功能：提供负载均衡和高可用性服务，适用于基于 Linux的系统和网络架构。
- 编程语言：Keepalived 采用 C 语言编写，保证了其高性能和稳定性。
- 负载均衡：基于 Linux内核模块技术（IPVS, IP Virtual Server），实现第四层（传输层）的负载均衡，有效分配网络流量。
- 健康检查：内置多种健康检查机制，能够实时监控后端服务器的运行状态，通过预设的检查策略来确保服务的稳定性。
- 高可用性：通过实现虚拟路由冗余协议（VRRP），Keepalived 能够在主备服务器之间实现快速的故障转移，保障网络服务的连续性。
- 故障检测：集成了边界网关检测协议（BFD, Bidirectional Forwarding Detection），用于快速检测网络故障，并触发 VRRP 状态转换，以实现更快的故障恢复。
- 灵活性：Keepalived 的架构设计模块化，各个功能模块可以独立使用，也可以组合使用，以适应不同的网络环境和需求。
- 扩展性：提供了钩子机制，允许用户自定义脚本和程序，以扩展和定制 VRRP 的行为。

</br>

## 一、安装

> Keepalived支持源码安装，同时也可以通过不同操作系统安装工具进行安装。

### 1.1 在线安装（yum安装）

> 此处以 CentOS 的 yum工具为例进行安装介绍。

```sh
yum install -y keepalived
```

### 1.2 离线安装（编译安装）

1. 下载安装包

    [Keepalived 官网下载地址](https://www.keepalived.org/download.html "前往官网")

2. 解压并安装

    ```sh
    #1. 解压：将安装包上传到服务器的 $HOME 目录，并解压
    tar -zxvf $HOME/keepalived-2.0.18.tar.gz

    #2. 安装配置：使用 configure命令配置"安装目录"与"核心配置文件"所在位置
    cd $HOME/keepalived-2.0.18/    #进入解压目录
    ./configure --prefix=/usr/local/keepalived --sysconf=/etc
    #--prefix：指定 keepalived 的安装位置
    #--sysconf：指定 keepalived 核心配置文件所在位置（固定位置，只能使用/etc）

    #如果出现安装 libnl/libnl-3 的警告，则安装 `yum -y install libnl libnl-devel`后，重新在 configure一下。

    #3. 编译并安装 keepalived
    make && make install

    #4. 系统服务配置：把 Keepalived 注册为系统服务
    #4.1 将 Keepalived 的系统配置文件，拷贝至系统 /etc 目录
    cp $HOME/keepalived-2.0.18/keepalived/etc/init.d/keepalived /etc/init.d/
    cp $HOME/keepalived-2.0.18/keepalived/etc/sysconfig/keepalived /etc/sysconfig/

    #4.2 刷新系统服务，加载新添加的 Keepalived 服务
    sudo systemctl daemon-reload
    ```

</br>

## 二、配置

> 配置文件 `/etc/keepalived/keepalived.conf` 中主要由全局段、VRRP实例段、脚本段组成

配置文档：<https://keepalived.org/manpage.html>

### 2.1 全局配置（global_defs）

> 允许用户设置全局相关信息，例如邮件通知信息、关键参数配置等，该段配置在Master节点和Backup节点上应当一致。

```sh
! Configuration File for keepalived

global_defs {       #全局配置标识（如果下面的配置都不用，此模块也可以删除）
    notification_email {    #设置报警的邮件地址（依赖本机的 sendmail服务）
        acassen@firewall.loc    #keepalived 发生故障切换时邮件发送的目标邮箱，可以按行区分写多个
        failover@firewall.loc
        sysadmin@firewall.loc
    }
    notification_email_from Alexandre.Cassen@firewall.loc   #邮件的发送地址
    smtp_server 192.168.106.1   #邮件SMTP服务器地址
    smtp_connect_timeout 30     #连接超时时间（邮件SMTP服务器）
    router_id LVS_DEVEL      #标识此节点机器的字符串（不必是主机名，默认：本地主机名）
    vrrp_skip_check_adv_addr    #对所有通告报文都检查，会比较消耗性能（启用后，如果收到的通告报文和上一个报文是同一个路由器，则跳过检查，默认值为全检查）
    vrrp_strict         #严格遵守VRRP协议，默认会导致 VIP 无法访问（建议注释此项配置）
    vrrp_garp_interval 0    #报文发送延迟，0表示不延迟
    vrrp_gna_interval 0     #消息发送延迟
}
```

vrrp_strict （建议不加此项配置）：严格遵守VRRP协议，启用此项后以下状况，将无法启动服务:

1. 无 VIP 地址
2. 配置了单播邻居
3. 在VRRP版本2中有IPv6地址，开启动此项并且没有配置vrrp_iptables时会自动开启iptables防火墙规则，默认导致VIP无法访问

如果不配置邮件报警，主备主机名不重复时，可以省略 global_defs 块，router_id 默认使用本机主机名。

### 2.2 虚拟路由配置（vrrp_instance）

> 此部分主要用来定义具体服务的实例配置，包括 Keepalived主备状态、接口、优先级、认证方式和 VIP信息等
> </br> 1. 每个 VRRP实例可以认为是 Keepalived服务的一个实例， 或作为一个业务服务，在一组 Keepalived服务配置中，VRRP实例可以有多个。
> </br> 2. 存在于 Master节点中的 VRRP实例配置在 Backup节点中也要有一致的配置（除了节点角色、优先级不同），这样才能实现故障切换转移

```sh
vrrp_instance VI_1 {    #VRRP实例名并设定实例名称（一般为业务名称）
    state MASTER    #设定初始VRRP实例角色，表示主机初始状态名称是MASTER（主机 MASTER/备机 BACKUP）
    interface eth0    #该实例绑定的网卡名称
    virtual_router_id 51    #虚拟路由ID标识，范围 0-255；同一VRRP实例中主备设置必须一致，否则将出现脑裂问题；
    priority 100    #优先级设定，权重值范围 1-254，数字越大，表示实例优先级越高；同一个VRRP实例中，Master节点优先级要高于Backup节点；
    advert_int 1    #主备之间同步检查时间间隔，单位秒
    authentication {    #认证机制，防止非法节点进入（同一个VRRP实例的MASTER和BACKUP使用相同的密码才能正常通信）
        auth_type PASS    #认证类型有PASS(Simple Passwd)和AH(IPSEC)，官方推荐PASS，验证密码为明文方式，最多8位
        auth_pass 1111
    }
    virtual_ipaddress {    #虚拟IP，可以有多个（vip），VIP将绑定至interface参数配置的网络接口上
        192.168.106.16    #指定VIP，不指定网卡，默认eth0；不指定/prefix, 默认/32
        192.168.106.17/24 dev eth1      #指定VIP，网卡
        192.168.106.18/24 dev eth2 label eth2:1     #指定VIP，网卡，label
        #<IPADDR>/<PREFIX> brd <IPADDR> dev <STRING> scope <SCOPE> label <LABEL>
    }

    track_script {    #根据 vrrp_script 的结果，去调整资源优先级
        check_haproxy     #调用脚本
    }

    nopreempt    #非抢占模式（默认为抢占模式），同一VRRP实例中主备设置必须一致。
    preempt_delay 2    #抢占模式的延迟时间，单位秒，范围0~1000；发现低优先级MASTER后，多少秒开始抢占。

    notify_master <script>    #当前节点成为"主节点"时，触发脚本script（脚本需要自定义）
    notify_backup <script>    #当前节点转为"备节点"时，触发脚本script（脚本需要自定义）
    notify_fault <script>    #当前节点出现故障时，触发脚本script（脚本需要自定义）
    notify_stop <script>     #当前VRRP实例停止时，触发脚本script（脚本需要自定义）
}
```

脑裂现象（通常发生在 VRRP（虚拟路由冗余协议）环境中）：当两个或多个路由器同时声明自己是虚拟路由器的主实例时，它们会争夺虚拟IP 地址的控制权，导致网络通信中断或数据包丢失。

- 配置错误：如果 Keepalived 实例的配置不正确，例如使用了相同的虚拟路由器ID（vartul_router_id）或优先级（priority），它们可能会争夺虚拟 IP 地址的控制权。
- 通信故障：当Keepalived 实例之间的通信中断时（网络或硬件故障），每个实例都可能认为自己是主实例，因为没有收到其他实例的心跳信号。
- 软件故障：Keepalived 或 VRRP 协议的软件故障也可能导致脑裂现象。

主备的切换模式：抢占式和非抢占式

- 抢占模式（默认）：当高优先级节点恢复后，会抢占低优先级节点成为MASTER；
- 非抢占模式：允许低优先级节点继续担任MASTER。

### 2.3 自定义服务检测脚本（vrrp_script）

> 默认情况下，Keepalived仅仅在节点宕机，或 Keepalived进程停掉的时候，才会启动切换机制。
> </br> 但在实际工作中，有业务服务停止，而 Keepalived服务还存在的情况，这就会导致用户访问的 VIP无法找到对应的服务。
> </br> 这时可以利用 Keepalived 触发预制的监测脚本，实现 VIP漂移来继续提供服务。

```sh
vrrp_script check_haproxy {    #自定义脚本并设定脚本名称，脚本可被多个实例调用。
    script "/usr/bin/killall -0 haproxy"    #自定义服务监控脚本，通过监控脚本返回的状态码，来识别集群服务是否正常；如果返回状态码是0，则服务正常，反之亦然。
    #script "/usr/bin/nc -nzv -w 2 127.0.0.1 5000"    #使用 netcat (nc) 命令来检查本地主机上的端口 5000 是否处于监听状态。
    interval 3    #脚本检查的间隔时间（监控间隔，单位为秒）。
    fall 3    #失败次数：设置判定 script结果为"失败"时的次数。
    rise 2    #成功次数：设置判定 script结果为"成功"的次数。
    timeout 1    #可选，脚本执行的超时时间，单位为秒。如果脚本在指定的时间内没有完成，它将被视为失败。
    weight -10    #可选，设置当监控脚本执行结果为失败时，触发 priority值调整（|weight值| > 主 - 备），正数为增加优先级，负数为降低优先级，范围-255~255。
}
```

命令 nc（netcat）参数介绍：

- n： 不进行 DNS 解析。（直接使用 IP 地址）
- z： 以扫描模式检查端口。（不发送数据）
- v： 显示详细信息。
- w 2： 设置超时时间为 2 秒。

### 2.4  配置独立日志文件（利用rsyslog服务）

> 默认日志存放在系统日志：/var/log/messages
> </br> 如果ubuntu 没有 /var/log/messages 文件，则将 /etc/rsyslog.d/50-default.conf 中 -/var/log/messages 项放开

1. 配置 keepalived 日志选项

    ```sh
    #将 /etc/sysconfig/keepalived 文件中的 KEEPALIVED_OPTIONS 行，改为 KEEPALIVED_OPTIONS="-D -S 0"
    sudo sed -i '/KEEPALIVED_OPTIONS/c\KEEPALIVED_OPTIONS="-D -S 4"' /etc/sysconfig/keepalived
    ```

    - `-D, --log-detail`    #详细日志信息。
    - `-S, --log-facility`  #设置本地系统日志设备0-7，即 -S 4 为 local4（默认值：LOG_DAEMON）

2. 配置 rsyslog 日志规则

    在 rsyslog 服务的配置中，添加 keepalived服务的日志配置，如：

    `local4.*    /var/log/keepalived.log`

    ```sh
    #方法一、新建 /etc/rsyslog.d/keepalived.conf 并配置
    echo 'local4.*    /var/log/keepalived.log' |sudo tee /etc/rsyslog.d/keepalived.conf


    #方法二、在 /etc/rsyslog.conf 文件的 “RULES” 下面追加配置
    sudo sed -i '/RULES/a\\n\local4.*    /var/log/keepalived.log' /etc/rsyslog.conf
    ```

    - `local4`  #网络设备，如：路由器、交换机日志
    - `local0-local2`：核心业务应用，`local3-local5`：基础设施/中间件，`local6-local7`：开发调试/临时日志
    - `local4.*`  #记录local4设施的所有优先级（生产环境通常记录到 `info` 级别，调试时临时开启 `debug` 级别）
      - `local4.error`  #错误情况，如：应用程序错误、IO操作失败
      - `local4.warning`  #警告情况，如：磁盘空间不足、非关键故障
      - `local4.notice`  #正常但重要的情况，如：服务启动/停止、配置变更
      - `local4.info`  #一般信息性消息，如：运行状态信息、统计数据
      - `local4.debug`  #调试级信息，如：开发调试信息、详细流程跟踪

3. 重启生效

    ```sh
    #重启 keepalived 和 rsyslog 服务
    sudo systemctl restart keepalived rsyslog

    #后续 keepalived 活动后，检查日志：
    tail -f /var/log/keepalived.log
    ```

### 2.5  实现独立配置文件（include）

> 当生产环境复杂时， /etc/keepalived/keepalived.conf 文件中内容过多，不易管理，可以将不同集群的配置
> </br> 比如：不同集群的VIP配置放在独立的子配置文件中，利用include 指令可以实现包含子配置文件，格式如下:
> </br> include /path/file

1. 添加子文件配置

    vim /etc/keepalived/keepalived.conf

    ```sh
    #此处将不需要的全局配置都删除了（如果主备主机名不重复，此模块也可以删除）
    global_defs {
        router_id LVS_DEVEL    #默认值是本地主机名
    }

    vrrp_script check_haproxy {
        script "/usr/bin/killall -0 haproxy"
        interval 5
        fall 3
        rise 1
    }

    vrrp_instance VI_1 {
        state MASTER
        interface eth0
        virtual_router_id 51
        priority 100
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
        virtual_ipaddress {
            192.168.106.16
        }

        track_script {
            check_haproxy
        }
    }

    include /etc/keepalived/keepalived.conf.d/*.conf   #引入相关子配置文件
    #include keepalived.conf.d/*.conf   #绝对路径与相对路径都行
    ```

2. 新建子配置目录与文件

    ```sh
    # 创建子配置目录
    mkdir /etc/keepalived/keepalived.conf.d

    # 创建子配置文件
    touch /etc/keepalived/keepalived.conf.d/192.168.106.18.conf
    ```

3. 添加子配置内容

    ```sh
    tee /etc/keepalived/keepalived.conf.d/192.168.106.18.conf <<-EOF
    vrrp_script check_port {    #子配置文件的检测脚本，也可以使用keepalived.conf文件内的
        script "/usr/bin/nc -nzv -w 2 127.0.0.1 5000"
        interval 5
        fall 3
        rise 1
    }

    vrrp_instance VI_2 {    #第二个VRRP实例
        state MASTER
        interface eth0
        virtual_router_id 61    #同一VRRP实例中主备设置必须一致
        priority 100
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
        virtual_ipaddress {
            192.168.106.18
        }

        track_script {
            check_port
        }
    }
    EOF
    ```

    命令 `nc -nzv -w 2 127.0.0.1 5000` 的作用是：

     - 不进行 DNS 解析。
     - 以扫描模式检查端口。
     - 显示详细信息。
     - 设置超时时间为 2 秒。
     - 检查本地主机（127.0.0.1）上的端口 5000 是否开放。

4. 重启生效

    ```sh
    sudo systemctl restart keepalived
    ```

</br>

## 三、实例

### 3.1 服务器环境配置

```sh
#1. 禁用SElinux、关闭防火墙。（或增加一条防火墙规则放行多播）
sudo sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
sudo setenforce 0

sudo systemctl disable --now firewalld

#2. 配置节点时间同步
sudo yum -y install chrony
sudo systemctl enable --now chronyd

#3. 确保 Keepalived 使用的网卡 eth0 开启了多播
ip link show eth0       #查看网卡 eth0
ip link set multicast on dev eth0   ##启用网卡 eth0 的多播 multicast
```

### 3.2 主备机高可用配置

编辑主备的配置文件（/etc/keepalived/keepalived.conf），并重启服务

1. 主机配置内容

    ```sh
    ! Configuration File for keepalived

    global_defs {
        router_id LVS_DEVEL_MASTER
    }

    vrrp_script check_haproxy {
        script "/usr/bin/killall -0 haproxy"    #检查脚本
        interval 3    #脚本执行间隔
        fall 3    #失败次数
        rise 1    #成功次数
        timeout 2    #脚本执行超时时间
        weight -11    #优先级调整，priority数值加减（主机priority - 备机priority < weight）
    }

    vrrp_instance VI_1 {
        state MASTER
        interface eth0    #虚拟网卡桥接的真实网卡
        virtual_router_id 51    #同一VRRP实例中主备设置必须一致
        priority 100    #初始优先级设定
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
        virtual_ipaddress {
            192.168.31.199      #对外提供的虚拟IP
        }

        track_script {    #根据vrrp_script结果，调整服务
            check_haproxy
        }
    }
    ```

2. 备用机配置内容

    ```sh
    ! Configuration File for keepalived

    global_defs {
        router_id LVS_DEVEL_BACKUP
    }

    vrrp_script check_haproxy {
        script "/usr/bin/killall -0 haproxy" 
        interval 3
        fall 3
        rise 1
        timeout 2
        weight -11
    }

    vrrp_instance VI_1 {
        state BACKUP
        interface ens33    #虚拟网卡桥接的真实网卡
        virtual_router_id 51
        priority 90    #优先级设定
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
        virtual_ipaddress {
            192.168.31.199      #对外提供的虚拟 VIP
        }

        track_script {    #根据vrrp_script结果，调整服务
            check_haproxy
        }
    }
    ```

### 3.3 VIP漂移验证

> VIP漂移：VIP会在发生故障的时候自动切换到备用机器。
> </br> 配置正常下，只需关注 vrrp_script 的脚本即可。

1. 模拟主机服务意外关闭

    ```sh
    #1. 查看 MASTER 服务器网卡 eth0
    ip addr show eth0

    #2. 停用 MASTER 服务器的 keepalived 服务（或者将MASTER服务器关机）
    sudo systemctl stop keepalived

    #3. 查看 BACKUP 服务器网卡 ens33（检查 VIP 是否漂移到备用机）
    ip addr show ens33
    ```

2. 使用其他服务验证：配置为本文的 3.2 小节，监控 haproxy 服务

    ```sh
    #1. 查看 MASTER 服务器网卡 eth0
    ip addr show eth0

    #2. 停用 MASTER 服务器的 haproxy 服务（或者将MASTER服务器关机）
    sudo systemctl stop haproxy

    #3. 查看 BACKUP 服务器网卡 ens33（检查 VIP 是否漂移到备用机）
    ip addr show ens33
    ```

3. 使用 web 服务验证

    ```sh
    #1. 准备两个web服务，比如:
    主机web1: <http://192.168.31.110:8080/index.html>
    备机web2: <http://192.168.31.112:8080/index.html>

    #2. 更新 3.2 小节的 vrrp_script 中的 script 内容即可，如：
    vrrp_script check_haproxy {
        script "wget -q --spider 127.0.0.1:8080/index.html"    #脚本返回值，0成功
        interval 3
        fall 3
        rise 1
        timeout 2
        weight -11
    }

    #3. 访问 VIP:8080/index.html
    curl 192.168.31.199:8080/inde.html

    #4. 停止主机的的web1 服务，然后再访问，查看index.html是否更新
    curl 192.168.31.199:8080/inde.html
    ```

    命令 `wget -q --spider 127.0.0.1:8080/index.html` 的作用是：

      - 静默模式下（-q）
      - 模拟访问（--spider）本地主机 127.0.0.1 的 8080 端口上的 index.html 文件。
      - 该命令不会下载文件，只会检查文件是否存在，并返回服务器的响应状态码。

</br>
</br>

Via

- <https://www.cnblogs.com/hahaha111122222/p/16415900.html>
- <https://www.cnblogs.com/christopherchan/p/12953230.html>
- <https://www.cnblogs.com/KingArmy/p/17926534.html>
- <https://zhuanlan.zhihu.com/p/566166393>
