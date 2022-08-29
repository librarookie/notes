# Linux系统中普通用户使用1024以下的端口（80、443）

## 背景

浏览器的HTTP默认端口为 `80`， HTTPS的默认端口为 `433`，在Linux中将Tomcat配置为这些端口后，再使用普通用户启动时报错，报错信息如下：

![20220706163852](https://gitee.com/librarookie/picgo/raw/main/images/md_20220706163852.png)

## 介绍

在Linux系统中，一般情况下，小于1024的端口是不对普通用户开放的。对于一些服务，过高的权限，会带来一定的风险。所以很多时候当我们为安全起见想要以普通用户启动使用80端口的apache、nginx或tomcat时，就会被权限禁止。但是还是有一些技巧能够让普通用户使用小于1024的端口的。本文就来介绍一下Linux中如何让普通用户使用1024以下端口。

## 方案

### 方案一： iptables端口转发

如果要运行的程序有权限监听其他端口，那么这个方法是可以使用的，首先让程序运行在非root帐户下，并绑定高于1024的端口，在确保能正常工作的时候，将低端口通过端口转发，将低端口转到高端口，从而实现非root运行的程序绑定低端口。要使用此方法可以使用下面的方式：

一般主要都是，应用程序使用1024以上的端口，然后用防火墙(硬件防火墙或iptables)把80端口转发到对应的程序端口，例如把80转发至8080端口。

iptables添加转发规则：

#iptables -A PREROUTING -t nat -p tcp --dport 80 -j REDIRECT --to-port 8080

然后把转发规则保存至配置文件

#service iptables save

或者直接修改配置文件

#vim /etc/sysconfig/iptables

在*nat项下添加

-A PREROUTING -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8080

另外：

不建议通过chmod u+s的方式，如此一来就有违安全性的初衷了。


查看防火墙策略

```md
sudo iptalbes -L
```

1. 开启端口转发

    - 临时开启
    sysctl -w net.ipv4.ip_forward=1


2. 查看sysctl配置
    sysctl -a |grep 



3. 新增防火墙规则

iptables -A PREROUTING -t nat -p tcp --dport 80 -j REDIRECT --to-port 8080

iptables -F -t nat iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to:8088

在*nat项下添加

-A PREROUTING -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8080

第一步使用sysctl确保启用IP FORWARD功能(此功能在Red Hat/CentOS默认是被禁用的)，注意，代码中使用的sysctl设置是临时性设置，重启之后将会被重置，如果要长久保存，需要在/etc/sysctl.conf文件内修改：

1.# Default value is 0， need change to 1.

2.# net.ipv4.ip_forward = 0

3.net.ipv4.ip_forward =1

然后从文件中加载新的配置

1.# load new sysctl.conf

2.sysctl -p /etc/sysctl.conf

3.# or sysctl -p

4.# default filename is /etc/sysctl.conf


sysctl 

第二步就是使用iptables的规则来实现端口转发到程序所在的端口，示例中我们要将80端口转发到8088。

此种方法能够比较好的达到我们的目的，我们的程序可以通过非root用户来运行，并能够对外提供低端口号的服务。

### 方案二： 分配用户权限（CAP_NET_BIND_SERVICE）


TODO port 

从 2.1 版本开始，Linux 内核有了能力的概念，这使得普通用户也能够做只有超级用户才能完成的工作，这包括使用端口。

获取CAP_NET_BIND_SERVICE能力，即使服务程序运行在非root帐户下，也能够banding到低端口。使用的方法：

1.# 设置CAP_NET_BIND_SERVICE

2.setcap cap_net_bind_service =+ep /path/to/application

Note：

1. 这个方法并不是所有Linux系统通适，内核在2.1之前的并没有提供，因此你需要检查要使用此方法所在系统是否支持；

2. 另外需要注意的是，如果要运行的程序文件是一个脚本，这个方法是没有办法正常工作的。



### 方案二： SetUID


使用的方法是：

1.chown root.root /path/to/application

2.#使用SetUID

3.chmod u+s /path/to/application

我们可以看到在系统下，/usr/bin/passwd这种文件，就使用了SetUID，使得每个系统能的用户都能用passwd来修改密码——这是要修改/etc/passwd的文件(而这个只有root有权限)。

既然要使用非root用户运行程序，目的就是要降低程序本身给系统带来的安全风险，因此，本方法使用的时候需要特别谨慎。

</br>
</br>

TAG Unreleased
