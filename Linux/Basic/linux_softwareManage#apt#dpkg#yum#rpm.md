# Linux 软件管理（yum, apt/apt-get, dpkg/rpm）

</br>
</br>

## yum

| 操作 | 命令 |
| ---- | ---- |
| 更新源 | sudo yum clean all && sudo yum makecache |
| 安装包 | sudo yum install <package_name>[-<version\>] |
| 升级包 | sudo yum upgrade <package_name> </br> 升级所有： sudo yum update |
| 卸载包 | sudo yum remove <package_name> |
| 降级包 | sudo yum downgrade <package_name>-<version\> |
| 查找包 | yum search <package_name> |
| 已安装 | yum list installed [<package_name>] |
| 可用版本 | yum list <package_name> --showduplicates |
| 锁定版本 | sudo yum versionlock add <package_name>[-version] |
| 解锁锁定 | sudo yum versionlock delete <package_name> |
| 清空锁定 | sudo yum versionlock clear |
| 查看锁定 | yum versionlock list |

tip: 锁定版本需要自己安装 sudo yum install yum-plugin-versionlock

</br>

## apt/apt-get

| 操作 | 命令 |
| ---- | ---- |
| 编辑源 | sudo apt edit-sources [<source_name>] |
| 更新源 | sudo apt/apt-get update |
| 安装包 | sudo apt/apt-get install <package_name>[=<version\>] |
| 升级包 | sudo apt/apt-get upgrade <package_name> |
| 卸载包 | sudo apt/apt-get remove <package_name> |
| 清除包 | sudo apt/apt-get purge <package_name> |
| 已安装 | apt list [<package_name>] -i/--installed |
| 查找包 | apt/apt-cache search <package_name> --names-only |
| 安装细节 | apt/apt-cache show <package_name> |
| 修复依赖 | sudo apt-get -f install |
| 卸载依赖 | sudo apt-get autoremove |
| 历史版本 | apt-cache policy <package_name> |
| 可用版本 | apt list <package_name> -a/--all-versions </br> apt-cache madison <package_name> |
| 锁定版本 | sudo apt-mark hold <package_name> |
| 解锁锁定 | sudo apt-mark unhold <package_name> |
| 查看锁定 | apt-mark showhold |

</br>

## dpkg/rpm

| 操作 | dpkg | rpm |
| ---- | ---- | ---- |
| 安装 | sudo dpkg -i <deb_name> [--force-depends] | sudo rpm -ivh <rpm_name> |
| 升级 |  | sudo rpm -Uvh <rpm_name> |
| 卸载 | sudo dpkg -r <deb_name> | sudo rpm -e [--nodeps] <rpm_name> |
| 清除 | sudo dpkg -P/--purge <deb_name> |  |
| 查找 | dpkg -l <deb_name> </br> sudo dpkg-query -W "*chrome*" | rpm -qa <rpm_name> |
| 包信息 | dpkg -s <deb_name> | rpm -qi <rpm_name> |
| 包内容 | dpkg -L <deb_name> | rpm -ql <rpm_name> |
| 查包名 | dpkg -S <file_name> |rpm -qf <file_name> |

</br>

## 源码编译安装

> 以 nginx 安装为例：

1. 准备源代码包

    ```sh
    #从项目的官方网站或代码仓库（如 GitHub）下载源代码
    wget https://nginx.org/download/nginx-1.24.0.tar.gz     #下载
    tar -xzvf nginx-1.24.0.tar.gz       #解压
    cd nginx-1.24.0
    ```

2. 准备编译环境

    ```sh
    #安装编译工具和依赖，比如 gcc（GNU 编译器集合）和 make。
    sudo yum install pcre-devel zlib-devel # 安装 nginx 依赖包
    ```

3. 安装（3步曲）

    ```sh
    #配置构建环境
    ./configure --prefix=/usr/local/nginx  #--prefix指定了Nginx的安装目录，其他的配置项按需添加

    make    #编译

    sudo make install    #安装
    ```

4. 验证

    ```sh
    #启停验证
    /usr/local/nginx/sbin/nginx -version
    sudo /usr/local/nginx/sbin/nginx
    sudo /usr/local/nginx/sbin/nginx -s stop
    ```

5. 软链接（可选）

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

6. 卸载

    ```sh
    #1. 删除软链接
    sudo rm -f /usr/sbin/nginx

    #2. 删除安装目录
    sudo rm -rf /usr/local/nginx

    #2. 执行make自带的卸载程序卸载（部分软件支持）
    #sudo make uninstall
    ```

    note：因为没有使用包管理器安装，所以需要手动删除安装的文件。如果你在配置时指定了 --prefix，只需删除该目录即可。

</br>

## 结论

- 方便性：“apt-get机制”最优，“dpkg机制”次之，“从源码编译安装机制”最末。“apt-get机制”已经预先解决依赖问题，“从源码编译安装机制”需要我们自己解决依赖问题
- 可定制性：“从源码编译安装机制”最优，“dpkg机制”次之，“apt-get机制”最末。“从源码编译安装机制”允许我们自定义安装参数，“apt-get机制”几乎完全采用默认的安装参数
- 所需权限：“从源码编译安装机制”所需权限可以是最小，“dpkg机制”次之，“apt-get机制”所需权限最大。在我们不拥有较高权限（比如root权限）的情况下，只能采用“从源码编译安装机制”

</br>
</br>

Via

- <http://c.biancheng.net/view/2952.html>
- <https://rqsir.github.io/2019/04/13/linux-make-install%E7%9A%84%E5%AE%89%E8%A3%85%E4%B8%8E%E5%8D%B8%E8%BD%BD/>
- <https://blog.csdn.net/liudsl/article/details/79200134>
