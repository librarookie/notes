# Linux_配置IPv4或IPv6地址

</br>
</br>

## 配置

### 配置介绍

- 查看网络
    > ifconfig

- 网卡介绍
  - `eth0` ：本地网卡（CentOS7 是ens33）
  - `lo` ：内网网卡，管理内网IP，也就是127.0.0.1地址
  - `virbr0` ：虚拟网卡
- 配置文件 `ifcfg-<interface>`
  - `ifcfg-eth0` ：网卡 `eth0` 的配置文件（`ipv4` 和 `ipv6` 都是配置此文件）
  - `ifcfg-lo` ：网卡 `lo` 的配置文件

    Tips: 配置文件在目录 `/etc/sysconfig/network-scripts/` 下;

### 自动获取地址

> IPv4 是默认开启动自动获取地址的，无需配置；以下是开启IPv6 的自动获取配置

1. 修改 `/etc/sysconfig/network` 文件

    ```md
    # 启用网络 IPv4
    NETWORKING=yes

    # 启用网络 IPv6，没有则加上，部分机器是默认开启的
    NETWORKING_IPV6=yes

    # 主机名, 重启生效
    HOSTNAME=localhost.localdomain
    ```

2. 修改 `/etc/sysconfig/network-script/ifcfg-eth0` 文件

    ```md
    # 是否开机启用 ipv6地址
    IPV6INIT=yes
    ```

3. 重启网卡并测试

### 静态地址

> 静态地址是在自动获取地址的 `ifcfg-<interface>` 文件内添加静态IP配置

- 编辑文件
    > vim /etc/sysconfig/network-scripts/ifcfg-eth0

  - 添加 IPv4 配置

    ```md
    DNS1=192.168.0.1
    IPADDR=192.168.1.188
    PREFIX=24
    ```

    Tips: 配置静态IP需要修改 `BOOTPROTO=static`

  - 添加 IPv6 配置

    ```md
    IPV6INIT=yes
    IPV6_AUTOCONF=no
    IPV6_FAILURE_FATAL=no
    IPV6ADDR=2001:250:250:250:250:250:250:222/64
    IPV6_DEFAULTGW=2001:250:250:250::1
    ```

- `ifcfg-ethX` 文件常用配置介绍

    ```md
    # 类型
    TYPE=Ethernet
    # 关联的接口名称，与 interface 保持一致
    DEVICE=eth0
    # 网络连接的名字
    NAME=eth0
    # 唯一标识
    UUID=b4701c26-8ea8-46a5-b738-1d4d0ca5b5a9
    # 自动连接，启动或者重启网络时是否激活此网卡
    ONBOOT=yes
    # 引导协议，表示使用哪种方式获取ip
    ### static | none: 使用静态方式获取
    ### dhcp：使用dhcp协议获取
    BOOTPROTO=static

    ## 配置信息 IPv4 配置
    # NDS 服务器
    DNS1=192.168.0.1
    # IP地址
    IPADDR=192.168.1.188
    # CentOS子网掩码长度：24 --> 255.255.255.0
    # NETMASK=255.255.255.0
    PREFIX=24
    # 默认网关
    GATEWAY=192.168.1.1
    # IP2, IP3 ...
    IPADDR2=192.168.2.23
    PREFIX2=24
    GATEWAY2=192.168.2.1
    # 如果ipv4配置失败禁用设备
    IPV4_FAILURE_FATAL=no
    # 就是default route，是否把这个网卡设置为ipv4默认路由
    DEFROUTE=yes


    # 是否使用IPV6地址：yes为使用；no为禁用
    IPV6INIT=yes
    # 是否自动连接 yes 自动， no手动
    IPV6_AUTOCONF=yes
    # 就是default route，是否把这个网卡设置为ipv6默认路由
    IPV6_DEFROUTE=yes
    # 如果ipv6配置失败禁用设备
    IPV6_FAILURE_FATAL=no
    IPV6_ADDR_GEN_MODE="stable-privacy"


    # 地址 ipv6 配置信息，如果不使用ipv6 可以不用配置
    IPV6_PEERDNS=yes
    IPV6_PEERROUTES=yes
    IPV6_PRIVACY=no
    ```

Tips:

- TYPE、BOOTPROTO、NAME、DEVICE、ONBOOT、IPV6INIT 这些必须存在；
- DNS1、IPADDR、GATEWAY、PREFIX/NETMASK 使用静态IP必须有这些配置；

### 临时地址

> 临时地址是指配置网络后，在系统重启或者网卡重启后失效;

[常用网络配置命令](https://www.cnblogs.com/librarookie/p/16256959.html "ip、ifconfig 和 route命令")

#### 配置 IPv4

1. ifconfig 配置

    - 配置ipv4临时地址
        1. ifconfig eth0 192.168.5.18 [up|down]
        2. ip addr add 192.168.5.18/24 dev eth0

    - 配置网关
        > route add -host 192.168.5.18 gw 192.168.5.1 dev eth0
        1. ip route add default via 192.168.5.1

#### 配置 IPv6

1. 检查 ipv6 模块
    - 查看是否加载了 ipv6模块
        > lsmod | grep ipv6

    - 如果没有加载，可执行该命令加载
        > modprobe ipv6

2. 配置

    - 配置临时 ipv6地址
        > ifconfig eth0 inet6 add IPV6ADDR

    - 配置 ipv6网关

        route [add|del] [-net|-host] [网段或主机][netmask mask] [gw default-ip] [dev 接口名称]

        route [add|del] default [gw nexthop]
        > route -A inet6 add default gw IPV6GATEWAY dev ethX

    - 栗子

        ```md
        ifconfig eth0 inet6 add 2001:250:250:250:250:250:250:222/64
        route -A inet6 add default gw 2001:250:250:250::1 dev eth0
        ```

</br>

## 重启网卡

- CentOS 7
    > systemctl restart network

- CentOS 6
    > service network restart

</br>

## 测试

- ping
    > ping | ping6 [-I interface] address

  - IPv4 测试 `ping [-I eth0] address`
    - ping 192.168.5.18

  - IPv6 测试 `ping6 [-I eth0] address`
    - ping6 2001:250:250:250:250:250:250:222

    Tips：也可以用命令 `ifconfig` 查看IPV6地址信息，系统不仅会自动分配一个“fe80:”开头的本地链路地址，还有一个我们手动配置的全球唯一的IPv6地址。

</br>
</br>

Reference

- <https://zhuanlan.zhihu.com/p/65226634>
- <https://blog.csdn.net/weixin_39676242/article/details/110257459>
