# HAProxy 安装与介绍

> HAProxy（High Availability Proxy）是一款使用C语言编写的，高性能的开源负载均衡器和代理服务器软件，专为TCP（L4）和HTTP（L7）应用而设计。它可以将客户端的请求分发到多台后端服务器，从而提高应用的可用性和性能。HAProxy支持多种负载均衡算法和健康检查机制，是构建高可用性系统的理想选择。

</br>
</br>

LB（Load Balance，负载均衡）：是一种服务或基于硬件设备等实现的高可用反向代理技术，负载均衡将特定的业务（web服务、网络流量等）分担给指定的一个或多个后端特定的服务器或设备，从而提高了公司业务的并发处理能力、保证了业务的高可用性、方便了业务后期的水平动态扩展。

OSI 网络七层模型（OSI：Open System Interconnection, 开放系统互联）

![202504181133218](https://gitee.com/librarookie/picgo/raw/master/img/202504181133218.png)
![202504181133725](https://gitee.com/librarookie/picgo/raw/master/img/202504181133725.png)

根据 OSI模型 可将负载均衡分为：

- 二层负载均衡（mac）：一般是用虚拟mac地址方式，外部对虚拟MAC地址请求，负载均衡接收后分配后端实际的MAC地址响应；
- 三层负载均衡（ip）：一般采用虚拟IP地址方式，外部对虚拟的ip地址请求，负载均衡接收后分配后端实际的IP地址响应；
- 四层负载均衡（tcp）：在三层负载均衡的基础上，用 ip+port 接收请求，再转发到对应的机器；（如：F5，lvs，nginx，haproxy）
- 七层负载均衡（http）：根据虚拟的url或是IP，主机名接收请求，再转向相应的处理服务器。（如：haproxy，nginx，apache）

负载均衡模型介绍

1. 无负载平衡：没有负载平衡的简单Web应用程序环境，如下所示

    ![202504181141884](https://gitee.com/librarookie/picgo/raw/master/img/202504181141884.png)

    示例中，用户直接连接到您的Web服务器，在 yourdomain.com 上，并且没有负载平衡。可能遇到的问题：
    - 如果单个Web服务器出现故障，用户将无法再访问您的Web服务器。
    - 如果许多用户试图同时访问您的服务器，并且无法处理负载，他们可能会遇到缓慢的体验，或者可能根本无法连接。

2. 四层负载平衡：根据IP范围和端口转发用户流量

    将网络流量负载平衡到多个服务器的最简单方法是使用第4层（传输层）负载平衡。

    ![202504181142286](https://gitee.com/librarookie/picgo/raw/master/img/202504181142286.png)

    示例中，用户访问负载均衡器，负载均衡器将用户的请求转发给后端服务器的Web后端组。
    - 无论选择哪个后端服务器，都将直接响应用户的请求。
    - 通常，Web后端中的所有服务器应该提供相同的内容（否则用户可能会收到不一致的内容）。

3. 七层负载平衡：根据用户请求的内容将请求转发到不同的后端服务器

    七层负载平衡是更复杂的负载均衡，这种模式是使用第7层（应用层）负载均衡。它允许您在同一域和端口下运行多个Web应用程序服务器。

    ![202504181142555](https://gitee.com/librarookie/picgo/raw/master/img/202504181142555.png)

    示例中，如果用户请求 yourdomain.com/blog，则会将其转发到博客后端，后端是一组运行博客应用程序的服务器。其他请求被转发到web-backend，后端可能正在运行另一个应用程序。

四层和七层负载均衡的区别：

- 四层的负载均衡：通过发布三层的IP地址(VIP)，然后加四层的端口号，来决定哪些流量需要做负载均衡，对需要处理的流量进行NAT处理，转发至后台服务器，并记录下这个TCP或者UDP的流量是由哪台服务器处理的，后续这个连接的所有流量都同样转发到同一台服务器处理。
- 七层的负载均衡：在四层的基础上（没有四层是绝对不可能有七层的），再考虑应用层的特征，比如同一个Web服务器的负载均衡，除了根据VIP加80端口辨别是否需要处理的流量，还可根据七层的URL、浏览器类别、语言来决定是否要进行负载均衡

</br>

## 一、介绍

HAProxy 是一款 TCP/HTTP 反向代理负载均衡服务器软件，可工作在OSI模型中的 "四层传输层" 以及 "七层应用层"。

HAProxy特别适用于那些负载压力大的web站点，这些站点通常需要 "会话保持" 或 "七层处理"。

HAproxy允许用户定义多组服务代理，代理由前端和后端组成，前端定义了服务监听的IP及端口，后端则定义了一组服务器及负载均衡的算法。通过服务代理将流量由前端负载均衡至后端服务器节点上。

HAProxy的工作流程如下：

1. 客户端发送请求到HAProxy的前端（frontend）。
2. 前端根据配置的规则，选择合适的后端（backend）。
3. 后端将请求分发到具体的服务器进行处理。
4. 服务器处理请求并返回结果，通过后端和前端返回给客户端。

### 1.1 核心

- 负载均衡：拥有 L4 和 L7 两种负载均衡模式，支持多种负载均衡算法（如：RR/静态RR/LC/IP Hash/URI Hash/URL_PARAM Hash/HTTP_HEADER Hash等）。
- 会话保持：确保同一客户端的所有请求都分配到同一台服务器处理。对于未实现会话共享的应用集群，可根据 Hash 或者 cookies 方式实现会话保持。（如：source、Insert Cookie和Prefix Cookie等）
- 健康检查：通过定期检测服务器状态，动态调整服务器的可用性。支持 TCP、HTTP 两种后端服务器健康检查模式。
- 统计监控：接受访问特定端口实现服务监控（提供了基于Web的，并带有用户认证机制的统计信息页面，展现服务健康状态和流量数据）。
- SSL卸载：可以解析 HTTPS 报文，并将请求解密为 HTTP 向后端服务器传输。
- 其他功能：
  - 在 HTTP 请求或响应报文中添加、修改、删除头部信息；
  - HTTP 请求重写 与重定向；
  - 根据访问控制路由或阻断请求。

### 1.2 优势

- 高性能: 采用异步事件驱动架构，能够高效处理大量并发连接。
- 高可用：通过健康检查和故障转移机制，确保服务的可靠性。
- 灵活性强：支持多种负载均衡算法和调度策略，适应不同的应用场景。
- 模块化: 支持多种模块扩展，如 HTTP、TCP、SSL/TLS 等。
- 丰富的功能：支持SSL终止、HTTP重写、压缩等多种功能。
- 简单易用: 配置语法简洁，易于上手。

点击了解《[HAProxy 与 NGINX：全面比较](https://developer.aliyun.com/article/1592511)》

</br>

## 二、安装

haproxy官网：<https://www.haproxy.org/>

### 2.1 yum 安装

`sudo yum install haproxy -y`

注意: yum 安装的 HAProxy 版本可能比较旧，建议使用编译安装方式获取最新版本。

### 2.2 rpm 包安装

从第三方网站下载 rpm 包进行安装，例如：<https://pkgs.org/download/haproxy>

注意: 下载 rpm 包时，请务必选择可靠的来源，并注意版本兼容性。

### 2.3 编译安装

1. 安装依赖包

    `sudo yum install -y make gcc pcre pcre-devel bzip2-devel openssl openssl-devel`

2. 下载并编译安装

    ```sh
    #下载安装包，并解压
    wget https://www.haproxy.org/download/3.0/src/haproxy-3.0.9.tar.gz
    tar -xzf haproxy-3.0.9.tar.gz
    cd haproxy-3.0.9

    #编译安装
    make TARGET=linux-glibc USE_OPENSSL=1 USE_PCRE=1 USE_SYSTEMD=1
    sudo make install PREFIX=/usr/local/haproxy

    #创建软链接（可选）
    sudo ln -s /usr/local/haproxy/sbin/haproxy /usr/sbin/
    ```

    - `TARGET`：指定目标操作系统和内核版本。
      - haproxy-2.x 及以下版本安装时：TARGET=linux2628 .（linux2628 表示目标是 Linux 系统，内核版本为 2.6.28 或更高版本。这个参数确保 HAProxy 在编译时针对特定的内核版本进行优化。）
      - haproxy-3.x 版本安装时： TARGET=linux-glibc .
    - `USE_OPENSSL=1`：启用对 OpenSSL 的支持。这使得 HAProxy 能够处理 SSL/TLS 加密的流量。
      - 如果你需要 HAProxy 支持 HTTPS 或其他加密协议，这个选项是必需的。
    - `USE_PCRE=1`：启用对 PCRE（Perl Compatible Regular Expressions）库的支持。PCRE 库用于支持正则表达式。
      - 这对于 HAProxy 的一些高级功能（如基于 URL 的路由规则）是必要的。
    - `USE_SYSTEMD=1`：启用对 systemd 的支持。systemd 是一个系统和服务管理器，用于启动、停止和管理服务。
      - 启用这个选项可以让 HAProxy 与 systemd 集成，从而更方便地管理 HAProxy 服务
    - `PREFIX`：指定的安装路径。

3. 配置并验证

    ```sh
    #创建服务用户
    sudo useradd -r -M -s /sbin/nologin haproxy

    #创建配置文件目录
    sudo mkdir /etc/haproxy

    #使用配置文件（可选）
    sudo cp addons/ot/test/empty/haproxy.cfg /etc/haproxy

    #验证 HAProxy 配置
    sudo haproxy -f /etc/haproxy/haproxy.cfg -c
    
    #启动测试
    sudo haproxy -f /etc/haproxy/haproxy.cfg
    ```

4. 创建 HAProxy 服务文件

    ```ini
    sudo tee /etc/systemd/system/haproxy.service <<-EOF
    [Unit]
    Description=HAProxy Load Balancer
    After=syslog.target network.target

    [Service]
    Environment="CONFIG=/etc/haproxy/haproxy.cfg" "PIDFILE=/run/haproxy.pid"
    ExecStartPre=/usr/sbin/haproxy -f \$CONFIG -c -q
    ExecStart=/usr/sbin/haproxy -Ws -f \$CONFIG -p \$PIDFILE
    ExecReload=/usr/sbin/haproxy -f \$CONFIG -c -q
    ExecReload=/bin/kill -USR2 \$MAINPID
    KillMode=mixed
    Restart=always
    Type=notify

    [Install]
    WantedBy=multi-user.target
    EOF
    ```

    Centos 6 及以下: `sudo cp haproxy-3.0.9/haproxy-3.0.9/haproxy.ini /etc/init.d/`

</br>

### 2.4 日志配置

默认情况下, HAProxy是没有配置日志的，在 centos7 下默认管理日志的是 rsyslog, 可以实现UDP日志的接收, 将日志写入文件, 写入数据库

1. HAproxy 启动日志

    在 haproxy.conf 文件的 defaults 下面增加日志相关的配置：

    ```sh
    defaults                      
        log global
        log 127.0.0.1 local2
        option httplog
    ```

2. 添加系统日志配置

    由于 haproxy 的日志是用 udp传输的, 所以要启用 rsyslog的 udp监听。

    新建 /etc/rsyslog.d/haproxy.conf 并配置（也可以将配置写入 /etc/rsyslog 文件中）

    ```sh
    sudo tee /etc/rsyslog.d/haproxy.conf <<-EOF
    \$ModLoad imudp
    \$UDPServerRun 514
    local2.* /var/log/haproxy.log
    EOF
    ```

    - `local2`  #基础设施服务，如：Nginx、Apache、数据库
    - `local2.*`  #记录local4设施的所有优先级（生产环境通常记录到 `info` 级别，调试时临时开启 `debug` 级别）
    - imup 是模块名，支持UDP协议
    - 第二行准许 514端口接收使用 UDP和 TCP协议转发过来的日志（rsyslog默认 514端口监听UDP）

3. 系统开启远程日志

    修改 rsyslog 的启动参数为: SYSLOGD_OPTIONS="-c 2 -r -m 0"

    ```sh
    #将 /etc/sysconfig/rsyslog 文件中的文件中的的配置为: SYSLOGD_OPTIONS="-c 2 -r -m 0"
    sudo sed -i '/SYSLOGD_OPTION/c\SYSLOGD_OPTIONS="-c 2 -r -m 0"' /etc/sysconfig/rsyslog
    ```

    - `-c 2`：使用兼容模式（默认是 -c 5）
    - `-r`:  开启远程日志，接收远程日志消息的功能, 其监控 514 UDP端口;
    - `-m 0`：标记时间戳。单位是分钟，为0时，表示禁用，该功能修改 syslog的内部 mark消息写入间隔时间(0为关闭), 例如240为每隔240分钟写入一次"--MARK--"信息;
    - `-h`:  默认情况下, syslog不会发送从远端接受过来的消息到其他主机, 而使用该选项, 则把该开关打开, 所有接受到的信息都可根据 syslog.conf 中定义的@主机转发过去.
    - `-x`:  关闭自动解析对方日志服务器的FQDN信息, 这能避免DNS不完整所带来的麻烦;

4. 重启生效

    ```sh
    sudo systemctl restart rsyslog.service
    sudo systemctl restart haproxy.service
    ```

</br>

## 三、配置

HAProxy 核心配置文件（/etc/haproxy/haproxy.cfg）定义了前端、后端和监听器等组件，内容如下：

- `global`： 全局配置，配置影响 HAProxy 全局的指令，如最大连接数、进程数、日志和统计报告（Statistics Report）等。
- `defaults`：默认配置项，针对以下的frontend、backend 和 listen生效，可以多个name也可以没有name
- `frontend`：接收请求的前端虚拟节点，类似于Nginx的一个虚拟主机 server 和LVS服务集群。可以根据配置的规则进行处理（指定具体使用后端的backend）
- `backend`：实际处理请求的后端服务器组，处理前端转发的请求。类似 nginx的upstream 和 LVS的RS 服务器。一个backend对应一个或者多个实体服务器。
- `listen`：fronted 和 backend 的组合体，配置更简洁，生产常用，比如haproxy实例状态监控部分配置。（Haproxy1.3之前的唯一配置方式）

HAProxy 配置文件介绍

```sh
# 全局参数的设置
global
    # 日志配置
    #log 127.0.0.1:514 local2 notice    #定义全局日志输出目标和级别
    log /dev/log local2 notice  #local2是日志输出设备，日志级别设为 notice 或 info，避免 debug 影响性能

    # 进程与安全
    user haproxy    #指定运行 HAProxy 的用户和组，也可使用uid，gid关键字替代之
    group haproxy
    chroot /var/lib/haproxy     #切换根目录，增强安全性（默认 /）
    #pidfile /var/run/haproxy.pid    #设置进程 ID 文件路径（默认由系统管理，多实例隔离时，需为每个实例指定不同的 PID 文件）
    daemon          #以后台守护进程模式运行

    # 性能调优
    nbproc 4        #设置进程数（多核优化，建议与 CPU 核心数一致，默认 1）
    maxconn 50000       #设置每个进程的最大连接数（默认 20000）
    #ulimit-n 65536  #设置每个进程的最大文件描述符数（需 > maxconn，默认自动）
    #spread-checks 5     #分散健康检查时间

    # 统计与监控（未配置则禁用）
    stats socket /var/lib/haproxy/stats [mode 660] [level admin]   #启用统计套接字（文件路径，文件权限，访问权限）
    stats timeout 30s   #统计接口超时设置

    # SSL/TLS 配置
    ssl-default-bind-ciphers ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384  #默认 SSL 加密套件
    ssl-default-bind-options no-sslv3 no-tlsv10 no-tlsv11   #默认 SSL 选项
    tune.ssl.default-dh-param 2048      #DH 参数大小
    # SSL 默认路径设置（可选）
    ca-base /etc/ssl/certs      #指定 CA (Certificate Authority) 证书的默认目录（引用时可以只写相对路径）
    crt-base /etc/ssl/private   #指定服务器证书和私钥的默认目录（在 bind 指令中引用证书时可以省略完整路径）

# 默认部分的定义
defaults
    # 日志相关
    mode    http    #设置代理模式（http七层|tcp四层|health健康检测，默认 tcp）
    log     global  #使用全局日志配置
    option  httplog  #启用详细的 HTTP 日志记录（httplog/tcplog）
    option  dontlognull  #不记录空连接（如：健康检查日志等）

    # HTTP选项
    option  forwardfor except 127.0.0.0/8  #在 HTTP 请求中添加 X-Forwarded-For 头，以便后端获取客户端的真实 IP 地址。
    option  http-server-close  #是否保持长连接（http-keep-alive(默认)启用长连接、http-server-close：客户端启用长连接 和 httpclose：禁用长连接）
    #timeout http-keep-alive 10s  #默认持久连接超时时间
    option  redispatch      #当连接失败时，允许重新分发到其他服务器
    retries 3       #HAProxy 会在连接后端服务器失败时，自动重试 3 次（请求级别的重试）；解决临时性网络抖动或后端服务器短暂不可用的问题。（默认 3）
    #maxconn 3000      #设置前端的最大并发连接数（默认 2000）
    #balance roundrobin  #定义默认负载均衡算法（roundrobin（默认）, leastconn, source, uri, hdr, rdp-cookie 等）

    # 超时设置
    timeout connect 10s  #客户端与服务器建立连接的最大超时时间
    timeout client  1m  #客户端发送数据的最大超时时间
    timeout server  1m  #服务器响应数据的最大超时时间
    #timeout queue  1m  #队列中请求的最大等待时间（默认 10s）
    #timeout http-request 10s  #HTTP请求完成的超时时间（默认 5s）

    # 健康检查
    option  httpchk GET /healthURL  # 启用 HTTP 健康检查，/healthURL 是检查server的uri，通常配置在backend中（默认使用tcp-check）
    http-check expect status 200    # 设置状态码
    #timeout check  10s   #健康检查的最大超时时间（默认 5s）
    default-server check inter 3s fall 3 rise 2  #定义后端服务器的默认参数
    stats uri    /haproxy       #默认前端路径
    stats auth   admin:asd123   #默认认证信息（可以多个）

    ##错误处理，定义返回给客户端的定制错误页面
    #errorfile 400 /etc/haproxy/errors/400.http
    #errorfile 403 /etc/haproxy/errors/403.http
    #errorfile 503 /etc/haproxy/errors/503.http    #自定义错误页面
    #errorloc 503 http://www.example.com/maintenance.html    #重定向到维护页面

# 定义一个名为 status 的部分
listen status
    #bind *:8080    #可能同时监听 IPv4 和 IPv6（不推荐，不同版本兼容不一样）
    bind 0.0.0.0:8080    #定义监听 IPv4
    bind :::8080 v6only off  #定义监听 IPv6，v6only off：允许 IPv4 映射到 IPv6
    #mode http    #定义代理模式（http|tcp）
    #log global    #继承 global中log的定义
    stats realm Haproxy\ Statistics    #设置统计页面认证时的提示内容
    stats uri /admin?stats    #定义访问统计页面的 URI（默认 /haproxy?stats）
    stats auth admin:asd123    #设置统计页面认证的用户和密码（如果要设置多个，另起一行写入即可）
    stats refresh 30s    #设置页面自动刷新时间为 30s（默认不自动刷新）
    stats hide-version    #隐藏统计页面上的 haproxy 版本信息
    #stats admin if TRUE    #启用管理功能，允许你动态管理后端服务器（如上线/下线服务器、修改权重等）
    #stats admin if { src 192.168.1.100 }  #仅允许 192.168.1.100 管理（if 后面可以跟 ACL（访问控制列表））

# 定义一个名为 http_80_in 的前端部分
frontend http_80_in
    bind 0.0.0.0:80    #http_80_in定义前端部分监听的套接字
    mode http    #定义代理模式（http|tcp）
    #log global        #继承global日志配置
    #option httplog    #详细日志（HTTP|TCP）
    #option dontlognull          #不记录空连接
    # 启用X-Forwarded-For，在requests头部插入客户端IP发送给后端的server，使后端server获取到客户端的真实IP
    #option forwardfor           #添加X-Forwarded-For头
    #option httpclose            #关闭HTTP连接
    #option redispatch           #连接失败时重试其他服务器

    #超时设置
    #timeout client 30s        #客户端超时
    #timeout http-request 10s  #HTTP请求超时

    #HTTP相关配置
    #http-request set-header X-Real-IP %[src]
    #http-request set-header X-Forwarded-Proto https if { ssl_fc }
    #http-request deny if { path /private } { src 192.168.1.0/24 }

    #访问控制：acl + use_backend - 基于条件路由
    # 定义一个名叫 is_server_dead 的acl，当后端的 static_sever 中存活机器数（基于HTTP请求状态码）小于1时会被到匹配
    acl is_server_dead nbsrv(static_server) lt 1
    # 定义一个名叫 is_php_web 的acl，匹配url以 .php 结尾的当请求（两种写法任选其一）
    acl is_php_web url_reg /*.php$
    #acl is_php_web path_end .php
    # 定义一个名叫 is_static_web 的acl，匹配url以 .css/.jpg/.png/.jpeg/.js/.gif 结尾的当请求（两种写法任选其一）
    acl is_static_web url_reg /*.(css|jpg|png|jpeg|js|gif)$
    #acl is_static_web path_end .gif .png .jpg .css .js .jpeg
    #如果满足策略 is_server_dead 时，则将请求交予后端 php_server
    use_backend php_server if is_server_dead
    use_backend php_server if is_php_web
    use_backend static_server if is_static_web

    #redirect prefix http://www.example.com code 301 if { hdr(host) -i example.com }
    #redirect scheme https code 301 if !{ ssl_fc }

    #默认后端
    default_backend static_server

#定义一个名为 php_server 的后端部分
backend php_server
    #mode http    #设置为http模式
    balance source    #设置haproxy的调度算法为源地址hash
    cookie SERVERID    #允许向cookie插入SERVERID，每台服务器的SERVERID可在下面使用cookie关键字定义
    option httpchk GET /test/index.php    # 开启对后端服务器的健康检测，通过GET /test/index.php来判断后端服务器的健康情况

    #server语法：server [:port] [param*] 
    server server_1 10.12.25.68:80 cookie s1 check inter 2000 rise 3 fall 3 weight 2
    server server_2 10.12.25.72:80 cookie s2 check inter 2000 rise 3 fall 3 weight 1
    server server_bak 10.12.25.79:80 cookie s3 check inter 1500 rise 3 fall 3 backup

#定义一个名为 static_server 的后端部分
backend static_server
    mode http
    option httpchk GET /test/index.html
    server serv_1 10.12.25.83:80 cookie 3 check inter 2000 rise 3 fall 3
```

`server server_1 10.12.25.68:80 cookie s1 check inter 2000 rise 3 fall 3 weight 2`

- server：使用 server 关键字来设置后端服务器；
- server_1：为后端服务器所设置的内部名称，该名称将会呈现在日志或警报中
- 10.12.25.68:80：后端服务器的IP地址，支持端口映射
- cookie 1：指定该服务器的SERVERID 为 s1
- check：接受健康监测
- inter 2000：监测的间隔时长，单位毫秒
- rise 3：监测正常多少次后被认为后端服务器是可用的
- fall 3：监测失败多少次后被认为后端服务器是不可用的
- weight 2：分发的权重
- backup：最后为备份用的后端服务器，当正常的服务器全部都宕机后，才会启用备份服务器

</br>

### 3.1 全局配置（global）

通常主要用于设定义全局参数，属于进程级的配置，通常和操作系统配置有关。

| 参数 | 默认值 | 说明 | 推荐配置示例 |
| ---- | ---- | ---- | ---- |
| log | 无 | 日志输出目标（未配置则不记录） | log 127.0.0.1 local2 notice |
| log-tag | haproxy | 日志前缀标识 | log-tag "LB_HAPROXY" |
| log-send-hostname | 无 | 在日志中添加主机名（多节点时有用） | log-send-hostname lb1 |
| user / group | root | 运行用户/组（安全建议：专用低权用户） | user haproxy |
| chroot | 无 | 切换根目录（生产环境建议启用） | chroot /var/lib/haproxy |
| daemon | 无 | 以后台守护进程运行（生产环境必选） | daemon |
| nbproc | 1 | 工作进程数（多核需配置） | nbproc 4（<=CPU核心数） |
| maxconn | 2000 | 单进程最大并发连接数 | maxconn 50000 |
| ulimit-n | 自动 | 文件描述符限制（需 > maxconn） | ulimit-n 65536 |
| spread-checks | 0 | 健康检查时间分散（0=同时检查，建议>2） | spread-checks 5 |
| stats socket | 无 | 管理套接字文件路径，文件权限，访问权限（未配置则禁用） | stats socket /var/lib/haproxy/stats [mode 660] [level admin] |
| stats timeout | 10s | 管理接口超时时间 | stats timeout 30s |
| ssl-default-bind-ciphers | 系统依赖 | 加密套件（旧版本可能包含不安全套件） | ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384 |
| ssl-default-bind-options | 无 | SSL/TLS 选项（需显式禁用不安全协议） | no-sslv3 no-tlsv10 no-tlsv11 |
| tune.ssl.default-dh-param | 1024 | DH 参数大小（1024 不安全，必须修改） | tune.ssl.default-dh-param 2048 |
| ca-base </br> crt-base | 无 | CA/证书默认目录（简化配置路径） | ca-base /etc/ssl/certs </br> crt-base /etc/ssl/private |

log 参数中的 /dev/log 与 127.0.0.1

1. `/dev/log`：简单高效，适合本地日志收集
    - Unix 域套接字（高效，仅本地），需本地运行 syslog 且支持 /dev/log
    - 日志会发送到系统的 syslog 守护进程（如 rsyslog 或 syslog-ng）
    - 根据配置（/etc/rsyslog.conf）决定日志的最终存储位置
    - 可能不兼容（容器内无 /dev/log）
    - 更高效，避免网络延迟或丢包
2. `127.0.0.1`：灵活支持远程日志，但需额外网络配置
    - UDP 网络协议（可跨主机）
    - 日志会通过 UDP 协议 发送到本地（或远程）的 syslog 服务器（端口默认 514）
    - 需要确保 syslog 服务监听 UDP 514 端口（如 rsyslog 需启用 imudp 模块）
    - 支持远程日志收集，兼容性更好，如：`log 192.168.1.100:514 local2 notice`
      - notice：一般生产环境适用（记录关键事件）
      - info/debug：调试时使用（日志量较大）

</br>

### 3.2 默认配置（defaults）

defaults 部分用于定义全局默认配置，这些配置会被后续的 frontend，backend 和 listen 部分继承。

如果参数属于公用的配置（除 acl、bind、http-request、http-response、use_backend 等），只需要在 defaults部分添加一次即可。

如果frontend、backend、listen 部分也配置了与 defaults部分一样的参数，defaults部分参数对应的值自动被覆盖。

| 参数 | 说明 |
| ---- | ---- |
| mode http | HAProxy实例使用的连接协议 |
| log global | 设置日志继承全局配置段的设置。 |
| option httplog | 日志记录选项，httplog表示记录与 HTTP会话相关的各种属性值。包括HTTP请求、会话状态、连接数、源地址以及连接时间等 |
| option dontlognull | 表示不记录空会话连接日志 |
| option forwardfor except 127.0.0.0/8 | 用于透传客户端真实 IP 至后端web服务器；except排除指定的 IP 或网段（避免本地回环请求被误处理） |
| option http-keep-alive（默认）</br> option http-server-close </br> option httpclose | 是否启用长连接（Keep-Alive） </br> http-keep-alive：客户端和服务器均保持长连接。（默认） </br> http-server-close：客户端保持长连接，但服务器端主动关闭。 </br> httpclose：强制关闭所有连接（无 Keep-Alive）。 |
| timeout http-keep-alive 60s | session会话保持超时时间，此时间段内会转发到相同的后端服务器 </br> http-keep-alive：控制空闲 Keep-Alive 连接的存活时间。 </br> http-server-close：仅作用于客户端连接（服务器连接不受影响）。 </br> httpclose：失效（因为无长连接）。 |
| option redispatch | 允许在连接失败时重新分发请求（默认禁用） |
| retries 3 | 连接后端服务器失败次数，超过此值就认为后端服务器不可用。（默认 3） |
| maxconn 3000 | 最大并发连接数 |
| balance roundrobin | 定义负载均衡算法（默认值：roundrobin） |
| timeout connect 5s | 定义haproxy与 后端服务器连接超时时间（如果在同一个局域网可设置较小的时间） |
| timeout client 1m | 定义客户端与 haproxy连接后，非活动连接（数据传输完毕，不再有数据传输）的超时时间。 |
| timeout server 1m | 定义haproxy 与上游服务器，非活动连接的超时时间。 |
| timeout http-request 10s | 客户端发送 http 请求的超时时间。 |
| timeout queue 1m | 定义放入这个队列的超时时间。当上游服务器在高负载响应haproxy时，会把haproxy发送来的请求放进一个队列中。 |
| option httpchk [METHOD] [URL] [VERSION] </br> option tcp-check（默认） | 定义健康检查策略。如option httpchk GET /healthCheck.html HTTP/1.1 |
| http-check expect status 200 | 定义健康检查期望响应 |
| timeout check 10s | 后端服务器健康检查的超时时间 |
| default-server inter 1000 | 为所有服务器设置默认参数。每隔 1000 毫秒对服务器的状态进行检查 |

`balance roundrobin`：定义负载均衡算法为轮询，常用算法有：roundrobin (轮询)、static-rr (静态轮询)、leastconn (最少连接)、first (第一个可用服务器)、source (源IP哈希)、uri (URI哈希)、url_param (URL参数哈希)、hdr (HTTP头哈希)

一些包含了值的参数表示时间，如超时时长。这些值一般以毫秒（ms）为单位，但也可以使用其它的时间单位后缀

- `us`：微秒 (microseconds)，即 1/1000,000 秒；
- `ms`：毫秒 (milliseconds)，即 1/1000 秒；
- `s`：秒 (seconds)；
- `m`：分钟 (minutes)；
- `h`：小时 (hours)；
- `d`：天 (days)；

</br>

### 3.3 前端配置（frontend）

HAProxy 的 frontend 部分定义了客户端如何连接到代理服务。以下是 frontend 配置中常用的指令和选项：

| 参数 | 说明 |
| ---- | ---- |
| disabled | 禁用此frontend |
| bind 0.0.0.0:80 | 绑定监听 |
| mode http | 模式设置（http/tcp） |
| log global | 日志配置 |
| option httplog | 开启详细日志（httplog/tcplog） |
| option dontlognull | 不记录空连接 |
| option forwardfor | 在请求中添加X-Forwarded-For Header，记录客户端ip |
| option http-keep-alive </br> option httpclose | 是否启用KeepAlive模式，如果HAProxy主要提供的是接口类型的服务，可以考虑采用httpclose模式，以节省连接数资源。但接口的调用端将不能使用HTTP连接池 |
| option redispatch | 连接失败时重试其他服务器 |
| timeout client 30s | 客户端超时。连接创建后，客户端持续不发送数据的超时时间 |
| timeout http-request 10s | HTTP请求超时。连接创建后，客户端没能发送完整HTTP请求的超时时间，即创建连接后，以非常缓慢的速度发送请求包，导致HAProxy连接被长时间占用（主要用于防止DoS类攻击） |
| maxconn <number\> | 最大并发连接数。同global域的maxconn，但仅用于此frontend |
| stats uri <uri\> | 在此frontend上开启监控页面，通过访问统计页面的 URI（默认 /haproxy?stats） |
| stats refresh 30s | 监控数据刷新周期（默认不自动刷新）|
| stats auth <user\>:<password\> | 监控页面的认证用户名密码 |
| acl <acl_name> <criterion\> [flags] [operator] [value] ... | 访问控制。定义一条ACL，ACL是根据数据包的指定属性以指定表达式计算出的true/false值。 |
| use_backend <backend_name> [{if \| unless} <condition\>] | 后端流量转发，在满足/不满足ACL时转发至指定的backend（与ACL搭配使用） |
| redirect {option} {args} [code {code}] {if \| unless} <condition\> | 请求重定向 |
| http-request <action\> [options] [condition] </br> http-response <action\> [options] [condition] | HTTP头部操作，对所有到达此frontend的HTTP请求/相应应用的策略，例如可以拒绝、要求认证、添加header、替换header、定义ACL等等。 |
| default_backend <backend_name> | 配置默认后端backend |

#### 3.3.1 绑定监听 - bind

定义监听的IP和端口

`bind <ip:port> [param*]`

```sh
bind *:80       #监听所有IP的 80端口（不推荐，可能同时监听 IPv4 和 IPv6，不同版本兼容不一样）
bind 0.0.0.0:80    #监听所有 IPv4 地址
bind [::]:80    #监听所有 IPv6 地址
bind :::80 v6only off  #同时监听IPv4和IPv6
bind 192.168.1.100:443 ssl crt /etc/haproxy/cert.pem  #监听带SSL证书的HTTPS
```

`bind :::80 v6only off`

- 大多数现代 Linux 系统默认 v6only 是 off：表示不禁用 IPv6-only 模式（即允许 IPv6 套接字同时接受 IPv4 和 IPv6 连接），所以 `bind :::80` 本身就会同时监听 IPv4 和 IPv6，无需额外设置。
- 某些系统（如 FreeBSD）或特殊配置下，可能需要显式设置 `v6only off`
- 如果v6only 是 on：IPv4 用户将无法访问该服务（除非额外绑定 0.0.0.0:80）。

</br>

#### 3.3.2 访问控制和后端路由 - acl + use_backend

##### 3.3.2.1 访问控制 - acl

ACL (Access Control List，访问控制列表) 用于定义匹配条件，是 HAProxy 中用于定义请求匹配规则的核心功能，支持多种匹配条件和匹配方式。

ACL 用于测试某些条件是否为真，通常与以下功能结合使用：

- 流量路由：use_backend backend_server if acl_name
- 访问控制：http-request deny if acl_name
- 内容切换
- 请求修改：http-request set-header X-Forwarded-Proto https if { ssl_fc }

```sh
acl <acl_name> <criterion> [flags] [operator] [value] ...
#定义一条ACL，ACL是根据数据包的指定属性条件，以指定表达式计算出的 true/false 值。如：
acl url_ms1 path_beg -i /ms1/
#定义了名为 url_ms1 的ACL，该ACL在请求uri中，以/ms1/开头的路径（-i忽略大小写）时为 true
```

1. 常用匹配条件（criterion）

    | 网络层条件 | 说明 | 示例 |
    | ---- | ---- | ---- |
    | src | 匹配源IP地址 | acl internal src 192.168.1.0/24 |
    | src_port | 匹配源端口 | acl high_port src_port 1024:65535 |
    | dst | 匹配目标IP | acl local_dst dst 127.0.0.1 |
    | dst_port | 匹配目标端口 | acl https_port dst_port 443 |
    | HTTP请求条件 | | |
    | path | 完整路径匹配 | acl exact_path path /api/v1/user |
    | path_reg | 正则路径匹配 | acl is_uid path_reg ^/user/[0-9]+$ |
    | path_beg | 路径开头匹配 | acl is_api path_beg /api |
    | path_end | 路径结尾匹配 | acl is_php path_end .php |
    | url | 完整URL匹配(含参数) | acl full_url url /page?id=123 |
    | url_reg | 正则URL匹配 | acl has_token url_reg \?token=[A-Za-z0-9]+ |
    | url_param | URL参数匹配 | acl has_token url_param(token) -m found |
    | method | HTTP方法匹配 | acl is_post method POST |
    | HTTP头部条件 | | |
    | hdr(<name\>) | 头部精确匹配 | acl is_json hdr(Accept) application/json |
    | hdr_reg(<name\>) | 头部正则匹配 | acl is_mobile hdr_reg(User-Agent) (iPhone \| Android) |
    | hdr_sub(<name\>) | 头部子串匹配 | acl has_auth hdr_sub(Authorization) Bearer |
    | hdr_beg(<name\>) | 头部开头匹配 | acl is_ua_firefox hdr_beg(User-Agent) Mozilla/5.0 Firefox |
    | hdr_end(<name\>) | 头部结尾匹配 | acl is_xhr hdr_end(X-Requested-With) XMLHttpRequest |
    | 连接状态条件 | | |
    | ssl_fc | 是否SSL连接 | acl is_https ssl_fc |
    | ssl_c_used | 客户端使用证书 | acl client_cert ssl_c_used |
    | ssl_c_verify | 证书验证结果 | acl valid_cert ssl_c_verify 0 |
    | 高级匹配条件 | | |
    | req.hdr_cnt(<name\>) | 头部出现次数 | acl too_many_cookies req.hdr_cnt(Cookie) gt 5 |
    | req.fhdr(<name\>) | 提取第一个头部值 | acl first_host req.fhdr(Host) example.com |
    | req.cook(<name\>) | Cookie匹配 | acl logged_in req.cook(sessionid) -m found |
    | req.ver | HTTP版本 | acl is_http2 req.ver 2.0 |
    | req.rate | 请求速率 | acl too_fast req.rate gt 100 |

2. 匹配标志（flags）

    | 标志 | 说明 | 示例 |
    | ---- | ---- | ---- |
    | -i | 不区分大小写 | acl is_host hdr(host) -i example.com |
    | -m | 指定匹配方法 | acl is_num path_reg -m \^[0-9]+$ |
    | -f | 从文件加载 | acl bad_ips src -f /etc/haproxy/blocked.ips |
    | -n | 严格数字匹配 | acl port_8080 dst_port -n 8080 |

3. 匹配方法 (-m 参数)

    | 方法 | 说明 | 示例 |
    | ---- | ---- | ---- |
    | str | 完全匹配(默认) | acl exact hdr(Host) -m example.com |
    | sub | 子串匹配 | acl contains_foo hdr(User-Agent) -m sub Firefox |
    | reg | 正则匹配 | acl is_ip path_reg -m \^[0-9]{1,3}(\.[0-9]{1,3}){3}$ |
    | beg | 开头匹配 | acl is_www hdr(Host) -m beg www. |
    | end | 结尾匹配 | acl is_com hdr(Host) -m end .com |
    | dir | 目录匹配 | acl is_dir path_dir [-m dir] [/images/] |
    | dom | 域名匹配 | acl sub_domain hdr(Host) -m dom .example.com |

    `acl is_dir path_dir [-m dir] [/images/]`

    - path_dir 是一个匹配方法，它会检查请求的路径是否以 "/"斜杠 结尾（即是否像一个目录）
    - -m dir 通常可以省略，因为 path_dir 已经隐含了目录检查的功能。主要用于区分 文件请求 和 目录请求
    - path_dir 后面的 /images/ 缺省时，ACL则匹配请求的路径以 / 结尾（如 /images/，/static/）。

##### 3.3.2.2 后端路由 - use_backend

use_backend 用于根据特定条件（acl）将请求路由到指定的后端服务器组。它通常出现在 frontend 或 listen 部分，用于定义请求转发规则。

- 可以根据请求的各种属性（如URL路径、HTTP头、主机名等）进行路由决策
- 支持复杂的ACL（访问控制列表）条件
- 可以与其他指令如default_backend配合使用（如果没有设置default_backend且没有条件匹配，HAProxy会返回503错误）
- 允许基于权重进行后端选择

`use_backend <backend_name> [{if | unless} <condition>]`

```sh
frontend http_in
    #disabled    #禁用前端 http_in
    bind *:80
    #条件性禁用：disabled + acl
    #当访问路径以 /maintenance 开头时，禁用整个前端
    #acl maintenance_mode path_beg /maintenance
    #disabled if maintenance_mode
    #disabled if { file(/etc/haproxy/maintenance.flag) -m found }
    #示例1：基于主机名的路由
    acl host_web hdr(host) -i example.com    #请求头部头部的 host 精确匹配 example.com
    use_backend web_servers if host_web
    use_backend api_servers if { hdr(host) -i api.example.com }

    #示例2：基于URL路径的路由
    acl path_images path_beg -i /images/    #请求路径以 /images/ 开始
    use_backend image_servers if path_images

    #示例3：基于HTTP方法的复杂条件
    acl is_get method GET    #get请求方式
    acl is_post method POST    #post请求方式
    acl is_admin path_beg /admin/    #请求路径以 /admin/ 开始
    acl valid_user hdr(X-User-Id) -m found    #请求头部的 X-User-Id 完全匹配 found
    use_backend admin_servers if is_admin valid_user
    use_backend readonly_servers if is_get !is_admin
    use_backend write_servers if is_post !is_admin

    #示例4：基于源IP的路由
    acl internal_network src 192.168.1.0/24    #匹配源IP地址
    acl vpn_network src 10.0.0.0/8
    use_backend internal_servers if internal_network
    use_backend vpn_servers if vpn_network

    #默认后端
    default_backend default_servers


backend web_servers
backend api_servers
...
backend default_servers
```

disabled - 禁用前端服务

- disabled 指令会立即生效，不需要重启 HAProxy（reload 即可）
- 已建立的连接不会被强制断开，但不会接受新的连接
- 禁用前端不会影响其他前端或后端的运行
- 动态管理前端状态，可以在运行时通过 HAProxy 的 stats socket 动态启用/禁用，如：

    ```sh
    # 禁用前端
    echo "disable frontend http_front" | sudo socat stdio /var/run/haproxy/admin.sock
    # 启用前端
    echo "enable frontend http_front" | sudo socat stdio /var/run/haproxy/admin.sock
    # 查看状态
    echo "show stat" | sudo socat stdio /var/run/haproxy/admin.sock | grep http_front
    ```

    这种动态管理能力使得 disabled 指令在维护和故障排除时非常有用。

</br>

#### 3.3.3 URL请求重定向 - redirect

redirect 是 HAProxy 中用于重定向客户端请求的强大指令，它可以在不修改后端应用的情况下实现 URL 重定向、协议切换等多种功能。

`redirect { location | prefix | scheme | drop-query | set-cookie | append-slash } {args} [code {code}] {if | unless} <condition>`

- redirect location - 完整 URL 重定向，重定向到完整的绝对 URL（包含协议、域名、路径等）。
  - 适用于需要完全改变 URL 的场景（如域名切换）
  - 必须指定完整的 URL（包括 http:// 或 https://）
  - 会替换原始请求的所有部分（协议、主机、路径等）

- redirect prefix - 路径前缀重定向，修改 URL 的路径部分，保持协议和域名不变。
  - 仅修改请求路径的前缀部分
  - 自动继承原始请求的协议和域名
  - 适合路径结构调整（如 /old/path → /new/path）
  - 重定向协议或域名时，会保留原始请求的路径部分，只是替换协议和域名

- redirect scheme - 协议切换重定向，在 HTTP 和 HTTPS 之间切换协议。
  - 仅修改协议部分（http:// ↔ https://）
  - 自动保持原始请求的域名和路径
  - 常用于强制 HTTPS 跳转

- drop-query - 重定向时，丢弃原始请求的查询参数（移除 `?search=...`、`?uid=...` 等跟踪参数）
- set-cookie - 设置cookie值
- append-slash - 为没有斜杠的URL添加斜杠
- code - 指定HTTP状态码（默认为302）：
  - 301：永久重定向
  - 302：临时重定向
  - 303：查看其他位置
  - 307：临时重定向（保持方法）
  - 308：永久重定向（保持方法）

常用示例：

```sh
frontend http-in
    bind *:80
    bind *:443 ssl crt /etc/ssl/certs/mydomain.pem
    #示例1：HTTP到HTTPS重定向
    redirect scheme https code 301 if !{ ssl_fc }

    #示例2：路径重定向
    redirect prefix /new/path code 301 if { path_beg /old/path/ }

    #示例3：域名重定向
    acl is_old_domain hdr(host) -i old.example.com
    redirect prefix http://new.example.com code 301 if is_old_domain
    #redirect prefix http://new.example.com code 301 if { hdr(host) -i old.example.com }

    #示例4：域名重定向是否“保留路径”，原始请求：http://old.example.com/path/to/resource
    #prefix - 保留路径，只重置协议和域名，重定向到：https://new.example.com/path/to/resource
    redirect prefix https://new.example.com code 301 if { hdr(host) -i old.example.com }
    #location - 丢弃路径，完全替换 URL，重定向到：https://new.example.com (丢失了原始路径)
    redirect location https://new.example.com code 301 if { hdr(host) -i old.example.com }

    #示例5：重定向是否保留参数，原始请求：http://example.com/old/path/?search=hello
    #不使用 drop-query（默认），重定向到：http://example.com/new/path/?search=hello
    redirect prefix /new/path code 301 if { path_beg /old/path/ }
    #使用 drop-query，重定向到：http://example.com/new/path（?search=hello 被丢弃）
    redirect prefix /new/path drop-query code 301 if { path_beg /old/path/ }

    #示例6：添加尾部斜杠
    redirect append-slash if { path_reg ^/path[^/]*$ }

    #示例7：带条件的重定向
    acl is_mobile hdr(User-Agent) -i -m reg (android|iphone|ipad)
    redirect prefix http://m.example.com code 302 if is_mobile
```

- prefix 会保留原始请求的路径部分，只是替换协议和域名
- location 会使用完全指定的目标 URL，忽略原始路径
- 不带 drop-query：重定向时，会保留原始请求的查询参数（如 ?key=value，默认行为）。
- 使用 drop-query：重定向时，移除所有查询参数，仅保留路径部分。
- drop-query 不能单独使用，必须搭配 prefix 或 location 使用。

注意事项：

- 重定向会影响性能，应谨慎使用
- 永久重定向（301）会被浏览器缓存
- 复杂的重定向逻辑可能会使配置难以维护
- 在生产环境使用前应充分测试

redirect 指令是 HAProxy 流量管理的重要组成部分，合理使用可以简化架构、提高安全性并改善用户体验。

</br>

#### 3.3.4 HTTP请求操作 - http-request

http-request 和 http-response 是 HAProxy 中用于处理 HTTP 流量的两个核心指令，允许在请求和响应的不同阶段执行各种操作。

- http-request：作用于客户端请求到达 HAProxy 后，被转发到后端服务器前的阶段。可以用于修改请求、访问控制、重定向等。
- http-response：作用于从后端服务器返回响应后，发送给客户端前的阶段。可以用于修改响应头、过滤内容等（类似http-request）。

`http-request <action> [options] [condition]`

```sh
#访问控制：
#拒绝访问，不满足blacklist.lst文件的条件
http-request deny if { src -f /etc/haproxy/blacklist.lst }
#拒绝访问，请求路径以 /admin 开头且来源 IP 不是 192.168.1.100
http-request deny if { path_beg /admin } !{ src 192.168.1.100 }

#添加/删除/修改头部：
#如果是 HTTPS 访问，则设置X-Forwarded-Proto 为 https
http-request set-header X-Forwarded-Proto https if { ssl_fc }
#设置 X-Forwarded-For 头为客户端 IP，添加当前日期头
http-request set-header X-Forwarded-For %[src]
http-request add-header X-Haproxy-Current-Date %[date()]
#删除 User-Agent 头
http-request del-header User-Agent

#认证：
http-request auth unless { http_auth(users) }

#基于ACL的后端路由
#如果路径以 /api 开头，则使用 api_servers 后端
acl is_api path_beg /api
#use_backend api_servers if is_api    #简单路由，HAProxy的传统语法。
http-request use-backend api_servers if is_api  #动态路由，HAProxy的较新语法（1.6及以上版本）
#简单路由，将acl直接写入条件
use_backend static_servers if { path_beg /static/ }
#动态路由，在请求头的字段 X-API 中匹配 found
http-request use-backend dynamic_servers if { req.hdr(X-API) -m found }

#重定向
#如果非 HTTPS 访问，则 301 重定向到 HTTPS
redirect scheme https code 301 if !{ ssl_fc }    #简单重定向
#redirect scheme https code 301 unless { ssl_fc } 
#http-request redirect scheme https code 301 if !{ ssl_fc }
redirect prefix https://example.com code 301 if !{ ssl_fc }    #简单重定向
http-request redirect location https://%[hdr(host)]%[capture.req.uri] code 301 if !{ ssl_fc }    #复杂重定向
```

| 指令 | 阶段 | 是否可访问 HTTP 头/Path | 适用场景 |
| ---- | ---- | ---- | ---- |
| use_backend | 预处理 | ❌ 仅基于早期条件（如路径、ACL） | 简单路由（如路径匹配，/static/ → 静态服务器），可被 http-request use-backend 覆盖 |
| http-request use-backend | HTTP 处理 | ✅ 可检查 Headers、Cookie 等 | 动态路由（如 JWT(JSON Web Token)验证，基于 Header/Cookie 选择后端） |
| redirect | 预处理 | ❌ 仅基于早期条件 | 简单跳转（如强制 HTTPS，HTTP → HTTPS），可被 http-request redirect 覆盖  |
| http-request redirect | HTTP 处理 | ✅ 可基于完整请求信息 | 复杂跳转（如维护模式、A/B 测试） |

- use_backend 和 redirect 是前端预处理指令，在请求解析早期执行，适用于简单的后端选择和重定向规则。
- http-request use-backend 和 http-request redirect 是HTTP 处理阶段指令，可以访问完整的 HTTP 请求信息（如 Headers、Path、Query 等）。
  - 对于需要复杂条件或动态决策的后端选择，使用 http-request use-backend（可覆盖 use_backend）
  - 对于需要变量插值或复杂逻辑的重定向，使用 http-request redirect（可覆盖 redirect）
- 常用执行顺序：use_backend -> http-request use-backend -> redirect -> http-request redirect -> default_backend

</br>

### 3.4 后端配置（backend）

在 HAProxy 中，后端(backend)是指一组接收并处理前端(frontend)转发的请求的服务器。后端定义了负载均衡的策略、服务器列表、健康检查方式等关键配置。

后端主要配置要素

- 服务器池：处理请求的实际服务器列表
- 负载均衡算法：决定请求如何分配到各服务器
- 健康检查：监控服务器可用性
- 会话持久性：保持客户端与同一服务器的连接

| 参数 | 说明 |
| ---- | ---- |
| disabled | 禁用此backend，类似frontend |
| mode http | 模式设置（http/tcp），类似frontend |
| balance <algorithm\> | 负载均衡算法 |
| cookie <name\> <action\> [params ...] | 启用基于cookie的会话保持策略，最常用的是insert方式 |
| option httpchk [METHOD] [URL] [VERSION] </br> option tcp-check（默认） | 定义健康检查策略。如option httpchk GET /healthCheck.html HTTP/1.1 |
| log global | 日志配置，类似frontend |
| option httplog | 开启详细日志（httplog/tcplog），类似frontend |
| option forwardfor | 在请求中添加X-Forwarded-For Header，记录客户端ip，类似frontend |
| option http-keep-alive（默认）</br> option http-server-close </br> option httpclose | 是否启用长连接（Keep-Alive） </br> http-keep-alive：客户端和服务器均保持长连接。（默认） </br> http-server-close：客户端保持长连接，但服务器端主动关闭。 </br> httpclose：强制关闭所有连接（无 Keep-Alive）。 |
| option redispatch | 连接失败时重试其他服务器，类似frontend |
| timeout connect 5s | 定义haproxy与 后端服务器（server）连接超时时间（如果在同一个局域网可设置较小的时间） |
| timeout server 1m | 定义后端服务器（server）响应HAProxy请求的超时时间。 |
| timeout check 10s | 后端服务器健康检查的超时时间 </br> 默认情况下，健康检查的连接超时 + 响应超时时间为server命令中指定的inter值 </br> 如果配置了timeout check，HAProxy在健康检查请求中，会以inter作为的连接超时时间，并以timeout check的值作为响应超时时间 |
| acl <acl_name> <criterion\> [flags] [operator] [value] ... | 访问控制。定义一条ACL，类似frontend |
| http-request <action\> [options] [condition] </br> http-response <action\> [options] [condition] | HTTP头部操作，类似frontend |
| default-server [params ...] | 用于指定此backend下所有server的默认设置，可被server覆盖 |
| server <name\> <address\>[:<port\>] [params ...] | 定义后端服务器的 server 配置 |

```sh
cookie <name> <action> [params ...]
#如：
#insert 模式（Cookie插入）
cookie SERVER_ID insert indirect nocache [httponly secure domain example.com maxidle 30m maxlife 8h]
#prefix 模式（修改现有 Cookie）
cookie JSESSIONID prefix nocache
#使用
server server1 192.168.1.10:80 cookie s1
```

- action：主要操作模式 (必选其一)
  - insert - HAProxy 主动插入一个新 Cookie
  - prefix - 在应用已有的 Cookie 值前添加服务器标识
  - rewrite - 完全重写应用设置的 Cookie (不推荐，可能破坏应用)
- params：可选修饰参数
  - indirect - 如果客户端已携带指定 Cookie，则不插入/修改
  - nocache - 禁止代理 /CDN 缓存带有此 Cookie 的响应
  - httponly - 设置 HttpOnly 标志，限制 cookie 只能通过 HTTP 访问（防止 JavaScript 访问）
  - secure - 仅通过 HTTPS 传输 Cookie
  - domain <domain\> - 设置 Cookie 的作用域域名
  - maxidle <idle\> - 设置 Cookie 空闲过期时间（秒）
  - maxlife <life\> - 设置 Cookie 绝对过期时间（秒）
  - dynamic - 允许使用动态 Cookie 值
  - attr <value\> - 设置额外的 Cookie 属性（如 SameSite）

`server <name> <address>[:<port>] [params ...]`

- name: 服务器在配置中的唯一标识名称
- address: 服务器的 IP 地址或主机名
- port: 服务器监听的端口（可选，默认使用 backend 定义的端口）
- params: 可选的服务器参数
  1. 健康检查参数:
        - check: 启用健康检查（默认不检查），注意必须指定端口才能实现健康性检查
        - inter <delay\>: 健康检查间隔（默认2000 ms，2s）
        - rise <count\>: 将服务器标记为"正常"所需连续成功检查次数（默认2s）
        - fall <count\>: 将服务器标记为"故障"所需连续失败检查次数（默认3s）
  2. 负载均衡参数:
        - weight <value\>: 服务器权重（用于加权轮询，默认1）
        - backup: 标记为备份服务器（仅当所有非备份服务器不可用时使用）
  3. 连接参数:
        - maxconn <max\>: 最大并发连接数，当连接数到达maxconn后，新连接会进入等待队列（默认0，即无限）
        - maxqueue <max\>: 最大队列长度，当队列已满后，新请求会发至此backend下的其他server（默认0，即无限）
  4. SSL/TLS 参数:
      - ssl: 启用 SSL/TLS 连接到后端
      - verify [none|required]: SSL 证书验证
  5. 其他参数：
        - cookie <value\>：指定 server 每行的唯一标识（用于配合基于cookie的会话保持）
        - disabled：将后端服务器标记为"不可用状态"，即维护状态，除了持久模式

例子：

```sh
backend web_backend
    balance roundrobin
    cookie SERVERID insert indirect nocache    #会话保持：插入 SERVERID 的 Cookie值
    option httpchk GET /health
    option forwardfor
    option http-keep-alive
    http-request set-header X-Forwarded-Port %[dst_port]

    default-server check inter 2s rise 2 fall 3
    
    #自定义检查间隔
    server web1 192.168.1.10:80 cookie web_1 maxconn 100
    server web2 192.168.1.11:80 cookie web_2 check inter 2s fall 3 rise 2 maxconn 100
    server web3 192.168.1.12:80 cookie web_3 check inter 2s fall 3 rise 2 maxconn 100 backup
    server srv1 192.168.1.10:443 ssl verify none   #SSL终止，ssl后端使用SSL连接，verify none 禁用SSL证书验证(生产环境应配置正确验证)
    server srv1 192.168.1.10:80 slowstart 60s    #慢启动
    server bak1 192.168.1.20:80 backup    #备份服务器
    server srv1 192.168.1.10:80 weight 3    #权重设置
    server srv1 192.168.1.10:80 cookie s1

    #HTTP健康检查（使用7层，检查具体的路径）
    mode http
    option httpchk GET /health
    #http-check expect status 200
    server srv1 192.168.1.10:80 check [port 9000]
    #port 9000 指定健康检查使用9000端口而非服务端口(8080)

    #TCP健康检查（默认，如果没有指定 httpchk，则使用4层 tcp检测端口）
    mode tcp
    option tcp-check       #显式声明使用 TCP 检查
    tcp-check connect      #检查 TCP 连接
    tcp-check send "PING\r\n"  #可发送自定义数据（如 Redis 的 PING）
    tcp-check expect string "PONG"  #期望响应
    server srv1 192.168.1.10:80 check
    #错误处理
    errorfile 503 /etc/haproxy/errors/503.http    #自定义错误页面
    errorloc 503 http://www.example.com/maintenance.html    #重定向到维护页面
```

</br>

### 3.5 监听器配置（listen）

listen 是HAProxy配置中的一个重要部分，它允许在一个配置块中同时定义前端(frontend)和后端(backend)的设置，简化了配置过程，特别适用于简单的代理场景。

listen指令提供了一种简洁的方式来配置HAProxy，将前端和后端功能合并到一个配置块中，减少了配置文件的复杂性，特别适合不需要复杂路由规则的负载均衡场景。

- 对于简单场景，使用listen可以简化配置，不需要复杂的前端规则
- 对于复杂路由规则，仍建议使用分开的frontend和backend

listen语法结构

```sh
listen <name>     #为listen部分指定一个名称
    bind <address>:<port> [param*]    #定义监听的IP地址和端口
    mode <mode>   #设置代理模式(tcp或http)
    [other frontend and backend parameters]
    server <name> <address>:<port> [param*]    #定义后端服务器
```

例子:

```sh
#示例1：基本的HTTP负载均衡
#使用HTTP模式，监听所有接口的80端口
listen web_servers
    bind *:80
    mode http
    balance roundrobin
    server server1 192.168.1.10:80 check
    server server2 192.168.1.11:80 check
    server server3 192.168.1.12:80 check

#示例2：TCP负载均衡(如MySQL)
#使用TCP模式，监听3306端口(MySQL默认端口)
listen mysql_cluster
    bind *:3306
    mode tcp
    balance leastconn
    #主服务器db1和备用服务器db2
    server db1 192.168.2.10:3306 check
    server db2 192.168.2.11:3306 check backup

#示例3：带SSL终止的HTTPS服务
#监听443端口并启用SSL，指定SSL证书路径
listen secure_web
    bind *:443 ssl crt /etc/haproxy/certs/example.com.pem
    mode http
    balance roundrobin
    #自动将HTTP请求重定向到HTTPS
    redirect scheme https if !{ ssl_fc }
    server web1 192.168.3.10:80 check
    server web2 192.168.3.11:80 check

#示例4：带ACL的listen配置
#在listen中，使用ACL规则，将不同请求路由到不同的后端。
listen app_servers
    bind *:8080
    mode http
    acl is_static path_beg -i /static/ /images/
    use_backend static_servers if is_static
    default_backend dynamic_servers

backend static_servers
    server static1 192.168.4.10:80 check

backend dynamic_servers
    server dynamic1 192.168.4.20:8080 check
    server dynamic2 192.168.4.21:8080 check
```

</br>

### 3.6 负载均衡调度算法

> HAProxy负载均衡调度算法可以在HAProxy配置文件中设定。支持配置多组后端服务组，每个组可以分别指定一种调度算法。以下是HAProxy支持的几种调度算法。

在 HAProxy 中，负载均衡算法可以分为 动态（Dynamic） 和 静态（Static） 两大类，主要区别在于是否实时考虑后端服务器的状态（如连接数、响应时间等）。以下是分类说明及典型使用场景：

1. 静态调度算法

    静态算法在分配请求时 `不实时考虑后端服务器的当前负载状态`，仅根据预设规则（如权重、哈希值）进行分发。

    | 算法名称 | 原理 | 适用场景 |
    | ---- | ---- | ---- |
    | roundrobin（轮询，默认算法） | 按顺序依次将请求分发到后端服务器，循环往复。支持权重的运行时调整，支持慢启动（在刚启动时缓慢接收大量请求），仅支持最大4095个后端活动主机。| 后端服务器性能均匀，且无长连接影响。 |
    | static-rr（加权轮询） | 类似 Round Robin，但支持为服务器分配权重（weight），权重高的服务器获得更多请求。 | 服务器性能不一致时，通过权重分配流量。 |
    | source（源地址哈希） | 根据客户端源 IP 的哈希值分配服务器，同源 IP 地址的请求固定分配到同一台服务器。 | 需要会话保持（Session Persistence）的场景（如用户登录状态）。 |
    | uri（URI 哈希） | 根据请求 URI 路径的哈希值分配服务器，相同 URI 的请求固定分配到同一台服务器。 | 缓存优化（同一 URI 由同一服务器处理，提高缓存命中率）或需要固定 URI 到特定服务器的场景。 |
    | url_param（URL 参数哈希） | 根据 URL 中的特定参数（如 ?session_id=xxx）哈希分配。（如果指定的参数没有值，则回退到轮询）| 需要基于特定参数保持会话（如用户 ID，保证同一用户ID的请求分配至同一服务节点）。 |
    | first（首次可用） | 按服务器在列表中的顺序分配请求，直到服务器达到最大连接数后再切换到下一台。 | 需要严格优先使用某台服务器的场景（如备份服务器） |

    适合会话保持、缓存优化或服务器性能均匀的场景。例如：source（会话保持）、uri（缓存优化）、static-rr（权重分配）。

2. 动态调度算法

    动态算法会 `实时考虑后端服务器的状态（如连接数、响应时间等）`，动态调整流量分配。

    | 算法名称 | 原理 | 适用场景 |
    | ---- | ---- | ---- |
    | leastconn（最少连接） | 优先将请求分配给当前连接数最少的服务器（可配合权重使用）。 | 长连接或会话耗时差异较大的场景（如数据库、文件传输）。|
    | hdr（HTTP头哈希） | 根据客户端请求中的 特定 HTTP 头字段（Header） 计算哈希值，并将请求固定分配到同一台后端服务器。（如果指定的头字段不存在，则回退到轮询） | 需要自动规避高延迟或故障节点，优先选择响应快的服务器（如金融交易系统）。 |
    | random（随机分配） | 随机选择（可配合权重使用），但结合服务器状态（如健康检查）调整。 | 后端服务器数量多且性能接近。 |

    适合长连接、请求处理时间差异大或需自动容错的场景。例如：leastconn（数据库）、hdr（高可用 API）。

选择建议

- 会话保持：source、uri、url_param。
- 性能均衡：leastconn、static-rr。
- 简单公平：roundrobin、random。
- 动态调整：基于响应时间的算法。

根据实际业务需求（如会话、性能、缓存）和服务器特性（如权重、连接数）选择合适的算法。

#### 3.6.1 hdr 负载均衡算法详解

hdr 是 HAProxy 中的一种 动态负载均衡算法，它基于 HTTP 请求头（Header） 的内容进行流量分发，常用于高级路由和会话保持场景。以下是详细说明：

1. 算法原理

    作用：根据客户端请求中的 特定 HTTP 头字段（Header） 计算哈希值，并将请求固定分配到同一台后端服务器。

    核心机制：

    - 提取指定的 HTTP 头（如 `X-User-ID`、`Cookie` 等）。
    - 对头字段的值进行哈希计算，映射到后端服务器。
    - `相同头值` → `同一服务器`，实现会话保持（Session Persistence）。

2. 配置语法

    ```sh
    balance hdr(<header_name>) [use_domain_only]
    ```

    - <header_name>：要哈希的 HTTP 头字段（如 Cookie、X-Forwarded-For）。
    - use_domain_only（可选）：仅对头字段中的域名部分哈希（适用于 Host 头）。

    示例配置

    ```sh
    frontend http_in
        bind *:80
        default_backend web_servers

    #（1）基于 Cookie 头的会话保持
    backend web_servers
        balance hdr(Cookie)      # 根据 Cookie 分配请求
        server s1 192.168.1.1:80
        server s2 192.168.1.2:80

    #（2）基于自定义头 X-User-ID 的路由
    backend api_servers
        balance hdr(X-User-ID)   # 根据用户 ID 分配请求
        server s1 192.168.1.3:8080 check
        server s2 192.168.1.4:8080 check

        # 可选：如果头字段缺失，回退到最少连接
        default-server fall 1 rise 2 on-marked-down shutdown-sessions
    ```

3. 核心特性与使用场景

    - （1）会话保持（Session Persistence）：相同 HTTP 头值的请求始终分配到同一台服务器，如：
      - 需要保持用户登录状态（如基于 Cookie）。
      - 确保同一用户的请求由同一服务器处理（如购物车、游戏会话）。
    - （2）灵活的路由控制：可基于任意 HTTP 头字段（如 User-Agent、Authorization）进行路由。
      - 示例：将移动端流量（User-Agent 包含 Mobile）导向特定服务器组。
    - （3）动态哈希调整：后端服务器增减时，HAProxy 会自动重新计算哈希分布（类似一致性哈希）。

    ```sh
    场景 1：基于 Cookie 的会话保持
    #需求：确保用户登录后，始终访问同一台服务器。
    balance hdr(Cookie)
    #效果：Cookie: user_id=123 → 固定分配到服务器 A。

    场景 2：基于 JWT 或 API Key 的路由
    #需求：根据 Authorization 头中的 API Key 分配请求。
    balance hdr(Authorization)
    #效果：Authorization: Bearer xyz123 → 固定分配到服务器 B。

    场景 3：多租户流量隔离
    #需求：根据 X-Tenant-ID 头将不同租户的请求分发到专属服务器。
    balance hdr(X-Tenant-ID)
    ```

4. 注意事项
    - （1）HTTP 头必须存在
      - 如果指定的头字段不存在，HAProxy 会 回退到轮询（Round Robin）。
      - 解决方案：使用 hdr_reg（正则匹配）或结合 ACL 规则确保头字段有效。
    - （2）哈希冲突问题
      - 不同头值可能哈希到同一台服务器（概率低）。
      - 解决方案：增加后端服务器数量或调整哈希算法（如一致性哈希）。
    - （2）性能开销
      - 计算哈希比静态算法（如 roundrobin）略高，但影响可忽略。

5. 对比其他会话保持算法

    | 算法 | 依据 | 适用场景 | 灵活性 |
    | ---- | ---- | ---- | ---- |
    | hdr | 任意 HTTP 头字段 | 需要精细路由或会话保持 | ⭐⭐⭐⭐ |
    | source | 客户端源 IP | 简单 IP 级会话保持 | ⭐⭐ |
    | uri | 请求 URI 路径 | 缓存优化（如 CDN） | ⭐⭐⭐ |
    | url_param | URL 查询参数（如 ?id=） | 基于参数的路由 | ⭐⭐⭐ |

总结

hdr 的核心价值：通过 HTTP 头实现 `灵活的路由控制和会话保持`，适合需要精细流量管理的场景。

推荐使用场景：

- 基于用户身份（如 Cookie、JWT）的会话保持。
- 多租户或 API 网关的流量隔离。
- 需要动态哈希调整的高可用架构。

</br>

### 3.7 健康检查（Health Check）

HAProxy 的健康检查（Health Check）是确保后端服务器（Backend Server）可用性的关键机制，通过定期检测服务器状态，自动将故障节点从负载均衡池中移除或重新加入。常见的健康检查类型包括TCP连接检查、HTTP请求检查等。

1. 健康检查类型

    ```sh
    #（1）基本健康检查（TCP 层）：仅检测后端服务器的 TCP 端口是否可连接。
    backend web_servers
        server server1 192.168.1.10:80 check
        server server2 192.168.1.11:80 check
        #check 表示启用健康检查（默认间隔 2 秒）。

    #（2）HTTP 健康检查（应用层）：发送 HTTP 请求并验证响应状态码（如 200 OK）。
    backend web_servers
        server server1 192.168.1.10:80 check
        server server2 192.168.1.11:80 check
        option httpchk GET /health    #定义检查的 HTTP 方法和路径（如 /health）。
        http-check expect status 200  #指定期望的响应状态码。
        timeout check 10s

    #（3）自定义检查间隔，调整检查频率
    backend web_servers
        server server1 192.168.1.10:80 check inter 5s rise 2 fall 3
        #inter 5s：每 5 秒检查一次。
        #rise 2：连续 2 次成功标记为健康。
        #fall 3：连续 3 次失败标记为故障。
    ```

2. 高级健康检查选项

    ```sh
    #（1）HTTPS 健康检查
    backend https_servers
        server server1 192.168.1.10:443 check ssl verify none
        option httpchk GET /health
        http-check expect status 200
        timeout check 10s

    #（2）匹配响应内容：检查返回内容是否包含特定字符串
        http-check expect string "healthy"

    #（3）TCP 检查自定义：发送特定数据包并验证响应
    backend mysql_servers
        server db1 192.168.1.12:3306 check send-proxy verify none
    ```

3. 监控与管理

    - （1）日志记录
    健康检查日志需在 HAProxy 配置中启用：
    `log 127.0.0.1 local0 notice`

    - （2）查看健康状态

    ```sh
    #启用统计页面
    listen stats
        bind :9000
        stats enable
        stats uri /haproxy_stats
    ```

    访问 `http://<haproxy_ip>:9000/haproxy_stats` 查看服务器状态（颜色标记健康/故障）。

4. 常见问题

    - （1）误判（Flapping），如：服务器频繁被标记为故障又恢复。
      - 解决：调整 rise 和 fall 参数，增加检测稳定性。
    - （2）检查路径不可达，如：HTTP 检查返回 404。
      - 解决：确保后端服务器提供正确的健康检查端点（如 /health）。
    - （3）超时设置：调整超时时间避免误判
      - `timeout check 10s`

最佳实践

- 轻量级检查：使用专用低开销的检查端点（如 /health）。
- 隔离检查流量：避免健康检查影响业务流量。
- 结合容器化环境：在 Kubernetes/Docker 中，检查需兼容动态 IP 变化。

通过合理配置健康检查，HAProxy 可以显著提高服务的可靠性和容错能力。根据实际需求选择 TCP/HTTP 检查，并灵活调整参数以优化性能。

</br>

## 四、实例

```sh
#1 基本的 HTTP 配置
global
    log 127.0.0.1 local0 info
    chroot /var/lib/haproxy
    user haproxy
    group haproxy
    daemon

defaults
    log global
    mode http
    option httplog
    option dontlognull
    option http-server-close
    option forwardfor
    option httpchk
    timeout connect 5000
    timeout client 50000
    timeout server 50000

frontend http-in
    bind *:80
    default_backend servers

#2 反向代理配置
backend servers
    balance roundrobin
    server server1 192.168.1.100:8080 check
    server server2 192.168.1.101:8080 check

#3 负载均衡配置
backend servers
    balance leastconn
    server server1 192.168.1.100:8080 check weight=2
    server server2 192.168.1.101:8080 check

#4 HTTPS 配置
frontend https-in
    bind *:443 ssl crt /etc/haproxy/ssl/certificate.pem key /etc/haproxy/ssl/private.key
    default_backend servers

backend servers
    balance roundrobin
    server server1 192.168.1.100:8080 check
    server server2 192.168.1.101:8080 check
```

</br>
</br>

Via

- <https://www.cnblogs.com/bandaoyu/p/16752467.html>
- <https://blog.csdn.net/qq_65017742/article/details/141099157>
