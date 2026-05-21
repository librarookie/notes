# VScode + PicGo + Github + jsDelivr 搭建稳定快速高效图床

</br>
</br>

## 前言

> 所谓图床，就是将图片储存到第三方静态资源库中，其返回给你一个 URL 进行获取图片。Markdown 支持使用 URL 的方式显示图片

    * 使用Typora这款markdown编辑器时，导入的图片是本地链接，在进行资源共享时，就会出现图片无法显示问题，为了将相对路径转为绝对路径，就必须要使用对象存储的功能。
    * 使用VScode上写Markdown博客，也是非常方便，不过vscode需要自己搭建图床，但是只要你使用了vscode插件picgo，然后花10分钟配置一下github免费图床，就可以用快捷键快速插入图片了

</br>

## 准备

1. VScode 工具
    * [官网下载](https://code.visualstudio.com/Download "https://code.visualstudio.com/Download")
    * [VScode扩展官网](https://marketplace.visualstudio.com/VSCode "https://marketplace.visualstudio.com/VSCode")

2. PicGo （默认是sm-ms图床，测试无效）
    * Picgo-vscode插件: `PicGo`

3. 图床选择： `GitHub图床`
    * `微博图床`：以前用的人比较多，从 2019 年 4 月开始开启了防盗链，凉凉
    * `SM.MS`：运营四年多了，也变得越来越慢了，到了晚上直接打不开图片，速度堪忧
    * `其他小众图床`：随时有挂掉的风险
    * `大厂储存服务`：例如七牛云、又拍云、腾讯云COS、阿里云OSS等，操作繁琐，又是实名认证又是域名备案的，麻烦，而且还要花钱（有钱又不怕麻烦的当我没说）
    * `Imgur 等国外图床`：国内访问速度太慢，随时有被墙的风险
    * `GitHub 图床`：免费，但是国内访问速度慢（不过没关系，利用 jsDelivr 提供的免费的 CDN 加速 速度足够了）

4. jsDelivr CDN 加速 （jsDelivr 是一个免费开源的 CDN 加速服务）

</br>

## 配置

### 新建 GitHub 仓库

* 登录/注册 [GitHub](https://github.com "https://github.com")

* 新建一个仓库，填写好仓库名

* 仓库描述（可选）

* 将权限设置成 `public` 或 `private`

* 根据需求选择是否为仓库初始化一个 README.md 描述文件

### 生成一个 Token

* 点击用户头像 -> 选择 Settings

    ![20211026152844](https://gitee.com/librarookie/picgo/raw/main/images/20211026152844.png)

* 点击 Developer settings

    ![20211026152924](https://gitee.com/librarookie/picgo/raw/main/images/20211026152924.png)

* 点击 Personal access tokens

    ![20211026153043](https://gitee.com/librarookie/picgo/raw/main/images/20211026153043.png)

* 点击 Generate new token

    ![20211026153113](https://gitee.com/librarookie/picgo/raw/main/images/20211026153113.png)

* 填写 Token 描述，勾选 repo，然后点击 Generate token 生成一个 Token

    ![20211026153150](https://gitee.com/librarookie/picgo/raw/main/images/20211026153150.png)

    ![20211026153213](https://gitee.com/librarookie/picgo/raw/main/images/20211026153213.png)

* 获取 Token 密钥

    ![20211026153251](https://gitee.com/librarookie/picgo/raw/main/images/20211026153251.png)

*note:* 注意这个 Token 只会显示一次，自己先保存下来，或者等后面配置好 PicGo 后再关闭此网页

### 配置 PicGo 并使用 jsdelivr 作为 CDN 加速

* 在vscode上安装`Picgo插件`， 或者前往下载 [PicGo客户端（点击下载）](https://github.com/Molunerfinn/PicGo "https://github.com/Molunerfinn/PicGo")，安装好后开始配置图床（插件和客户端的配置差不多，这里示范vscode插件）

    ![20211026154813](https://gitee.com/librarookie/picgo/raw/main/images/20211026154813.png)
* 配置`PicGo`

  * 设定仓库名（Repo）：按照 `用户名/图床仓库名` 的格式填写

  * 设定分支名（Branch）：`main`

  * 设定 Token：粘贴之前生成的 Token

  * 指定存储路径（Path）：填写想要储存的路径，如`image/`，所有通过插件上传的图片都在图床仓库中的`image`文件夹下（后面的`/`必须加上，不然image就是上传后的图片名前缀）

  * 设定自定义域名（Custom Url）：它的的作用是，在图片上传后，PicGo 会按照自定义域名 上传的图片名的方式生成访问链接，放到粘贴板上，因为我们要使用 jsDelivr 加速访问，所以可以设置为：

    <https://cdn.jsdelivr.net/gh/用户名/图床仓库名>

  * 官网指南：[Picgo官方使用指导](https://picgo.github.io/PicGo-Doc/zh/guide/config.html#github%E5%9B%BE%E5%BA%8A "Github图床配置手册")

    ![20211026155522](https://gitee.com/librarookie/picgo/raw/main/images/20211026155522.png)

### 上传图片到 PicGo 并使用图床

![20211026163429](https://gitee.com/librarookie/picgo/raw/main/images/20211026163429.png)

* 配置好 PicGo 后，配合`Picgo插件`快捷键使用

    | Key | Value |
    | :--: | :--: |
    |Uploading an image from clipboard </br> 从剪贴板上传图像|`Ctrl + Alt + U`|
    |Uploading images from explorer </br> 从资源管理器上传图像|`Ctrl + Alt + E`|
    |Uploading an image from input box </br> 从输入框上传图像|`Ctrl + Alt + O`|

* 此外 PicGo客户端 还有相册功能，可以对已上传的图片进行删除，修改链接等快捷操作，PicGo 还可以生成不同格式的链接、支持批量上传、快捷键上传、自定义链接格式、上传前重命名等，更多功能自己去探索吧！

*note:* 如果你和我一样是Ubuntu系统，那你上传可能会遇到这个错误`xclip no found`, 之所以上传失败， 是因为需要先将图片复制到剪切板中。而这借助了xclip

    > sudo apt install xclip  安装xclip

</br>

## 验证

如果你配置了`jsDelivr` 加速访问，上传成功后，你会发现图片都显现不了，按照 jsDelivr官方访问格式可以看出，使用jsDelivr访问是需要GitHub发布一个版本的，所以我们需要在将图床仓库发布一个版本，然后才能访问。官方推荐访问格式如下：

    > https://cdn.jsdelivr.net/gh/user/repo@version/file

* 下面是三种可访问的方式
  * <https://cdn.jsdelivr.net/gh/librarookie/picgo@v1.0.1/images/baidu.png>
  * <https://cdn.jsdelivr.net/gh/librarookie/picgo@latest/images/baidu.png>
  * <https://cdn.jsdelivr.net/gh/librarookie/picgo/images/baidu.png>

</br>
</br>

Via

* <https://www.jsdelivr.com/?docs=gh>
* <https://picgo.github.io/PicGo-Doc/zh/guide/config.html#github%E5%9B%BE%E5%BA%8A>
* <https://www.daimajiaoliu.com/daima/4870d078e900405>
* <https://zhuanlan.zhihu.com/p/131584831>
