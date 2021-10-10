# 生成&添加 SSH公钥

## 生成

1. 打开 Terminal（终端）

2. 生成命令

    ```python
    ssh-keygen -t ed25519 -C "your_email@example.com"
    ```

    note：如果您使用的是不支持 Ed25519 算法的旧系统，请使用 RSA，感兴趣的可以点击[Ed25519和 RSA详情入口](https://www.cnblogs.com/cure/p/15389876.html "RSA，DSA，ECDSA，EdDSA和Ed25519的区别")了解；

    * 参数解释：
      * -t： 指定使用的数字签名算法；
      * -C: 注释，随便填；
      * -f: 指定文件输出位置，可选默认为 ~/.ssh/

    * 输出日志（三次回车）

    ```python
    Generating public/private ed25519 key pair.
    Enter file in which to save the key (/home/noname/.ssh/id_ed25519):     # 按回车键, 接受默认文件位置
    Enter passphrase (empty for no passphrase): # 按回车键, 设置空密码
    Enter same passphrase again:    # 按回车键
    Your identification has been saved in /home/noname/.ssh/id_ed25519
    Your public key has been saved in /home/noname/.ssh/id_ed25519.pub
    The key fingerprint is:
    SHA256:3tUVjse1MusYmzxShrReusMp2Rdd2NSTGSi3dBOujHA librarookie
    The key's randomart image is:
    +--[ED25519 256]--+
    |              .+B|
    |           . +=B=|
    |         o E++**+|
    |        . = o+*+ |
    |        So *o+o  |
    |       ...*o*.   |
    |        =+o*..   |
    |       o =o..    |
    |        ..o      |
    +----[SHA256]-----+
    ```

3. 查看生成的 public key

    * 查看公钥

        ```python
        # 不出意外，~/.ssh/目录下应该有了 id_ed25519和 id_ed25519.pub

        # 我们打开 id_ed25519.pub
            cat ~/.ssh/id_ed25519.pub
        
        # 然后就可以看到公钥内容了（一串字符串）
        ```

    * 添加识别 SSH keys 新的私钥（可选，没识别到执行此步）

        ```python
        ssh-agent bash
        ssh-add ~/.ssh/id_ed25519
        ```

        note: 默认只读取 id_rsa，为了让 SSH 识别新的私钥，需要将新的私钥加入到 ssh-agent 中

## 添加

1. 进入 SSH公钥管理
    * Gitee公钥管理页面： <https://gitee.com/profile/sshkeys>
    * GitHub公钥管理页面： <https://github.com/settings/keys>

2. 填写标题和公钥（id_ed25519.pub内容）

3. 输入密码

## 验证

打开Git Bash并输入

* 验证命令

    ```python
    ssh -T git@github.com   # github
    ssh -T git@gitee.com    # gitee
    ```

* 成功输出

    ```python
        # GitHub
    You've successfully authenticated, but GitHub does not provide shell access.

        # Gitee
    You've successfully authenticated, but GITEE.COM does not provide shell access. 
    ```
