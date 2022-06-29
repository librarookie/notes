# 通过 hosts文件配置本地域名

</br>
</br>

## 概念

1. `DNS`: 域名系统（Domain Name System），是互联网的一项服务。它作为将域名和IP地址相互映射的一个分布式数据库，能够使人更方便地访问互联网。
    - 将域名映射到对应的IP地址。
    - 互联网通过IP定位浏览器建立连接，但是我们不易区别IP，为了方便用户辨识IP所代表的意义，操作系统会将IP和域名进行转换
    - DNS服务器可以看作注册表，记录域名及对应的IP。浏览器访问网址时会根据域名在此服务器获得IP.

2. `hosts文件`: 操作系统操作的 `IP` 和 `域名` 本地映射文件。
    - 可以视为DNS server的重写，一旦查到了指定的域名，就不会继续查找DNS server， 所以可以节省时间
    - hosts设置的IP地址是静态的，如果web app的宿主机地址发生改变，对应的hosts也要改写。

</br>

## 域名查询顺序

浏览器缓存  >  本地操作系统缓存  >  DNS服务器（路由缓存 > 互联网DNS缓存服务器）  >  递归搜索

- 浏览器缓存: 只存下浏览器自己访问过的域名.
  - 为了加快访问速度，Google Chrome浏览器采用了预提DNS记录，在本地建立DNS缓存的方法，加快网站的连接速度。
  - chrome://net-internals/#dns 这里可以看各域名的DNS 缓存时间。
  - chrome对每个域名会默认缓存60s。

- 本地操作系统缓存: 电脑访问过的, 具体可通过hosts文件设置
  - Windows查看缓存: `ipconfig /displaydns`
  - Windows刷新缓存: `ipconfig /flushdns`

- DNS服务器: 包括路由缓存和互联网DNS服务器, 以及13台根服务器

</br>

## hosts文件配置

> 通过上面介绍可知域名查询顺序，所以我们可以通过修改操作系统的hosts文件，来配置本地域名。

### Windows

1. 配置

    ```md
    # 打开 hosts文件，文件路径如下：
    C:\Windows\System32\drivers\etc\hosts

    # 添加域名配置
    192.168.1.1     www.test.com
    ```

    tips
    - 文件修改时，注意域名后不要有空格
    - 如果是用第三方工具编辑hosts，保存文件时注意编码格式，必须是`ANSI`。

2. 刷新与查看

    ```md
    # 进入 cmd终端窗口（小黑窗）
    win + r  >  cmd  >  回车

    # 查看 DNS缓存
    ipconfig /displaydns

    # 如果没生效， 则刷新 DNS缓存
    ipconfig /flushdns
    ```

### Linux

1. 配置

    ```md
    # 打开 hosts文件，文件路径如下：
    sudo vim /etc/hosts

    # 添加域名信息
    192.168.1.1     www.test.com
    ```

2. 刷新

    如果域名未生效，则可以重启网络来刷新，下面是centos操作
    `service network restart`

</br>

## 测试

直接ping域名即可，如：

`ping www.test.com`

Windows还可以查看DNS缓存。

</br>

## 常见问题

1. Windows中的 hosts文件编辑后无法保存

    - 原因： hosts文件只有可读权限
      - 处理： 去掉hosts属性中的“可读”即可，如图所示：

        ![20220629171821](https://cdn.jsdelivr.net/gh/librarookie/Picgo/images/md_20220629171821.png)

2. 修改了hosts文件，添加了域名映射信息，但是不生效，试过了重新启动和刷新DNS都不行

    - 原因1： 域名信息配置不规范; 或者域名、ip拼写错误；
    - 原因2： 使用第三方工具编辑 hosts文件，保存后hosts文件的编码格式变了，而windows对于hosts文件只能读取ASCII编码，所以hosts文件的编码必须是 `ANSI`。
      - 处理： 将hosts文件的域名信息填写好，然后另存为，在编码处选择“ANSI”，最后确定。

        ![20220629171956](https://cdn.jsdelivr.net/gh/librarookie/Picgo/images/md_20220629171956.png)
        ![hosts_faq](https://cdn.jsdelivr.net/gh/librarookie/Picgo/images/md_hosts_faq.png)

</br>
</br>
