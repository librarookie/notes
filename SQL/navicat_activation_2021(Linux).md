# Navicat 激活教程2021（Linux）

</br>
</br>

## 背景

> Navicat 是香港卓软数字科技有限公司生产的一系列 MySQL、MariaDB、MongoDB、Oracle、SQLite、PostgreSQL 及 Microsoft SQL Server 的图形化数据库管理及发展软件。它有一个类似浏览器的图形用户界面，支持多重连线到本地和远程数据库。它的设计合乎各种用户的需求，从数据库管理员和程序员，到各种为客户服务并与合作伙伴共享信息的不同企业或公司。 –Wikipedia

</br>

## 环境

1. 环境清单

    - Navicat包，[官网传送阵](https://www.navicat.com.cn/download/navicat-premium "点击进入Navicat官网")

    - Navicat-Keygen工具(依赖下面三个库)
        - capstone
        - keystone (需要cmake)
        - rapidjson

    - AppImage打包工具

2. 环境准备
    - Navicat 包下载[百度网盘(navicat premium-15.0.23)](https://pan.baidu.com/s/1iSD7bZSH6jCR6YRyN93EUw "提取码: mt9v")
     Note: 官网最新版激活失败，可以使用这个旧版本（小编激活官网最新版的时候，卡在激活的第2 步）

    - 准备Navicat-Keygen的编译环境
        1. capstone

            ```python
            sudo apt install libcapstone-dev
            ```

        2. keystone

            ```python
            # 安装编译工具cmake
            sudo apt install cmake
            # 获取keystone源码并编译安装
            cd /home/
            git clone https://github.com/keystone-engine/keystone.git

            cd keystone
            # 创建一个build目录用于存放keystone编译后的库文件
            mkdir build

            cd build

            ../make-share.sh
            # 安装keystone动态库
            sudo make install
            # 执行dconfig动态链接库为系统所共享
            sudo ldconfig
            ```

        3. rapidjson

            ```python
            sudo apt install rapidjson-dev
            ```

    - 编译安装Navicat-Keygen

        ```Python
        # 下载
        cd /home/
        git clone -b linux --single-branch https://github.com/Orginly/navicat-keygen.git

        cd navicat-keygen
        
        make all
        # 授权navicat-pacher 和navicat-keygen
        sudo chmod a+x bin/*
        ```

        Note: 如果`make all` 的时候，提示fatal error: openssl/opensslv.h: 没有那个文件或目录，此时请执行`sudo apt-get install libssl-dev`就可以了

    - 下载AppImage打包工具并授权

        ```Python
        # 下载
        cd /home/
        wget 'https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage'
        # 授权
        sudo chmod a+x appimagetool-x86_64.AppImage
        ```

</br>

## 激活

1. 提取AppImage文件

    ```python
    # 将navicat15-premium-cs.AppImage 移动到 /home/目录下,进入AppImage目录下，打开终端并执行
    mv navicat15-premium-cs.AppImage /home/

    mkdir navicat15-premium-cs

    sudo mount -o loop navicat15-premium-cs.AppImage navicat15-premium-cs

    sudo cp -r navicat15-premium-cs navicat15

    sudo umount navicat15-premium-cs

    rm -rf navicat15-premium-cs
    ```

2. navicat-patcher 替换官方公钥

    ```python
    # 进入navicat-keygen/bin/目录
    cd /home/navicat-keygen/bin/
    # 执行
    sudo ./navicat-patcher /home/navicat15
    ```

    - 样式输出

        ```python

        **********************************************************
        *       Navicat Patcher (Linux) by @DoubleLabyrinth      *
        *                  Version: 1.0                          *
        **********************************************************

        Press ENTER to continue or Ctrl + C to abort.

        [+] Try to open libcc.so ... Ok!

        [+] PatchSolution0 ...... Ready to apply
            RefSegment      =  1
            MachineCodeRva  =  0x0000000001377200
            PatchMarkOffset = +0x000000000292c840

        [*] Generating new RSA private key, it may take a long time...
        [*] Your RSA private key:
            -----BEGIN RSA PRIVATE KEY-----
            MIIEowIBAAKCAQEAta5uHinxzLei/iSOBu/Nf8y3X/BuGpmFcxacQIKb60amSHL4
            vg0RaoWs3f04PapKSX+uGeWjhOzWX9UxRXj2xi1FeNgIKDa9+1cLKIvrOVlTlrpx
            irXbOvGkF+uOd2mbEd11LgLwbnTKNoqWZuPHPh3hgUWF+fZ6/7rLuWrh+8K/OlHU
            hOjgKZWoGxO7dXQhDav+iDxW7ab/s5B5/OJcwv+IvI3ZakL12C2fNKYcLtkonCTl

        ...
        ...
        ...


        [*] New RSA-2048 private key has been saved to
            /home/navicat-keygen/bin/RegPrivateKey.pem

        *******************************************************
        *           PATCH HAS BEEN DONE SUCCESSFULLY!         *
        *                  HAVE FUN AND ENJOY~                *
        *******************************************************


        ```

3. 将navicat15 打包

    ```python
    cd /home/

    ./appimagetool-x86_64.AppImage navicat15 navicat15.AppImage
    ```

4. 运行刚打包的navicat15.AppImage

    ```python
    ./navicat15.AppImage
    ```

5. 使用 navicat-keygen 来生成 **序列号** 和 **激活码**

    1. 执行navicat-keygen

        ```python
        cd /home/navicat-keygen/bin/

        ./navicat-keygen --text ./RegPrivateKey.pem
        ```

        - 你会被要求选择Navicat产品类别、Navicat语言版本和填写主版本号。之后一个随机生成的 **序列号** 将会给出

        ![202208241641583](https://gitee.com/librarookie/picgo/raw/master/img/202208241641583.png "202208241641583")

        ```python

        **********************************************************
        *       Navicat Keygen (Linux) by @DoubleLabyrinth       *
        *                   Version: 1.0                         *
        **********************************************************

        [*] Select Navicat product:
        0. DataModeler
        1. Premium
        2. MySQL
        3. PostgreSQL
        4. Oracle
        5. SQLServer
        6. SQLite
        7. MariaDB
        8. MongoDB
        9. ReportViewer

        (Input index)> 1

        [*] Select product language:
        0. English
        1. Simplified Chinese
        2. Traditional Chinese
        3. Japanese
        4. Polish
        5. Spanish
        6. French
        7. German
        8. Korean
        9. Russian
        10. Portuguese

        (Input index)> 0

        [*] Input major version number:
        (range: 0 ~ 15, default: 12)> 15

        [*] Serial number:
        NAVM-RTVJ-EO42-IODD
        ```

    2. 使用这个 **序列号(Serial number)** 来暂时激活Navicat。

        - 之后你会被要求填写 **用户名** 和 **组织名**, 你可以随意填写，但别太长。

        ```python
        [*] Your name: LIBRA
        [*] Your organization: ROOKIE
        ```

        - 之后你会被要求填写请求码。**注意不要关闭keygen**。

    3. **断开网络**. 找到navicat注册窗口，填写keygen给你的 **序列号**，然后点击 **激活**，再点击 **手动激活**。(通常在线激活会失败，所以在弹出的提示中选择手动激活)

    4. 复制 **请求码** 到keygen，连按两次回车结束。

        ```python
        [*] Input request code in Base64: (Double press ENTER to end)
        OaGPC3MNjJ/pINbajFzLRkrV2OaSXYLr2tNLDW0fIthPOJQFXr84OOroCY1XN8R2xl2j7epZ182PL6q+BRaSC6hnHev/cZwhq/4LFNcLu0T0D/QUhEEBJl4QzFr8TlFSYI1qhWGLIxkGZggA8vMLMb/sLHYn9QebBigvleP9dNCS4sO82bilFrKFUtq3ch8r7V3mbcbXJCfLhXgrHRvT2FV/s1BFuZzuWZUujxlp37U6Y2PFD8fQgsgBUwrxYbF0XxnXKbCmvtgh2yaB3w9YnQLoDiipKp7io1IxEFMYHCpjmfTGk4WU01mSbdi2OS/wm9pq2Y62xvwawsq1WQJoMg==

        [*] Request Info:
        {"K":"NAVMRTVJEO42IODD", "DI":"4A12F84C6A088104D23E", "P":"linux"}

        [*] Response Info:
        {"K":"NAVMRTVJEO42IODD","DI":"4A12F84C6A088104D23E","N":"DoubleLabyrinth","O":"DoubleLabyrinth","T":1575543648}

        [*] Activation Code:
        i45HIr7T1g69Cm9g3bN1DBpM/Zio8idBw3LOFGXFQjXj0nPfy9yRGuxaUBQkWXSOWa5EAv7S9Z1sljlkZP6cKdfDGYsBb/4N1W5Oj1qogzNtRo5LGwKe9Re3zPY3SO8RXACfpNaKjdjpoOQa9GjQ/igDVH8r1k+Oc7nEnRPZBm0w9aJIM9kS42lbjynVuOJMZIotZbk1NloCodNyRQw3vEEP7kq6bRZsQFp2qF/mr+hIPH8lo/WF3hh+2NivdrzmrKKhPnoqSgSsEttL9a6ueGOP7Io3j2lAFqb9hEj1uC3tPRpYcBpTZX7GAloAENSasFwMdBIdszifDrRW42wzXw==
        ```

    5. 将生成的 **激活码(Activation Code)** 粘贴到navicat激活即可

        ![202208241647815](https://gitee.com/librarookie/picgo/raw/master/img/202208241647815.png "202208241647815")
        ![202208241647222](https://gitee.com/librarookie/picgo/raw/master/img/202208241647222.png "202208241647222")

</br>

## 清理

```python
cd /home/
# 删除挂载目录
sudo rm -rf navicat15-premium-cs
# 删除源包
sudo rm -rf navicat15-premium-cs.AppImage
# 删除复制的目录
sudo rm -rf navicat15
# 删除激活工具
sudo rm -rf navicat-keygen
# 删除AppImage打包工具
sudo rm -rf appimagetool-x86_64.AppImage

```

</br>

## 使用

- 方式一、默认启动方式

    ```python
    1. 先进入 AppImage文件目录
    2. 再执行 AppImage文件
    ```

- 方式二、给`AppImage`文件创建软件连接
- 方式三、给`AppImage`文件创建图标
  
  由于默认启动需要进入AppImage目录，启动比较繁琐，所以推荐给AppImage文件创建`软连接`和`图标`，创建方法参考：
    <https://www.cnblogs.com/librarookie/p/15127991.html>

note:

> 运行快捷键： `Ctrl + r`

</br>
</br>

Ref

- <https://github.com/orginly/navicat-keygen#readme>
- <https://zhuanlan.zhihu.com/p/372997917>
- <https://www.bilibili.com/read/cv6547509>
