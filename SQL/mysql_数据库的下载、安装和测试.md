# MySQL 数据库的下载、安装和测试

</br></br>

> 实例：Ubuntu 20.04 安装 mysql-server_5.7.31-1ubuntu18.04_amd64.deb-bundle.tar

</br>

## [目录](#目录)

1. [下载](#下载)
1. [安装](#安装)
1. [验证](#验证)
1. [卸载](#卸载)

</br>

### [下载](#目录)

官网下载mysql安装包

* <https://downloads.mysql.com/archives/community/>

    ![20211101090923](https://gitee.com/librarookie/picgo/raw/main/images/20211101090923.png)

 Product Version:　MySQL版本

Operating System:　Linux系统版本（Debian，Ubuntu，Redhat等等... 上图是Linux通用）

OS Version:　系统的细版本（如：Ubuntu 18.04，Ubuntu20.04）

</br>

### [安装](#目录)

* [离线安装](#离线安装)
* [Ubuntu在线安装](#ubuntu在线安装)

</br>

#### [离线安装](#安装)

1. 解压文件

    > tar -xvf mysql-server_5.7.31-1ubuntu18.04_amd64.deb-bundle.tar

    解压之后会出现多个deb文件（MySQL只需要安装八个，其他作用不明）

1. 按顺序安装（很重要，存在依赖关系）

    可以逐个安装，也可以一次性安装

    * 方案一：一个一个来安装（这样子能够搞懂依赖的关系）

        ```java
        sudo dpkg -i mysql-common_5.7.31-1ubuntu18.04_amd64.deb     // libmysqlclient20_5.7.31和libmysqlclient-dev_5.7.31 依赖common

        sudo dpkg -i libmysqlclient20_5.7.31-1ubuntu18.04_amd64.deb

        sudo dpkg -i libmysqlclient-dev_5.7.31-1ubuntu18.04_amd64.deb

        sudo dpkg -i libmysqld-dev_5.7.31-1ubuntu18.04_amd64.deb    // libmysqld-dev_5.7.31依赖libmysqlclient20_5.7.31和libmysqlclient-dev_5.7.31

        sudo dpkg -i mysql-community-source_5.7.31-1ubuntu18.04_amd64.deb 

        sudo apt-get install libaio1 libmecab2      // community-client依赖libaio1，community-server依赖libmecab2
        sudo apt-get install -f     // 如果上面依赖包安装后还不行就执行，该命令是解决系统全局所有依赖包问题

        sudo dpkg -i mysql-community-client_5.7.31-1ubuntu18.04_amd64.deb 

        // ubuntu 18.04 安装mysql-community-server时，除了上面依赖，还依赖mysql-client（sudo dpkg -i mysql-client_5.7.31-1ubuntu18.04_amd64.deb）
        sudo dpkg -i mysql-community-server_5.7.31-1ubuntu18.04_amd64.deb       // 安装时这个包时，会让输入两次MySQL密码，装完这步 MySQL就就可以登录了
        
        sudo dpkg -i mysql-server_5.7.31-1ubuntu18.04_amd64.deb     // mysql-server依赖community-server
        ```

    * 方案二： 如果不想这么麻烦，可以一次性安装

      * 依赖处理一: 可以一次性按顺序输入安装包名字，然后处理依赖，再安装（按向上建可以切换到之前输入过的命令）

        ```java
        sudo apt-get install -f     // 处理依赖问题
        ```

      * 依赖处理二: 提前安装所需依赖包，再一次性安装

        > sudo apt-get install libaio1 libmecab2    // 安装依赖包libaio1 libmecab2

        一次性按顺序输入安装包名字，进行安装（上面两个依赖处理，使用其一即可）

        ```java
        sudo dpkg -i mysql-common_5.7.31-1ubuntu18.04_amd64.deb libmysqlclient20_5.7.31-1ubuntu18.04_amd64.deb libmysqlclient-dev_5.7.31-1ubuntu18.04_amd64.deb  libmysqld-dev_5.7.31-1ubuntu18.04_amd64.deb mysql-community-source_5.7.31-1ubuntu18.04_amd64.deb mysql-community-client_5.7.31-1ubuntu18.04_amd64.deb mysql-community-server_5.7.31-1ubuntu18.04_amd64.deb mysql-server_5.7.31-1ubuntu18.04_amd64.deb 
        ```

</br>

#### [Ubuntu在线安装](#安装)

如果觉得离线安装麻烦的话，可以试试这个在线安装

* <https://www.jianshu.com/p/35e7af7db96a>

</br>

### [验证](#目录)

1. 测试MySQL是否安装成功

    * 方案一：查看MySQL 服务状态

        ```java
        sudo service mysql status       // 查看MySQL状态
        sudo service mysql start        // 启动MySQL服务
        sudo service mysql stop         // 停止MySQL服务

        // 输入 q 退出当前状态
        ```

        ![20211101091008](https://gitee.com/librarookie/picgo/raw/main/images/20211101091008.png)

    * 方案二：登录MySQL即可

        > mysql -u root -p　　　　// -u 用户名，-p 密码

        ![20211101091027](https://gitee.com/librarookie/picgo/raw/main/images/20211101091027.png)

1. 授予 root 远程访问

    ```java
    mysql -u root -p        // 本地登录MySQL
    grant all on *.* to 'root'@'%' identified by '123456' with grant option;    // 授权root访问
    flush privileges;        // 刷新
    ```

    1. 如果授予root远程访问后依然无法远程登录，修改配置文件`mysqld.cnf`
        > sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf        // 打开mysqld.cnf文件

    1. 注释掉文件底部的 `bind-address=127.0.0.1` 这一行，或者改成 `bind-address=0.0.0.0`

    1. 然后重启MySQL服务即可（快捷键 shift + g 可快速到达文件底部, "#"号表示注释该行）

        ![20211101091118](https://gitee.com/librarookie/picgo/raw/main/images/20211101091118.png)

 </br>

### [卸载](#目录)

* [MySQL卸载](https://www.cnblogs.com/librarookie/p/14152596.html "Ubuntu 18.04 彻底卸载MySQL")
* [官网参考](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/#repo-qg-apt-replace-direct)
