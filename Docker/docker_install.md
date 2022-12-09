# Docker 介绍与使用



```sh
curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -

-f (--fail) 表示在服务器错误时，阻止一个返回的表示错误原因的 html 页面，而由 curl 命令返回一个错误码 22 来提示错误
-L,--location:如果服务器报告请求的页面已移动到其他位置（用location:header和3xx 响应代码），此选项将使curl在新位置上重新执行请求。
-S, --show-error：当与-s，--silent一起使用时，它会使curl在失败时显示错误消息。
-s，--silent：安静模式。不显示进度表或错误信息。使curl静音。它仍然会输出您请求的数据，甚至可能输出到终端stdout，除非您对它进行重定向。
```



2.4.删除镜像

docker rmi -f 镜像id

docker rmi -f ${docker images -aq}

docker images -qa |grep - rmi


## FAQ

1. 安装完 docker 后，执行docker相关命令，出现：

    ```sh
    Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/json": dial unix /var/run/docker.sock: connect: permission denied
    ```

    原因： docker进程使用Unix Socket而不是TCP端口。而默认情况下，Unix socket属于root用户，需要root权限才能访问。

    - 解决方法1

        使用sudo获取管理员权限，运行docker命令（也可以直接使用root用户操作）；

    - 解决方法2

        docker守护进程启动的时候，会默认赋予名字为docker的用户组读写Unix socket的权限，因此只要创建docker用户组，并将当前用户加入到docker用户组中，那么当前用户就有权限访问Unix socket了，进而也就可以执行docker相关命令。操作如下：

        ```sh
        # 添加 docker用户组
        sudo groupadd docker
        # 将当前用户加入到docker用户组中（$USER表示当前用户，可以用 "echo $USER" 查看）
        sudo gpasswd -a $USER docker
        # 更新用户组
        newgrp docker
        # 测试docker命令是否可以使用sudo正常使用
        docker ps
        ```

</br>
</br>

Via

- <https://www.runoob.com/docker/docker-command-manual.html>
- <https://www.cnblogs.com/newAndHui/p/13508771.html>
- <https://huaweicloud.csdn.net/63311bd6d3efff3090b525b7.html>
- <https://blog.csdn.net/leilei1366615/article/details/106269231>
