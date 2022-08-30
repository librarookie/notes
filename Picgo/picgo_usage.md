# Picgo + Gitee 配置图床

</br>
</br>

## 背景

> 最近发现上传到GitHub的图片出现问题，导致之前的博客的图片都显示不了，然后上网查了下，应该是DNS的问题，网上也有很多这方面的处理方案，有兴趣的可以去网上找找。下面介绍下picgo工具以及使用Gitee做图床。

</br>

## picgo介绍

### 应用概述

> picgo是一款功能实用、操作简捷的图床工具，图床工具简单来说就是本地图片上传自动转换成链接的一款工具。

picgo 本体支持如下图床：

- 七牛图床 v1.0
- 腾讯云 COS v4\v5 版本 v1.1 & v1.5.0
- 又拍云 v1.2.0
- GitHub v1.5.0
- SM.MS V2 v2.3.0-beta.0
- 阿里云 OSS v1.6.0
- Imgur v1.6.0

Tips: 本体不再增加默认的图床支持。你可以自行开发第三方图床插件。

### 特色功能

1. 支持拖拽图片上传
2. 支持快捷键上传剪贴板里第一张图片
3. Windows 和 macOS 支持右键图片文件通过菜单上传 (v2.1.0+)
4. 上传图片后自动复制链接到剪贴板
5. 支持自定义复制到剪贴板的链接格式
6. 支持修改快捷键，默认快速上传快捷键：`command+shift+p`（macOS） | `control+shift+p`（Windows\Linux）
7. 支持插件系统，已有插件支持 Gitee、青云等第三方图床

Tips:

- 请确保你安装了 Node.js， 并且版本 >= 8。
- 默认上传图床为SM.MS。picgo上传之后，会自动将上传成功的URL复制到你的剪贴板，支持5种复制格式。
- Mini窗口只支持Windows（圆形）和Linux（方形），macOS可以使用顶部栏图标。（因为Windows和Linux的任务栏不支持拖拽事件）

### 插件版

- [vs-picgo](https://github.com/picgo/vs-picgo)：picgo 的 VS Code 版（前面的博客就是使用此插件配置GitHub图床的）。
- [flutter-picgo](https://github.com/picgo/flutter-picgo)：picgo 的手机版（支持 Android 和 iOS ）。

</br>

## 环境

### 准备

1. nodejs 环境
2. picgo 客户端
3. picgo 的Gitee上传插件
4. git、Gitee 账号和一个公开仓库

### 安装

#### 安装nodejs

- [nodejs中文官网](https://nodejs.org/zh-cn/download/)

    ![202208111500547](https://gitee.com/librarookie/picgo/raw/master/img/202208111500547.png "202208111500547")

    由于本人使用的是Ubuntu，所以下面介绍下Linux中安装nodejs（源码包需要编译再安装，而使用“二进制文件（x64）包”少这一步，所以我们使用后者）

    ```sh
    # 进入 “Downloads” 目录
    cd ~/Downloads

    # 下载nodejs
    wget -c https://nodejs.org/dist/v16.16.0/node-v16.16.0-linux-x64.tar.xz

    # 解包
    tar -xf node-v16.16.0-linux-x64.tar.xz

    # 配置软连接
    sudo ln -s ~/Downloads/node-v16.16.0-linux/bin/npm /usr/lcal/bin/
    sudo ln -s ~/Downloads/node-v16.16.0-linux/bin/npx /usr/lcal/bin/
    sudo ln -s ~/Downloads/node-v16.16.0-linux/bin/node /usr/lcal/bin/

    ## 由于 nodejs 只是在安装 picgo 和安装 picgo插件 时需要， 后续picgo使用不需要。
    ## 所以本来不需要 nodejs 环境的博友可以和我一样，安装完 picgo客户端 和picgo插件 后就删了

    # 验证
    在终端中输入：
    npm -v
    npx -v
    node -v
    ```

    ![202208111557281](https://gitee.com/librarookie/picgo/raw/master/img/202208111557281.png "202208111557281")

#### 安装 picgo 客户端

- [picgo仓库地址](https://github.com/Molunerfinn/picgo/releases)
- [picgo-2.3.0，目前的最后一个稳定版本](https://github.com/Molunerfinn/picgo/releases/tag/v2.3.0)

    ![202208120958783](https://gitee.com/librarookie/picgo/raw/master/img/202208120958783.png "202208120958783")

下面介绍下Linux版本 picgo的安装与配置

- 下载

    ```sh
    wget -c https://github.com/Molunerfinn/picgo/releases/download/v2.3.0/picgo-2.3.0.AppImage
    ```

- 安装

    由于是 AppImage 文件（类似Windows下的 EXE文件）， 所以授权后直接执行即可运行。

    为方便使用，我们可以将 AppImage 文件放入 `系统变量PATH` 中，如下：

    1. 授权

        ```sh
        sudo chmod u+x picgo-2.3.0.AppImage
        ```

    2. 查看系统变量 PATH

        ```sh
        echo $PATH
        ```

       ![202208121434670](https://gitee.com/librarookie/picgo/raw/master/img/202208121434670.png "202208121434670")

    3. 移动到 PATH

        ```sh
        # 如上图所示，我们选用 “/usr/local/bin/” 
        sudo mv ~/Downloads/picgo-2.3.0.AppImage /usr/local/bin/
        ```

    4. 制作 desktop entry 图标（可选）

        - 参考文章：[用 AppImage文件创建快捷图标和软连接](https://www.cnblogs.com/librarookie/p/15127991.html "用 AppImage文件创建快捷图标和软连接")

        打开后差不多长这样:

        ![202208121653118](https://gitee.com/librarookie/picgo/raw/master/img/202208121653118.png "202208121653118")

### 配置

#### 下载并安装Git

- [Git官网下载页](https://git-scm.com/downloads) 按照自己的系统版本下载，然后安装即可。

    ![202208121540746](https://gitee.com/librarookie/picgo/raw/master/img/202208121540746.png "202208121540746")

#### 注册/登录Gitee账号

- [Gitee首页](https://gitee.com) 按照要求自行注册即可。登录后如下：

    ![202208121549790](https://gitee.com/librarookie/picgo/raw/master/img/202208121549790.png "202208121549790")

#### 创建一个Gitee 公开仓库

> 创建公开仓库的原因是让别人可以浏览你的图片，否则别人没有浏览图片的权限。

1. 创建一个仓库，作为图床
    - 按照提示填写信息即可。仓库名随便取，如： picgo

        ![202208121614029](https://gitee.com/librarookie/picgo/raw/master/img/202208121614029.png "202208121614029")

2. 将仓库配置为“开源”
    - 由于创建仓库的时候只能选择 “私有” 仓库，所以此步配置 “开源” 操作如下：
    - 进入仓库 -> 基本信息 -> 拉到最下面 -> 选择 “开源” 并勾上所有条约 -> 点击 “保存”

        ![202208121622302](https://gitee.com/librarookie/picgo/raw/master/img/202208121622302.png "202208121622302")

3. 生成 Token

    > Token用于picgo操作Gitee repository，生成Token操作如下：</br>
    > 快捷进入： <https://gitee.com/profile/personal_access_tokens/new>

    或者根据下列步骤进入：

    - 点击头像 -> 设置 -> 私人令牌 -> 生成新令牌 -> 只勾上 “projects” 权限 -> 提交， 如图所示：

        ![202208121648087](https://gitee.com/librarookie/picgo/raw/master/img/202208121648087.png "202208121648087")

    - 保存 Token 串

    Tips： 创建成功后，会生成一串token，这串token之后不会再显示，所以第一次看到的时候，就要好好保存。

#### 配置picgo

1. 安装 Gitee 上传插件

    > 因为官方默认不支持gitee图床，所以需要单独下载插件（安装插件需要 `nodejs` 环境）

    启动 picgo -> 进入“插件设置” -> 搜索 “gitee” -> 点击插件图片的“安装”即可，本文使用 `gitee-uploader` 插件来进行演示，其他插件自行测试

    ![202208121703315](https://gitee.com/librarookie/picgo/raw/master/img/202208121703315.png "202208121703315")

    Tips： 插件装完后，重启生效

2. 配置 Gitee 插件

    进入“图床设置” -> gitee， 依次填入相关配置如下所示，填写如下：

    - `*repo`： 用户名/仓库名（必填）
    - `branch`: 分支名（默认: master）
    - `*token`: 私人令牌（必填）
    - `path`: 上传路径，仓库里的图片保存路径
    - `customPath`: 定制路径
    - `customUrl`: 图片定制URL

        ![202208121705053](https://gitee.com/librarookie/picgo/raw/master/img/202208121705053.png "202208121705053")

3. 其他配置（可选）

    > 下面的配置都是可选，大家可以根据自己的使用习惯来。

    - 快捷键配置

        默认是 `Ctrl+shift+p`，有自己习惯的，或者快捷键冲突可以在此修改

    - 自定义链路格式

        picgo 预设的链接格式有以下几种：

        ```md
        - Markdown: ![](https://gitee.com/librarookie/picgo/raw/master/img/202208051649953.png)
        - HTML: <img src="https://gitee.com/librarookie/picgo/raw/master/img/202208051649953.png"/>
        - URL: https://gitee.com/librarookie/picgo/raw/master/img/202208051649953.png
        - UBB: [IMG]https://gitee.com/librarookie/picgo/raw/master/img/202208051649953.png[/IMG]
        - Custom: 此选项就是使用本项配置的自定义格式
        ```

        默认格式： $url ，即上传后复制的URL为： <https://gitee.com/librarookie/picgo/raw/master/img/202208051649953.png>

        由于本人是用来做 Markdown文章的图床，而Markdown预设的链接格式中没有文件名，vscode 的 `Markdown All in One` 会编译警告

        故使用自定义链路格式，格式配置： `![$fileName]($url "$fileName")`

        - `$url`: 表示文件名的占位符
        - `$fileName`: 表示 URL 的占位符

            ![202208121751148](https://gitee.com/librarookie/picgo/raw/master/img/202208121751148.png "202208121751148")

            修改后的自定义链路格式效果： `![202208051649953](https://gitee.com/librarookie/picgo/raw/master/img/202208051649953.png "202208051649953")`

        - Tips:  配置好 `自定义链路格式` 后别忘了去 “上传区” 中的链路格式选上 `Custom` 来使用

            ![202208121755102](https://gitee.com/librarookie/picgo/raw/master/img/202208121755102.png "202208121755102")

    - 开机自启

    - 时间戳重命名

        开启效果： 上传图片文件名会自动改成上传时的时间戳

    - 开启上传提示

    - 上传后自动复制URL

        开启效果： 上传完制自动复制图片URL，直接粘贴即可

    - 选择显示的图床

        默认是 “图床设置” 下显示所有图床的，由于我只准备用 `gitee` 图床，故将其他的图床都取消了
        效果： 图床设置下只显示 `gitee` 图床

</br>

## 测试

### 上传测试

1. 上传图片

    常用方式：
    - 将图片拖动到 “上传区” 里，或者拖动到 “mini窗口” 中
    - 快捷键： `Ctrl+shift+p`。复制图片或者截图，然后使用快捷键上传；

2. 测试URL

    在浏览器地址栏粘粘U，查看是否显示URL，如：
    <https://gitee.com/librarookie/picgo/raw/master/img/202208051649953.png>

</br>****

## FAQ

### xclip no found

- 如果你和我一样是Ubuntu系统，那你上传可能会遇到这个错误 `xclip no found`.
- 之所以上传失败，是因为需要先将图片复制到剪切板中，而这借助了 `xclip`

    ```sh
    # 安装xclip
    sudo apt install xclip
    ```

### 转移GitHub图床上的图片到 Gitee图床

> 如果博友和我一样是从 GitHub图床 转到 gitee图床的，那以前的GitHub上面的图片可以通过下面的方法转移并使用

1. 获取 GitHub图床库的URL

    1. 进入 GitHub图床库，如：librarookie/picgo
    2. 依次点击仓库首页的 `Code -> https -> 复制`， 复制内容如： <https://github.com/librarookie/picgo.git>

        ![202208160923995](https://gitee.com/librarookie/picgo/raw/master/img/202208160923995.png "202208160923995")

2. 同步图床数据

    - 同步 GitHub 中的图床库到 Gitee 图床库，步骤如下：

        `仓库设置 -功能设置 -同步 -仓库远程地址（用于强制同步）`, 然后将 GitHub仓库URL填入，保存

        ![202208160916507](https://gitee.com/librarookie/picgo/raw/master/img/202208160916507.png "202208160916507")

3. 更新文章中的图片URL

    1. 打开文章，搜索 GitHub图床图片

        GitHub图床图片URL格式前面部分都是一样的，由于之前我上传的时候配置了jsDelivr 加速访问：

        所以图片URL类似： <https://cdn.jsdelivr.net/gh/GitHub用户名/图床仓库名/二级文件夹/图片名称>

        如下所示：

        ```md
        https://cdn.jsdelivr.net/gh/librarookie/picgo/images/baidu.png
        ```

    2. 替换图片URL

        由于浏览器无法替换，故将博文复制到本地文本编辑器中，并将图片URL替换为 Gitee图床图片URL

        URL格式： <https://gitee.com/Gitee用户名/图床仓库名/raw/分支名/二级文件夹/图片名称>

        如下所示：

        ```md
        # 图片baidu.png
        https://cdn.jsdelivr.net/gh/librarookie/picgo/images/baidu.png  ->   https://gitee.com/librarookie/picgo/raw/main/images/baidu.png
        ```

    3. 批量替换（Linux）

        > 如果你也像我一样，文章在本地有备份（本地文章目录 `$BLOG_HOME/`） ，又刚好使用的 Linux 系统，那下面操作能帮你节省一些时间

        1. 查找（grep）

            ```sh
            # 用法
            grep -rn "目标字符串" ./

            # 栗子
            grep -rn "https://cdn.jsdelivr.net/gh/librarookie/picgo/images" $BLOG_HOME/
            ```

        2. 替换

            ```sh
            # 用法
            sed -i "s/目标字符串/替换字符串/g" `grep -rl 目标字符串 ./`

            # 栗子
            sed -i "s#https://cdn.jsdelivr.net/gh/librarookie/picgo/images#https://gitee.com/librarookie/picgo/raw/main/images#g" `grep -rl https://cdn.jsdelivr.net/gh/librarookie/picgo/images $BLOG_HOME/`
            ```

        参数解释：
          - grep:
              - `r` : 搜索子目录，即当前./下的所有子目录
              - `n` : 打印行号
              - `l` : 查找到匹配字符串的文件名 （注意， 是含有匹配字符串的文件,也就是含有原文本的文件）
          - sed:
              - `i` : 直接修改文件内容
              - `#` : 由于替换串中带 `/` ，所以使用 `#` 代替 `/` ，（也可以使用其他的符号代替）

    Tips:
    - 由于图片是从 GitHub仓库同步过来的的，所以Gitee仓库中的图片URL中的 `分支名` 和 `二级文件夹` 和 GitHub仓库一致；
    - Gitee仓库必须是开源仓库，不然其他网站的图片显示不了；
    - 图片的扩展名好像有影响，推荐使用png格式进行上传测试；

4. 验证图片

    可以将图片放到其他平台查看即可（个人观点：将图片URL放置到浏览器的无痕模式中访问即可）

</br>
</br>

Via

- <https://picgo.github.io/picgo-Doc/zh/guide/>
