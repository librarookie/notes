# iptables 介绍与实战

> iptables是Linux内核中用于配置防火墙规则的工具。它基于Netfilter框架，可以对通过网络接口的数据包进行过滤、修改等操作。通过设置一系列规则，iptables能够控制哪些数据包可以进入或离开系统，从而实现网络安全防护等功能。

它主要工作在网络层，能够根据数据包的源地址、目的地址、协议类型（如TCP、UDP、ICMP等）、端口号等信息来决定如何处理数据包。

</br>
</br>

## 一、介绍

1. Netfilter

    Netfilter 是 Linux 内核中的一个框架，允许在内核空间对网络数据包进行过滤、修改和重定向。它是 Linux 防火墙的基础，提供了以下功能：

    - 数据包过滤：根据规则允许或阻止数据包通过。
    - 网络地址转换（NAT）：修改数据包的源或目标地址，常用于路由器和防火墙。
    - 数据包修改：如修改数据包的 TTL（Time to Live，生存时间）或 TOS（Type of Service，服务类型）。
    - 连接跟踪：跟踪网络连接状态，用于状态防火墙。

    Netfilter 通过钩子（hooks）在内核的网络协议栈中插入处理函数，这些钩子位于数据包处理的各个阶段，如接收、转发、发送等。

2. iptables

    iptables 是用户空间的工具，用于配置和管理 Netfilter 的规则。它通过命令行接口让用户定义数据包的处理规则，并将这些规则传递给内核中的 Netfilter。

    iptables有多个表，每个表包含一系列规则链（Chains），用于处理不同类型的任务。主要功能包括：

    - 定义规则：允许或阻止特定类型的数据包。
    - 管理链（Chains）：规则被组织成链，常见的链有 INPUT、OUTPUT 和 FORWARD。

    执行动作：如 ACCEPT、DROP、REJECT 等。

### 1.1 iptables 结构

简单地讲，tables 由 chains 组成，而 chains 又由 rules 组成。如下图所示：

![202503201444855](https://gitee.com/librarookie/picgo/raw/master/img/202503201444855.png)

iptables： 表（Tables）  ->  链（Chains）  ->  规则（Rules）.

数据包过滤匹配流程和规则链内部匹配原则：

- iptables 按照预定义的顺序依次检查规则链中的规则。
- 匹配到第一条符合条件的规则后，将停止后续规则的匹配并执行该规则的动作。
- 如果遍历整个链都没有匹配的规则，则执行该链的默认策略 (通常是 ACCEPT 或 DROP)。

### 1.2 四表五链架构

iptables 的核心架构由四个表和五个链组成，它们按照特定的优先级顺序处理数据包：

| 表名 | 功能 | 规则链 | 优先级 |
| ---- | ---- | ---- | ---- |
| filter </br>（过滤规则表） | 过滤数据包（默认表），决定是否允许数据包通过 | `INPUT`, `OUTPUT`, `FORWARD` | 低 |
| nat </br>（地址转换规则表） | 网络地址转换 (NAT)，例如 SNAT、DNAT | `PREROUTING`, `POSTROUTING`, `OUTPUT` | 中 |
| mangle </br>（修改数据标记位规则表） | 修改数据包的特定属性，例如 TTL、TOS 等 |  `PREROUTING`, `POSTROUTING`,`INPUT`, `OUTPUT`, `FORWARD` | 高 |
| raw </br>（跟踪数据表规则表） | 决定是否对数据包进行状态跟踪 | `PREROUTING`, `OUTPUT` | 最高 |

- INPUT（入站数据过滤）：处理进入防火墙本机的数据包。
- OUTPUT（出站数据过滤）：处理从防火墙本机将发出的数据包。
- FORWARD（转发数据过滤）：处理需要由防火墙本机，转发到其他地址的数据包。
- PREROUTING（路由前过滤）：在数据包进行路由选择之前，根据规则修改数据包的目标IP地址（destination ip address），通常用于DNAT(destination NAT)。
- POSTROUTING（路由后过滤）：在数据包进行路由选择之后，根据规则修改数据包的源IP地址（source ip address），通常用于SNAT（source NAT）。

数据包处理流程图:

![202503212157371](https://gitee.com/librarookie/picgo/raw/master/img/202503212157371.png)

### 1.3 规则（Rules）

牢记以下三点式理解iptables规则的关键：

- Rules 包括一个规则条件 和一个目标(target) .
- 如果满足条件，就执行目标(target)中的规则或者特定值。
- 如果不满足条件，就判断下一条 Rules。

</br>

## 二、iptables 语法

> 规则编写语法

完整语法：[IPTABLES 完整语法](#iptables-完整语法)

### 2.1 基本语法

```sh
iptables [-t table] command [chain] [rule-specification] [-j target]
```

- `table`:  指定操作的表，例如：
  - filter（默认）, nat, mangle, raw .
- `command`:  操作类型，例如：
  - -A (append), -I (insert), -D (delete), -R (replace), -L (list)
  - -F (flush), -P (policy), -E (rename), -X (delete chain), -Z (zero counters) .
- `chain`:  指定操作的链。
  - INPUT, OUTPUT, FORWARD, PREROUTING, POSTROUTING .
- `rule-specification`: 匹配条件，用于指定要处理的数据包特征，例如：
  - 源 IP 地址、目标端口等。
- `target`:  控制类型，指定匹配数据包后的动作，例如：
  - ACCEPT, DROP, REJECT, LOG, DNAT, SNAT, MASQUERADE, REDIRECT .

匹配条件（rule-specification）:

- `-p <protocol>`: 指定协议 (tcp, udp, icmp 等)。
- `-s <source>`: 指定源 IP 地址或网络。
- `-d <destination>`: 指定目标 IP 地址或网络。
- `--sport <port>`: 指定源端口。
- `--dport <port>`: 指定目标端口。

    匹配条件的扩展用法：[规则条件扩展语法](#规则条件扩展语法 "传送阵")

控制类型（target）:

- `ACCEPT`: 允许数据包通过。
- `DROP`: 丢弃数据包，不发送任何回应。
- `REJECT`: 拒绝数据包，并发送 ICMP 错误消息。
- `LOG`: 记录数据包的日志信息，通常和 `-j NFLOG` 或 `-j ULOG` 一起使用，用于将日志发送到特定的设施。
- `SNAT`、`DNAT`：用于源地址（source NAT）转换和目标地址(destination NAT)转换，主要用于nat表。
- `MASQUERADE`:  一种特殊的 SNAT，用于动态获取公网 IP 地址。
- `REDIRECT`:  将数据包重定向到本机的另一个端口。

### 2.2 常用参数介绍

#### 2.2.1 查看规则

```sh
##-L（list）列出指定链中的规则（如果不指定链，默认列出所有链中的规则：iptables -L）。例如：
#使用 -t 参数，指定查看的表，默认filter，
#使用 -n 参数以数字形式显示IP地址和端口号，
#使用 -v 参数显示详细信息，如数据包匹配次数等。
#使用 --line-numbers 参数，显示规则行号
iptables [-t filter] -L [-nv] [INPUT] [--line-numbers]
#列出 INPUT链中的所有规则。
iptables -L INPUT
```

#### 2.2.2 添加规则

```sh
##-P（policy）设置指定链的 默认策略。例如：
#将 INPUT链的默认策略设置为 DROP，即如果没有匹配的规则，所有进入的数据包都将被丢弃。
iptables -P INPUT DROP


##-p（protocol）指定数据包的协议类型。常见的协议有 tcp、udp、icmp 等。例如：
##-j（jump）指定当数据包匹配规则时要执行的动作。常见的动作有：ACCEPT：允许, DROP：丢弃等
#这表示丢弃所有进入的 ICMP 数据包，通常用于禁止所有 ping操作。
iptables -A INPUT -p icmp -j DROP

##-A（append） 用于在指定链的末尾添加一条规则。例如：
##--dport（destination port）指定目标端口号。例如：
#这条命令的意思是在 INPUT链的 末尾 添加一条规则，允许（ACCEPT）目标端口为22（SSH服务端口）的TCP数据包通过。
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

##-I（insert）用于在指定链的 指定位置 插入 一条规则。（如果没有指定位置，默认插入到链的开头）例如：
#这表示在INPUT链的 第一个位置 插入 一条规则，允许目标端口为80（HTTP服务端口）的TCP数据包通过。
iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT

##--sport（source port）指定源端口号。例如：
#允许源端口为 80 的 TCP 数据包通过。
iptables -A INPUT -p tcp --sport 80 -j ACCEPT

##-s（source）指定数据包的源地址。可以是IP地址、IP地址范围 或 主机名 等。例如：
#允许来自IP地址为192.168.1.100的数据包通过。
iptables -A INPUT -s 192.168.1.100 -j ACCEPT
iptables -A INPUT -s 192.168.1.100/24 -p tcp --dport 22 -j ACCEPT

##-d（destination）指定数据包的目的地址。例如：
#允许目标地址为192.168.1.100的数据包通过。
iptables -A INPUT -d 192.168.1.100 -j ACCEPT


##-i（in-interface）指定输入接口，例如：eth0
#当从eth0出去的，访问目的地址是 192.168.23.253 ，且 目的端口是80 的route，允许通过
iptables -A FORWARD -o eth0 -d 192.168.23.253 -p tcp --dport 80 -j ACCEPT

##-o（out-interface）指定输出接口
#当从eth0进来的，原地址是 192.168.23.253 ，且 目的端口是80 的route，允许通过
iptables -A FORWARD -i eth0 -s 192.168.23.253 -p tcp --dport 80 -j ACCEPT
```

#### 2.2.3 删除规则

```sh
##-D（delete）用于 删除 指定链中的一条规则。可以通过指定规则编号或直接指定规则内容来删除。例如：
#删除INPUT链的第一条规则
iptables -D INPUT 1
#删除INPUT链中匹配这条规则（允许目标端口为80的TCP数据包通过）的规则。
iptables -D INPUT -p tcp --dport 80 -j ACCEPT

##-F（flush）清空指定链中的所有规则。例如：
#清空 INPUT链中的所有规则。如果不指定链，默认清空所有链中的规则（iptables -F）。
iptables -F INPUT
```

#### 2.2.4 保存/恢复规则

```sh
service iptables save
iptables-save > /etc/iptables/rules.v4
iptables-restore < /etc/iptables/rules.v4
```

</br>

## 三、栗子

### 3.1 基本防火墙规则设置

```sh
#清空所有规则
iptables -F

#设置默认策略
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
#将 INPUT 和 FORWARD 链的默认策略设置为 DROP，这样没有匹配规则的数据包都会被丢弃，增强了系统的安全性。

#允许本地回环接口
iptables -A INPUT -i lo -j ACCEPT

#允许已建立的连接
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# 禁止外部 ICMP (ping) 本机
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
#这条规则丢弃所有进入的ICMP回显请求数据包，从而禁止外部主机ping本机。
# --icmp-type 指定 ICMP数据包的类型，不指定则操作所有类型，包括：
##      echo-request（ping 请求）
##      echo-reply（ping 回复）
##      destination-unreachable（目标不可达）等

#允许外部 SSH 连接本机
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
#这条规则允许外部主机通过TCP端口 22（SSH服务端口）连接到本机。

#允许外部访问本机的 HTTP 服务
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
#允许外部通过 TCP 端口 80（HTTP服务端口）访问本机的HTTP服务。
```

### 3.2 NAT相关规则

假设本机有一个公网IP地址为 192.0.2.1，内部有一台主机IP地址为 192.168.1.100，运行着一个HTTP服务（监听端口8080）

#### 3.2.1 端口转发（REDIRECT）

通常用于将外部访问的 HTTP 流量（端口 80）重定向到本机的另一个端口（例如 8080）。

```sh
#在路由前，将外部对本机某端口的访问（旧目标端口），转发到内部主机的端口（新目标端口）
iptables -t nat -A PREROUTING -p tcp --dport <旧目标端口> -j REDIRECT --to-port <新目标端口>

#将端口 80 转发至 8080
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080

#多端口转发：将端口  1000-2000 转发至 3000-4000，如：1001 -> 3001
iptables -t nat -A PREROUTING -p tcp --dport 1000:2000 -j REDIRECT --to-ports 3000-4000
```

#### 3.2.2 目标网络地址转换（DNAT）

DNAT（Destination NAT）：修改数据包的目的地址，通常用于将外部网络的公共 IP 地址映射到内部网络的私有 IP 地址。

- 可以用于将 `外部网络` 的请求，转发到 `内部网络` 的特定主机和服务。
- 可以用于将流量转发到另一个服务器（例如内网中的另一台机器）

```sh
#在路由前，将外部对 旧目标地址 的请求，转发到 新目标地址 的服务。
iptables -t nat -A PREROUTING -d <旧目标IP> -p tcp --dport <旧目标PORT> -j DNAT --to-destination <新目标IP>:<新目标PORT>

#当外部用户访问 “192.0.2.1:80” （旧目标地址）时，DNAT规则会将其修改为 192.168.1.100:8080 （新目标地址）。
##外部用户通过公网IP地址 192.0.2.1 访问本机的HTTP服务（端口80）。
##本机需要将请求转发到内部主机 192.168.1.100 的HTTP服务（端口8080）。
iptables -t nat -A PREROUTING -d 192.0.2.1 -p tcp --dport 80 -j DNAT --to-destination 192.168.1.100:8080

#这条规则在nat表的PREROUTING链中，将目标端口为 80 的数据包的目标地址，修改为 192.168.1.100，目标端口修改为8080。
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 192.168.1.100:8080

#转发流量到其他IP
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 192.168.1.200:80

#如果进来的route的访问 目的地址: 192.168.23.252:80 ,就进行DNAT转换，把 目的地址改为: 192.168.23.223:80
iptables -t nat -A PREROUTING -d 192.168.23.252 -p tcp --dport 80 -j DNAT --to-destination 192.168.23.223:80

#这条规则将所有进入的TCP端口 1000到2000 的流量重定向到 192.168.1.100 的 3000到4000 端口。
iptables -t nat -A PREROUTING -p tcp --dport 1000:2000 -j DNAT --to-destination 192.168.1.100 --to-ports 3000-4000
```

#### 3.2.3 源网络地址转换（SNAT）

SNAT（Source NAT）：修改数据包的源地址，通常用于将内部网络的私有 IP 地址转换为外部网络的公共 IP 地址。

MASQUERADE 会自动将数据包的源 IP 地址替换为网关的出接口 IP 地址（通常是公网 IP 地址），并且在数据包返回时，再将目标 IP 地址转换回原始的私有 IP 地址。

- 内部主机 192.168.1.100 需要访问外部网络。
- 本机需要将内部主机的源地址 192.168.1.100 修改为公网IP地址 192.0.2.1。

```sh
#在路由后，将内部源地主，转化成外部源地址
iptables -t nat -A POSTROUTING -s <内部源地址> -j SNAT --to-source <外部源地址>

#如果内部主机（192.168.1.100）要访问外部网络，而本机（网关）有一个公网IP地址192.0.2.1
#当内部主机 192.168.1.100 发送数据包到外部网络时，SNAT规则会将源地址 192.168.1.100 修改为 192.0.2.1。
iptables -t nat -A POSTROUTING -o eth0  -s 192.168.1.100 -j SNAT --to-source 192.0.2.1

#当 FORWARD 出来后，访问的 目的地址是 192.168.23.223，端口是80的。进行DNAT地址转换，把源地址改为 192.168.23.252
iptables -t nat -A POSTROUTING -d 192.168.23.223 -p tcp --dport 80 -j SNAT --to-source 192.168.23.252:80

#伪装流量（NAT）
#eth0：连接到互联网，具有公网 IP 地址。
#eth1：连接到局域网，IP 地址为 192.168.1.1。
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

### 3.3 防火墙日志

1. 配置日志存储位置

    默认情况下，iptables 日志会记录到 /var/log/messages 或 /var/log/syslog 中。为了方便管理，可以将 iptables 日志重定向到单独的文件。

    使用 rsyslog 配置

    ```sh
    #1. 编辑 /etc/rsyslog.conf 或 /etc/rsyslog.d/ 目录下的配置文件（例如 /etc/rsyslog.d/iptables.conf），添加以下内容：
    ##将 iptables 日志重定向到单独的文件
    :msg, contains, "IPTABLES" /var/log/iptables.log
    ##或者
    echo "kern.*     /var/log/iptables.log" >> /etc/rsyslog.conf

    #2. 保存文件后，重启 rsyslog 服务：
    service rsyslog restart
    ```

2. 配置 iptables 日志规则

    ```sh
    #1. 记录所有进入的流量
    iptables -A INPUT -j LOG --log-prefix "IPTABLES-INPUT: " --log-level 7

    #2. 记录所有出去的流量
    iptables -A OUTPUT -j LOG --log-prefix "IPTABLES-OUTPUT: " --log-level info

    #3. 记录所有转发的流量
    iptables -A FORWARD -j LOG --log-prefix "IPTABLES-FORWARD: "

    #4. 限制日志速率（避免日志过多）
    iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "IPTABLES-INPUT: "
    ```

    - --log-prefix：添加日志前缀。用于在日志消息前添加自定义前缀，便于区分不同的日志来源
    - --log-level：设置日志级别。指定日志的级别（优先级）。默认级别是 warning（4），可以根据需要调整
      - `emerg` `0` #紧急情况（系统不可用）
      - `alert` `1` #需要立即采取行动
      - `crit`  `2` #严重情况
      - `error` `3` #错误情况
      - `warn`  `4` #警告情况（默认级别）
      - `notice` `5` #正常但重要的情况
      - `info`  `6` #一般信息
      - `debug` `7` #调试信息

    - -m limit --limit 5/min
      - --limit 5/min：每分钟最多记录 5 条日志。
      - --limit-burst 10：初始允许记录 10 条日志（默认值为 5）。

</br>
</br>

## 规则条件扩展[语法](#二iptables-语法)

1. 匹配多端口（multiport）

    功能: 用于匹配多个源端口 (--sports) 或目标端口 (--dports)。

    用途: 当你需要针对多个端口设置相同的规则时，可以使用这个模块来简化配置。

    ```sh
    -m multiport --sports/--dports <port1>,<port2>,...

    #这条规则允许 TCP 流量通过 22 (SSH)、80 (HTTP) 和 443 (HTTPS) 端口。
    iptables -A INPUT -p tcp -m multiport --dports 22,80,443 -j ACCEPT

    --sports/--dports <start-port>:<end-port>
    #--sports/--dports 支持连续端口，这条规则允许 8000 到9000 端口
    iptables -A INPUT -p tcp --dports 8000:9000 -j ACCEPT   

    #结合使用：允许 TCP 流量通过 22, 80, 443, 8000 到 9000 等端口
    iptables -A INPUT -p tcp -m multiport --dports 22,80,443,8000:9000 -j ACCEPT
    ```

2. 匹配 IP范围（iprange）

    功能: 用于匹配源 IP 地址范围 (--src-range) 或目标 IP 地址范围 (--dst-range)。

    用途: 当你需要针对一个 IP 地址范围设置规则时，可以使用这个模块。

    ```sh
    -m iprange --src-range/--dst-range <start-ip-address>-<end-ip-address>

    #这条规则会丢弃来自 192.168.1.100 到 192.168.1.200 范围内的所有 IP 地址的流量。
    iptables -A INPUT -m iprange --src-range 192.168.1.100-192.168.1.200 -j DROP
    ```

3. 匹配 MAC地址（mac）

    功能: 用于匹配源 MAC 地址。

    用途: 当你需要根据设备的 MAC 地址来设置规则时，可以使用这个模块。

    ```sh
    -m mac --mac-source <mac-address>

    #这条规则允许来自 MAC 地址为 00:1A:2B:3C:4D:5E 的设备的流量。
    iptables -A INPUT -m mac --mac-source 00:1A:2B:3C:4D:5E -j ACCEPT
    ```

4. 匹配连接状态（conntrack）

    功能: 用于匹配连接跟踪状态 (--ctstate)。

    用途: 当你需要根据连接的状态（如 ESTABLISHED, RELATED, NEW 等）来设置规则时，可以使用这个模块。

    ```sh
    -m conntrack --ctstate <state>
    #这条规则允许新的连接和已经建立的连接通过。
    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

    #类似于 conntrack 模块，但 state 模块是旧版的连接状态匹配模块，通常推荐使用 conntrack 模块。
    -m state --state <state>     
    #这条规则允许已经建立的连接和相关的连接通过。
    iptables -A INPUT -m state --state NEW,ESTABLISHED -j ACCEPT
    ```

    ctstate 参数介绍

    - `NEW`: 新连接。
    - `ESTABLISHED`: 已建立的连接。
    - `RELATED`: 与现有连接相关的连接。
    - `INVALID`: 无效的连接（如损坏的数据包或无效的状态）。
    - `UNTRACKED`: 未被跟踪的连接（通常是因为连接跟踪表已满或连接被显式排除）。
    - `SNAT`: 经过源地址转换的连接。
    - `DNAT`: 经过目标地址转换的连接。
    - `NONE`: 没有状态的连接（通常用于无状态协议，如 UDP 或 ICMP）。

</br>

## IPTABLES 完整[语法](#二iptables-语法)

用法：

```sh
iptables  [ACD]   链名               规则条件  [选项]
iptables  -I      链名    [规则编号]  规则条件  [选项]
iptables  -R      链名    规则编号    规则条件  [选项]
iptables  -D      链名    规则编号             [选项]
iptables  -[LS]   [链名   [规则编号]]          [选项]
iptables  -[FZ]   [链名]  [选项]
iptables  -[NX]   链名 
iptables  -E      旧链名  新链名 
iptables  -P      链名    目标    [选项]
iptables  -h  （打印此帮助信息）
```

参数：

```sh
#命令：
--append        -A  链名               #向链中追加规则
--check         -C  链名               #检查规则是否存在
--delete        -D  链名               #从链中删除匹配的规则
--delete        -D  链名  规则编号      #删除链中规则编号（1 为第一个）的规则
--insert        -I  链名  [规则编号]    #在链中插入规则，作为规则编号（默认为 1，即第一个）
--replace       -R  链名  规则编号      #替换链中规则编号（1 为第一个）的规则
--list          -L  [链名  [规则编号]]  #列出链中的规则或所有链的规则
--list-rules    -S  [链名  [规则编号]]  #打印链中的规则或所有链的规则
--flush         -F  [链名]      #删除链中所有规则或所有链中的规则
--zero          -Z  [链名  [规则编号]]  #清空链或所有链中的计数器
--new           -N  链名        #创建新的用户自定义链
--delete-chain  -X  [链名]      #删除用户自定义链
--policy        -P  链名  目标  #更改链的策略为目标
--rename-chain  -E  旧链名  新链名     #更改链名，（移动任何引用）

#选项：
    --ipv4      -4              #无（该行将被 ip6tables-restore 忽略）
    --ipv6      -6              #错误（该行将被 iptables-restore 忽略）
[!] --protocol  -p proto        #协议：通过编号或名称指定，例如 'tcp'
[!] --source    -s address[/mask][...]     #指定源地址
[!] --destination -d address[/mask][...]   #指定目的地

[!] --in-interface -i input name[+]      #网络接口名称（[+] 表示通配符）
  --jump        -j target       #规则的目标（可加载目标扩展）
  --goto        -g chain        #跳转到链且不返回
  --match       -m match        #扩展匹配（可加载扩展）
  --numeric     -n              #地址和端口的数字输出

[!] --out-interface -o output name[+]    #网络接口名称（[+] 表示通配符）
  --table       -t table        #要操作的表（默认值：'filter'）
  --verbose     -v              #详细模式
  --wait        -w [seconds]    #获取 xtables 锁的最大等待时间，超时则放弃
  --line-numbers                #列表时打印行号
  --exact       -x              #展开数字（显示确切值）
[!] --fragment  -f              #仅匹配第二个或后续的分片
  --modprobe=<command>          #使用此命令尝试插入模块
  --set-counters -c PKTS BYTES  #在插入/追加时设置计数器
[!] --version    -V              #显示软件包版本。
```

</br>
</br>

Via

- <https://www.wangjunfeng.com.cn/2019/12/14/iptables/>
- <https://www.cnblogs.com/zjzhen/articles/18535261>
