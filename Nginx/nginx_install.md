# Nginx 离线安装与介绍

</br>
</br>

## 一、安装

### 1.1 离线安装

1. 准备源代码包

    ```sh
    #从项目的官方网站或代码仓库（如 GitHub）下载源代码
    wget https://nginx.org/download/nginx-1.24.0.tar.gz     #下载
    tar -xzvf nginx-1.24.0.tar.gz       #解压
    cd nginx-1.24.0
    ```

2. 安装编译工具和依赖项

    ```sh
    #正则表达式库（pcre-devel）、 数据压缩库（zlib-devel）和 https模块库（openssl-devel）
    sudo yum install pcre pcre-devel zlib zlib-devel openssl openssl-devel
    ```

    zlib与zlib-devel关系：zlib-devel提供编译环境，zlib提供运行时环境。其他同理，*-devel 库只支持编译，并不支持运行。

3. 安装（3步曲）

    ```sh
    #配置构建环境
    ./configure --prefix=/usr/local/nginx \
                --with-http_ssl_module

    #编译
    make

    #安装
    sudo make install
    ```

    `./configure --help` 查看./configure 支持哪些参数

    - --with-xxx_xxx：  #表示默认`不安装`该模块。如果需要安装，则添加到 ./configure 参数中；
    - --without-xxx_xxx： #表示默认`会安装`该模块。如果不需要安装，则添加到 ./configure 参数中。
    - --prefix    #指定了Nginx的安装目录；
    - --with-http_ssl_module    #启用 SSL 支持，确保Nginx编译时包含SSL模块；
    - --with-http_stub_status_module    #启用Nginx状态信息模块（监控 Nginx 的性能和健康状态）

4. 验证

    ```sh
    #启动验证
    sudo /usr/local/nginx/sbin/nginx
    /usr/local/nginx/sbin/nginx -version
    ```

5. 卸载

    ```sh
    sudo rm -rf /usr/local/nginx
    #编译安装只需清理编译目录即可，即删除 --prefix 参数目录。    
    ```

    更多配置内容查看这篇：《[Nginx 配置与实战](https://www.cnblogs.com/librarookie/p/18773209)》

### 1.2 升级（安装缺失模块）

1. 检查已安装模块，命令：`/usr/local/nginx/sbin/nginx -V`

    ```sh
    nginx version: nginx/1.24.0
    built by gcc 4.8.5 20150623 (Red Hat 4.8.5-44) (GCC) 
    built with OpenSSL 1.0.2k-fips  26 Jan 2017
    TLS SNI support enabled
    configure arguments: --prefix=/usr/local/nginx --with-http_ssl_module
    ```

2. 安装模块

    由于已经安装了 --with-http_ssl_module 模块，所以以安装 --with-http_stub_status_module 为例：

    ```sh
    #1. 进入安装包 nginx-1.24.0 目录
    cd nginx-1.24.0

    #2. 重新配置构建环境
    ./configure --prefix=/usr/local/nginx \
                --with-http_ssl_module \
                --with-http_stub_status_module

    #3. 编译（make成功后，不用make install，否则nginx会重新安装，会将原来的配置覆盖）
    make
    ```

    如果不知道需要哪些模块，可以按照官方yum安装的模块，基本能满足95%以上的生产需求。yum安装模块如下，可自行参考：

    ```sh
    ./configure --prefix=/usr/local/nginx --user=$USER --group=$(id -gn) --with-compat --with-debug --with-file-aio --with-google_perftools_module --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_degradation_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_image_filter_module=dynamic --with-http_mp4_module --with-http_perl_module=dynamic --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-http_xslt_module=dynamic --with-mail=dynamic --with-mail_ssl_module --with-pcre --with-pcre-jit --with-stream=dynamic --with-stream_ssl_module --with-stream_ssl_preread_module --with-threads --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -pie'
    ```

3. 验证并更新

    make执行后，nginx-1.24.0/objs 目录下会重新生成一个 nginx 文件，这个就是新版本的程序了。

    为了清晰体现“新nginx”文件位置，以下操作均在 nginx-1.24.0 上级目录操作

    查看新nginx的编译模块： `nginx-1.24.0/objs/nginx -V`

    ```sh
    nginx version: nginx/1.24.0
    built by gcc 4.8.5 20150623 (Red Hat 4.8.5-44) (GCC) 
    built with OpenSSL 1.0.2k-fips  26 Jan 2017
    TLS SNI support enabled
    configure arguments: --prefix=/usr/local/nginx --with-http_ssl_module --with-http_stub_status_module
    ```

    检查模块无误后更新

    ```sh
    #1. 停止 nginx 服务
    sudo /usr/local/nginx/sbin/nginx -s stop

    #2. 覆盖旧 nginx 启动文件
    mv nginx-1.24.0/objs/nginx /usr/local/nginx/sbin/nginx

    #3. 启动测试
    sudo /usr/local/nginx/sbin/nginx
    ```

### 1.3 常用命令

1. 软链接（可选）

    ```sh
    #查看 PATH 环境
    echo $PATH

    #创建软链接
    sudo ls -s /usr/local/nginx/sbin/nginx /usr/sbin/nginx

    #测试软链接
    nginx -version
    sudo nginx
    sudo nginx -s stop
    ```

    [点击此处查看更多软链接介绍](https://www.cnblogs.com/librarookie/p/15127991.html#%E8%BD%AF%E8%BF%9E%E6%8E%A5 '软链接传送阵')

2. 服务操作

    ```sh
    nginx -s reload  #热重启：向主进程发送信号，重新加载配置文件。
    nginx -s reopen  #重启 Nginx
    nginx -s stop    #快速关闭
    nginx -s quit    #等待工作进程处理完成后关闭
    nginx -T         #查看当前 Nginx 最终的配置
    nginx -t         #检查配置是否有问题
    ```

### 1.4 Nginx 开机自启

#### 1.4.1 Centos 6.x 配置

1. 新建 nginx 服务脚本文件（官方）

    ```sh
    #1. 新建 nginx 文件
    sudo touch /etc/init.d/nginx

    #2. 设置文件权限
    sudo chmod a+x /etc/init.d/nginx

    #3. 配置文件脚本
    sudo tee /etc/init.d/nginx <<-EOF
    #!/bin/sh
    #
    # nginx - this script starts and stops the nginx daemon
    #
    # chkconfig:   - 85 15
    # description:  NGINX is an HTTP(S) server, HTTP(S) reverse \
    #               proxy and IMAP/POP3 proxy server
    # processname: nginx
    # config:      /etc/nginx/nginx.conf
    # config:      /etc/sysconfig/nginx
    # pidfile:     /var/run/nginx.pid
    # Source function library.
    . /etc/rc.d/init.d/functions
    # Source networking configuration.
    . /etc/sysconfig/network
    # Check that networking is up.
    [ "$NETWORKING" = "no" ] && exit 0

    #根据实际情况，修改nginx的安装路径和配置文件
    nginx="/usr/local/nginx/sbin/nginx"
    NGINX_CONF_FILE="/usr/local/nginx/conf/nginx.conf"

    prog=$(basename $nginx)
    [ -f /etc/sysconfig/nginx ] && . /etc/sysconfig/nginx
    lockfile=/var/lock/subsys/nginx
    make_dirs() {
    # make required directories
    user=`$nginx -V 2>&1 | grep "configure arguments:" | sed 's/[^*]*--user=\([^ ]*\).*/\1/g' -`
    if [ -z "`grep $user /etc/passwd`" ]; then
        useradd -M -s /bin/nologin $user
    fi
    options=`$nginx -V 2>&1 | grep 'configure arguments:'`
    for opt in $options; do
        if [ `echo $opt | grep '.*-temp-path'` ]; then
            value=`echo $opt | cut -d "=" -f 2`
            if [ ! -d "$value" ]; then
                # echo "creating" $value
                mkdir -p $value && chown -R $user $value
            fi
        fi
    done
    }
    start() {
        [ -x $nginx ] || exit 5
        [ -f $NGINX_CONF_FILE ] || exit 6
        make_dirs
        echo -n $"Starting $prog: "
        daemon $nginx -c $NGINX_CONF_FILE
        retval=$?
        echo
        [ $retval -eq 0 ] && touch $lockfile
        return $retval
    }
    stop() {
        echo -n $"Stopping $prog: "
        killproc $prog -QUIT
        retval=$?
        echo
        [ $retval -eq 0 ] && rm -f $lockfile
        return $retval
    }
    restart() {
        configtest || return $?
        stop
        sleep 1
        start
    }
    reload() {
        configtest || return $?
        echo -n $"Reloading $prog: "
        killproc $nginx -HUP
        RETVAL=$?
        echo
    }
    force_reload() {
        restart
    }
    configtest() {
    $nginx -t -c $NGINX_CONF_FILE
    }
    rh_status() {
        status $prog
    }
    rh_status_q() {
        rh_status >/dev/null 2>&1
    }
    case "$1" in
        start)
            rh_status_q && exit 0
            $1
            ;;
        stop)
            rh_status_q || exit 0
            $1
            ;;
        restart|configtest)
            $1
            ;;
        reload)
            rh_status_q || exit 7
            $1
            ;;
        force-reload)
            force_reload
            ;;
        status)
            rh_status
            ;;
        condrestart|try-restart)
            rh_status_q || exit 0
                ;;
        *)
            echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload|configtest}"
            exit 2
    esac
    EOF
    ```

    此脚本是nginx官方提供的，地址：<http://wiki.nginx.org/RedHatNginxInitScript>

    注意：如果是自定义安装的nginx, 修改根据实际情况修改`命令程序路径`和`配置文件路径`。

2. 服务脚本命令

    ```sh
    /etc/init.d/nginx start      #启动服务
    /etc/init.d/nginx stop       #停止服务  
    /etc/init.d/nginx restart    #重启服务
    /etc/init.d/nginx status     #查看服务的状态
    /etc/init.d/nginx reload     #刷新配置文件
    ```

3. 系统管理（chkconfig）

    上面的方法完成了用脚本管理nginx服务的功能，但是还是不太方便，比如要设置nginx开机启动等。

    这个时候我们可以使用chkconfig来进行管理。

    ```sh
    #1. 将nginx服务加入chkconfig管理列表
    sudo chkconfig --add /etc/init.d/nginx

    #设置终端模式开机启动
    sudo chkconfig nginx on

    #2. 服务管理
    service nginx start     #启动服务
    service nginx stop      #停止服务
    service nginx restart   #重启服务
    service nginx status    #查询服务的状态
    service nginx relaod    #刷新配置文
    ```

#### 1.4.2 Centos 7.x 配置

1. 新建 nginx 服务文件

    ```sh
    #1. 新建 nginx 文件
    sudo touch /lib/systemd/system/nginx

    #2. 配置文件脚本
    sudo tee /lib/systemd/system/nginx <<-EOF
    [Unit]
    Description=nginx service
    After=network.target
    
    [Service]
    Type=forking
    ExecStart=/usr/local/nginx/sbin/nginx
    ExecReload=/usr/local/nginx/sbin/nginx -s reload
    ExecStop=/usr/local/nginx/sbin/nginx -s quit
    PrivateTmp=true
    
    [Install] 
    WantedBy=multi-user.target
    EOF
    ```

   - `[Unit]`： 服务的说明
       - `Description`： 描述服务
       - `After`： 描述服务类别
   - `[Service]`： 服务运行参数的设置
       - `Type=forking`： 后台运行
       - `ExecStart`： 服务启动命令（绝对路径）
       - `ExecReload`： 服务重启命令（绝对路径）
       - `ExecStop`： 服务停止命令（绝对路径）
       - `PrivateTmp=True`： 表示给服务分配独立的临时空间
   - `[Install]`： 运行级别下服务安装的相关设置，可设置为多用户，即系统运行级别为3

2. 系统管理（systemctl）

    ```sh
    #1. 开机自启（enable启用/disable不启用）
    sudo systemctl enable nginx.service

    #2. 服务管理
    sudo systemctl start nginx.service　         #启动nginx服务
    sudo systemctl stop nginx.service　          #停止服务
    sudo systemctl restart nginx.service　       #重新启动服务

    #3. 检查服务
    systemctl status nginx.service          #查看服务当前状态
    systemctl list-units --type=service     #查看所有已启动的服务
    ```

</br>

## 二、介绍

Nginx负载均衡器的特点是：

- 工作在网络的 7 层之上，可以针对http应用做一些分流的策略，比如针对域名、目录结构；
- Nginx安装和配置比较简单，测试起来比较方便；
- 也可以承担高的负载压力且稳定，一般能支撑超过上万次的并发；
- Nginx可以通过端口检测到服务器内部的故障，比如根据服务器处理网页返回的状态码、超时等等，并且会把返回错误的请求重新提交到另一个节点，不过其中缺点就是不支持url来检测；
- Nginx对请求的异步处理可以帮助节点服务器减轻负载；
- Nginx能支持http和Email，这样就在适用范围上面小很多；
- 默认有三种调度算法: 轮询、weight以及ip_hash（可以解决会话保持的问题），还可以支持第三方的fair和url_hash等调度算法；

### 2.1 Nginx 作用

Nginx 的最重要的几个使用场景：

1. 静态资源服务，通过本地文件系统提供服务；
2. 反向代理服务，延伸出包括缓存、负载均衡等；
3. API 服务， OpenResty ；

对于前端来说 Node.js 并不陌生， Nginx 和 Node.js 的很多理念类似， HTTP 服务器、事件驱动、异步非阻塞等，且 Nginx 的大部分功能使用 Node.js 也可以实现，但 Nginx 和 Node.js 并不冲突，都有自己擅长的领域。 Nginx 擅长于底层服务器端资源的处理（静态资源处理转发、反向代理，负载均衡等）， Node.js 更擅长上层具体业务逻辑的处理，两者可以完美组合。

用一张图表示：

![202503131808478](https://gitee.com/librarookie/picgo/raw/master/img/202503131808478.png)

### 2.2 Nginx 应用核心概念

代理是在服务器和客户端之间假设的一层服务器，代理将接收客户端的请求并将它转发给服务器，然后将服务端的响应转发给客户端。

不管是正向代理还是反向代理，实现的都是上面的功能。

![202503122002240](https://gitee.com/librarookie/picgo/raw/master/img/202503122002240.png)

### 2.3 正向代理

> 正向代理：为了从原始服务器(origin server)取得内容，客户端向代理发送一个请求并指定目标(原始服务器)，然后代理向原始服务器转交请求并将获得的内容返回给客户端。

1. 正向代理是为客户端服务的，客户端可以根据正向代理访问到它本身无法访问到的服务器资源。
2. 正向代理对客户端是透明的，对服务端是非透明的，即服务端并不知道自己收到的是来自代理的访问还是来自真实客户端的访问。

### 2.4 反向代理

> 反向代理（Reverse Proxy）方式是指以代理服务器来接受互联网上的连接请求，然后将请求转发给内部网络上的服务器，并将从服务器上得到的结果返回给客户端；此时代理服务器对外就表现为一个反向代理服务器。

1. 反向代理是为服务端服务的，反向代理可以帮助服务器接收来自客户端的请求，帮助服务器做请求转发，负载均衡等。
2. 反向代理对服务端是透明的，对客户端是非透明的，即客户端并不知道自己访问的是代理服务器，而服务器知道反向代理在为它服务。

反向代理的优势：

- 隐藏真实服务器；
- 负载均衡便于横向扩充后端动态服务；
- 动静分离，提升系统健壮性；

### 2.5 动静分离

> 动静分离是指在 web 服务器架构中，为提升整个服务的访问性和可维护性，将`静态页面（静态内容接口）`与`动态页面（动态内容接口）`分开不同系统访问的架构设计方法。

![202503122006369](https://gitee.com/librarookie/picgo/raw/master/img/202503122006369.png)

一般来说，都需要将动态资源和静态资源分开，由于 Nginx 的高并发和静态资源缓存等特性，经常将静态资源部署在 Nginx 上。

- 如果请求的是静态资源，直接到静态资源目录获取资源；
- 如果是动态资源的请求，则利用反向代理的原理，把请求转发给对应后台应用去处理，从而实现动静分离。

使用前后端分离后，可以很大程度提升静态资源的访问速度，即使动态服务不可用，静态资源的访问也不会受到影响。

### 2.6 负载均衡

> Nginx 实现负载均衡，一般来说指的是将请求转发给服务器集群，核心是「分摊压力」
> </br>单个服务器解决不了的问题，可以使用多个服务器，然后将请求分发到各个服务器上，将负载分发到不同的服务器，这就是负载均衡。

一般情况下，客户端发送多个请求到服务器，服务器处理请求，其中一部分可能要操作一些资源比如数据库、静态资源等，服务器处理完毕后，再将结果返回给客户端。

这种模式对于早期的系统来说，功能要求不复杂，且并发请求相对较少的情况下还能胜任，成本也低。

随着信息数量不断增长，访问量和数据量飞速增长，以及系统业务复杂度持续增加，这种做法已无法满足要求，并发量特别大时，服务器容易崩。

很明显这是由于服务器性能的瓶颈造成的问题，除了堆机器之外，最重要的做法就是负载均衡。

请求爆发式增长的情况下，单个机器性能再强劲也无法满足要求了，这个时候集群的概念产生了，

![202503122007541](https://gitee.com/librarookie/picgo/raw/master/img/202503122007541.png)

Nginx 实现负载均衡的策略：

- 轮询策略（默认）：将所有客户端请求轮询分配给服务端。
  - 这种策略是可以正常工作的，但是如果其中某一台服务器压力太大，出现延迟，会影响所有分配在这台服务器下的用户。
- 最小连接数策略（least_conn）：将请求优先分配给压力较小的服务器，它可以平衡每个队列的长度，并避免向压力大的服务器添加更多的请求。
- 最快响应时间策略（least_time）：优先分配给响应时间最短的服务器。
- 客户端 ip 绑定策略（ip_hash）：来自同一个 ip 的请求永远只分配一台服务器（有效解决了动态网页存在的 session 共享问题）
- 随机策略（random）：随机分配客户端请求给服务端

</br>

### 2.7 Nginx 高可用

一般是Nginx + Keepalived来实现Nginx的高可用。

有兴趣的可以看看这篇：《[Keepalived 的高可用配置与使用](https://www.cnblogs.com/librarookie/p/18615518)》

</br>
</br>

Via

- <https://www.cnblogs.com/lywJ/p/10710361.html>
- <https://www.cnblogs.com/ratelcloud/p/18595015>
