# Linux 配置免密登录

</br>
</br>

## 实例

1. 生成公钥和私钥

    > ssh-keygen -t rsa

    Tips: 执行后会在`~/.ssh/`目录下创建 `id_rsa` 和 `id_rsa.pub` 文件

2. 生成省份认证文件

    > ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.0.18

    Tips: 三次回车; 作用是将本地公钥填充到一个远程主机192.168.0.18的 `authorized_keys` 文件中（远程主机没有该文件时会自动创建）

3. SSH 连接验证

    > ssh root@192.168.0.18

    Tips:
    - 此时 SSH 连接就不用再输入密码了；
    - 需要配置哪台主机免密，只需要执行 `ssh-copy-id` 即可; CentOS_6 支持将远程主机的 `authorized_keys` 文件拷贝到需要免密的主机中（比如：A主机免密到B主机后，A主机还需要免密到C主机，那我们可以把B主机的 `authorized_keys` 文件拷贝到C主机中即可）

</br>

## SSH 协议

> SSH 为 Secure Shell 的缩写，由 IETF 的网络小组（Network Working Group）所制定；SSH 为建立在应用层基础上的安全协议。SSH 是目前较可靠，专为远程登录会话和其他网络服务提供安全性的协议。利用 SSH 协议可以有效防止远程管理过程中的信息泄露问题。简单来说ssh是一种加密的用于远程登录的协议。

更多SSH协议内容移步：[SSH协议（从对称加密到非对称加密）](https://blog.csdn.net/qq_41036232/article/details/102828564 "SSH协议（从对称加密到非对称加密）")

</br>

## 免密配置介绍

### 术语解释

- `known_hosts`：是做服务器认证的，当你用ssh连接到一个新的服务器的时候，ssh会让你确认服务器的信息（域名、IP、公钥），然后写到known_hosts里，以后你再连接到这个服务器就不用再确认了。如果信息改变了（通常是公钥改变了），就会提示你服务器信息改变了，你可以把它从known_hosts里删除，然后重新确认;
- `authorized_keys`：该文件用于保存其他主机的公钥；（比如：A主机要免密登录到B主机，就要把A主机的公钥保存到B主机的authorized_keys文件中）
- `id_rsa.pub` rsa公钥，可以发送到其他机子，用于加密；
- `id_rsa` rsa私钥，只能保存在本机，用于解密；

### 生成公钥和私钥

> SSH提供了公钥登录，可以省去输入密码的步骤。所谓"公钥登录"，就是用户将自己的公钥（id_rsa.pub）储存在远程主机上。登录的时候，远程主机会向用户发送一段用用户机器公钥加密的随机字符串，用户机器收到加密的字符串后，用自己的私钥解密后，再发回来。远程主机用事先储存的公钥进行解密，如果成功，就证明用户是可信的，直接允许登录shell，不再要求密码。

1. 用法：

    > ssh-keygen [-t rsa | ed25519] [-N new_passphrase] [-C comment]  [-f output_keyfile]

    执行后，可三次回车，三次回车意义如下：

    - 一次回车: 输出文件，即参数 `-f`; 回车表示输出文件使用默认位置，即 `~/.ssh/`
    - 二次回车：口令（回车表示口令为空），即参数 `-N`;
    - 三次回车：确定口令

2. 常用参数：

    - `-t`: 指定使用的数字签名算法, 分别有`dsa、rsa、ecdsa、ed25519`；默认为 `rsa`;
    - `-N`: 口令内容，可以为空;
    - `-C`: 注解，备注；默认为 `user@hostname`;
    - `-f`: 指定文件输出位置，默认为 `~/.ssh/`;

    Tips：

    - `rsa` 是目前兼容性最好的，应用最广泛的key类型，在用ssh-keygen工具生成key的时候，默认使用的也是这种类型。不过在生成key时，如果指定的key size太小的话，也是有安全问题的，推荐key size是3072或更大。
    - `ed25519` 是目前最安全、加解密速度最快的key类型，由于其数学特性，它的key的长度比rsa小很多，优先推荐使用。它目前唯一的问题就是兼容性，即在旧版本的ssh工具集中可能无法使用。（centos 6中无法使用ed25519）
    - 优先推荐 `ed25519`，如果您使用的是不支持 Ed25519 算法的旧系统，请使用 RSA，感兴趣的可以点击[Ed25519和 RSA详情入口](https://www.cnblogs.com/librarookie/p/15389876.html "RSA，DSA，ECDSA，EdDSA和Ed25519的区别")了解；

### 生成认证文件

> ssh-copy-id [-i [identity_file]] [user@]hostname

Tips:

- `-i`: 指定公钥文件; 默认使用 `~/.ssh/identity_file.pub` 作为默认公钥;
- 如果多次运行 `ssh-copy-id`，CentOS_6 不会检查重复,会在远程主机中多次写入 authorized_keys;
- `user`: 指定远程的用户，默认为当前用户;
- 执行成功之后，会在目标机器~/.ssh/目录已经生成`authorized_keys` 的文件，里面保存的正是原机器上 ssh-keygen 生成的公钥（如：id_rsa.pub）的内容。
- 此命令的效果是将本地公钥填充到一个远程主机的 authorized_keys 文件中。

</br>
</br>
