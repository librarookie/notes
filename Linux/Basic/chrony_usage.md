# Linux 系统时间同步 -- Chrony

> Chrony 是一个开源的 `时间同步工具`，用于在 Linux 系统上实现高精度的 `NTP（Network Time Protocol）` 客户端和服务器功能。它比传统的 `ntpd`（NTP Daemon）更灵活、更高效，特别适用于不稳定的网络环境（如移动设备、虚拟机或间歇性连接的系统）。

</br>
</br>

## 一、介绍

1. 核心组件

   - （1）chronyd（守护进程）
      - 负责时间同步，可运行在客户端或服务器模式。
      - 支持动态调整系统时钟频率，减少时间漂移。
      - 对网络延迟和波动有更好的适应性。
   - （2）chronyc（命令行工具）
      - 用于监控和配置 chronyd，提供交互式命令查看或修改同步状态。

2. 主要优势

   - 快速同步：在系统启动时能更快同步时间（相比 ntpd）。
   - 低资源占用：适合嵌入式设备或虚拟机。
   - 容忍网络不稳定：能处理间歇性网络连接，适应高延迟或波动的网络。
   - 支持硬件时间戳：提高局域网内时间同步的精度（可达微秒级）。
   - 安全性：支持 NTP 的认证机制（如 keyfile）。

3. 常见使用场景

   - 作为 NTP 客户端：从公共 NTP 服务器（如 pool.ntp.org）同步时间。
   - 作为 NTP 服务器：为内网其他设备提供时间服务。
   - 离线环境：通过本地硬件时钟（如 RTC）维护时间。

</br>

## 二、配置

1. 验证 NTP 服务器是否可用

    ```sh
    #检查网络连通性
    ping 192.168.31.110

    #检查 NTP 端口 '123' 是否开放
    nc -zv 192.168.31.110 123

    #开放目标服务器 123 端口（或者关闭防火墙）
    sudo iptables -A INPUT -p tcp --dport 123 -j ACCEPT
    #手动保存防火墙规则
    sudo service iptables save
    ```

    如果 ping 通但 nc 失败，可能是 NTP 服务未运行或防火墙阻止。

2. 设置时区

   ```sh
   #列出所有时区
   timedatectl list-timezones

   #设置时区
   sudo timedatectl set-timezone Asia/Shanghai

   #查看时区
   timedatectl
   ```

3. 基本配置（/etc/chrony.conf）

    ```sh
    # 时间源，使用阿里云NTP服务器
    #server ntp.aliyun.com  iburst
    #server ntp1.aliyun.com iburst
    #server ntp2.aliyun.com iburst
    pool   ntp.aliyun.com  iburst maxsources 3  prefer

    # 使用本地硬件时钟作为时间源（当外部源不可用时作为备用）
    server 127.127.1.0  iburst
    #本地时钟的层级设为 10（0-15，0最高；仅在其他源全部失效时使用）
    local stratum 10

    # 允许内网特定网段同步
    allow 192.168.31.0/24

    # 记录时间偏差
    driftfile /var/lib/chrony/drift

    # 如果系统时钟偏差太大，则步进调整而不是渐进调整
    makestep 1.0 3

    # 启用实时时钟（RTC）同步
    rtcsync

    # 日志目录
    logdir /var/log/chrony
    ```

    `pool   ntp.aliyun.com  iburst maxsources 3  prefer`

    - server 指定单个 NTP 服务器地址。可以添加多个 server 行以实现冗余。
    - pool 指定一个 NTP 服务器池（域名会自动解析到多个地址），适合负载均衡和高可用（推荐）
    - maxsources：通常配合 pool 使用，限制使用的服务器数量（如 maxsources 3）
    - iburst：启动时快速同步（加速初始时间校准）。
    - prefer：标记为首选服务器。
    - offline：手动指定服务器为离线状态（不尝试同步）

    NTP 的约定规范：

    - NTP 协议定义了一组特殊的 IP 地址范围 127.127.x.x，专门用于表示本地硬件时钟（Local Clock Driver）。这些地址不会与真实网络冲突。
    - 127.127.1.0 是其中最常见的地址，表示第一个本地时钟源。
    - 如果有多块硬件时钟，可以用 127.127.1.1、127.127.1.2 等。

4. 常用命令

    ```sh
    #查看同步状态，时区等
    timedatectl

    #手动指定优先源（临时添加）
    sudo chronyc add server 192.168.31.110 iburst
    #强制发起一轮突发同步
    sudo chronyc burst 2/2

    #手动同步时间
    chronyc makestep

    #查看时间源（^*：当前最优时间源）
    chronyc sources -v
    
    #检查同步状态（显示时间源、偏移量、延迟等信息）
    chronyc tracking

    #查看连接的客户端（在服务器上执行）
    sudo chronyc clients

    #重启 chronyd
    sudo systemctl restart chronyd
    ```

</br>

## 三、例子

场景：使用 chrony 给 4 台服务器配置时间同步，服务器如下：

- s1: 192.168.31.110
- s2: 192.168.31.111
- c1: 192.168.31.112
- c2: 192.168.31.113

配置方案

在这个配置中，我们将：

- s1 和 s2 配置一主一备，作为时间服务器（可能连接到外部NTP服务器或使用本地时钟）
- s2 同时作为客户端，从 s1 中同步时间。
- c1 和 c2 作为客户端，从 s1 中同步时间；当 s1 挂了，则从 s2 中同步时间。。

1. 配置主时间服务器 s1

    ```sh
    # 时间源，使用阿里云NTP服务器
    pool   ntp.aliyun.com  iburst maxsources 3

    # 使用本地硬件时钟作为时间源（当外部源不可用时作为备用）
    server 127.127.1.0     iburst
    #本地时钟的层级设为 10（0-15，0最高；仅在其他源全部失效时使用）
    local stratum 10

    # 允许内网特定网段同步
    allow 192.168.31.0/24

    # 记录时间偏差
    driftfile /var/lib/chrony/drift
    # 如果系统时钟偏差太大，则步进调整而不是渐进调整
    makestep 1.0 3
    # 启用实时时钟（RTC）同步
    rtcsync
    # 日志目录
    logdir /var/log/chrony
    ```

2. 配置备时间服务器 s2

    ```sh
    pool   ntp.aliyun.com  iburst maxsources 3
    server 192.168.31.110  iburst prefer
    server 127.127.1.0     iburst
    local stratum 10

    allow 192.168.31.0/24

    driftfile /var/lib/chrony/drift
    makestep 1.0 3
    rtcsync
    logdir /var/log/chrony
    ```

3. 配置客户端 c1, c2

    ```sh
    server   192.168.31.110  iburst prefer
    server   192.168.31.111  iburst

    driftfile /var/lib/chrony/drift
    makestep 1.0 3
    rtcsync
    logdir /var/log/chrony
    ```

4. 配置完重启生效 chrony 服务

    `sudo systemctl restart chronyd`

5. 验证时间源

    - 方式一、去 ntp 时间服务器中，查看连接的客户端

        `sudo chronyc clients`

    - 方式二、在自己服务器中查看时间源（^*：当前最优时间源）

        `chronyc sources -v`

</br>
</br>
