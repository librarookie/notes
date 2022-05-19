# 用 AppImage文件创建快捷图标和软连接

</br>
</br>

## 背景

```md
AppImage是一种可执行文件格式，类似于Windows的exe文件，macOS的app文件，一个文件即一个应用程序，不过AppImage是运行在Linux上的可执行文件，而且是可以运行在不同发行版本的Linux，如Ubuntu, Debian, openSUSE, RHEL, CentOS, Fedora, Arch Linux ...
```

## 使用

### 直接使用

1. 打开一个终端(terminal)
2. 进入AppImage文件目录
3. 授权，给与AppImage文件执行权限
4. 运行AppImage文件

    ```md
    cd /path/to/AppImage
    chmod +x my.AppImage
    ./my.AppImage
    ```

### 快捷图标（Desktop Entry）

> 总是需要通过终端来运行AppImage不免有限麻烦，此时我们可以创建Desktop Entry，集成到桌面的程序目录里。

1. Desktop Entries目录

    ```md
    /usr/share/applications/
    /usr/local/share/applications/
    ~/.local/share/applications/
    ```

2. 创建 Desktop文件（本文以 `navicat15-premium.AppImage`为例）

    ```md
    touch navicat.desktop
    ```

3. 配置 Desktop文件
  
    - 说明

    ```md
    # 文件头
    [Desktop Entry]

    # 类型
    Type=Application

    # 桌面条目规范的版本（可选）
    Version=1.0

    # 应用程序的名称
    Name=Navicat Premium 15

    # 通用名称（可选）
    GenericName=Database Development Tool

    # 应用程序的注释/备注（可选）
    Comment=The best database tools

    # 该应用程序的可执行文件，可带参数
    Exec=/usr/local/src/appImage/navicat15-premium.AppImage

    # 将用于显示此条目的图标图片位置
    Icon=/usr/local/src/appImage/icon/navicat-icon.png

    # 描述这个应用程序是否需要在终端中运行（可选）
    Terminal=false

    # 描述此条目应在哪些类别中显示（可选）
    Categories=Education;Development;Java;

    # 关键词（可选，可做关键词搜索该图标）
    Keywords=database;sql;    
    ```

    - 栗子

    ```md
    [Desktop Entry]

    Type=Application

    Name=Navicat Premium 15

    GenericName=Database Development Tool

    Icon=/usr/local/src/appImage/icon/navicat-icon.png

    Exec=/usr/local/src/appImage/navicat15-premium.AppImage

    Categories=Development;

    Keywords=database;sql;
    ```

4. 使用图标

    - 将图标加入程序塢

        ```md
        # 将 Desktop文件放入 Desktop Entries目录即可
        cp ./navicat.desktop ~/.local/share/applications/
        ```

    - 将图标加入桌面

        ```md
        # 将 Desktop文件放入 桌面目录即可
        mv navicat.desktop ~/Desktop/
        ```

    - 将程序加入侧边栏

        ```md
        选中图标 -> 点击鼠标右键 -> Add to Favorites
        ```

        ![1](https://img2020.cnblogs.com/blog/1957451/202108/1957451-20210811140954717-1942751987.png)

### 软连接

- 查看执行目录

    ```md
    echo $PATH
    ```

    ![2](https://img2020.cnblogs.com/blog/1957451/202108/1957451-20210811140814977-749329264.png)

- 建立软连接
  - 说明

    ```md
    Usage: ln [OPTION]... TARGET DIRECTORY
      OPTION   # 可选参数，建立软连接时需加上 `-s`
      TARGET   # 源文件或目录
      DIRECTORY   # 目标文件或目录

    # 常用参数
    -b 删除，覆盖以前建立的链接
    -d 允许超级用户制作目录的硬链接
    -f 强制执行
    -i 交互模式，文件存在则提示用户是否覆盖
    -n 把符号链接视为一般目录
    -s 软链接(符号链接)
    -v 显示详细的处理过程
    ```

  - 栗子

    ```md
    ls -s /usr/local/src/appImage/navicat15-premium.AppImage /usr/local/bin/navicat
    ```

## FUSE 问题

> 第一次执行AppImage文件的时候可能会碰到 `PUSE` 相关的问题，报错如下：

```md
dlopen(): error loading libfuse.so.2

AppImages require FUSE to run.
You might still be able to extract the contents of this AppImage
if you run it with the --appimage-extract option.
See https://github.com/AppImage/AppImageKit/wiki/FUSE
for more information
```

- 解决方案：
  - 安装fuse2 `sudo apt install fuse`

</br>
</br>
