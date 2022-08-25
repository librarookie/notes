# 配置 GitHub 和 Gitee 共存环境

</br>
</br>

## 前言

- Git支持多级配置,分别是`system(系统级)`、`global（用户级）`、`local（项目级）`和`worktree（工作区级）`，其中常用的就用户级和项目级。

- 在Linux中，用户和项目级配置

  - `global`
    - `~/.gitconfig`： 用户级配置文件；用户目录下的配置文件只适用于该用户。使用 `git config --global`读写的就是这个文件。

  - `local`
    - `$RepoPath/.git/config`： 项目级配置文件；当前项目的 git仓库目录中的配置文件（也就是工作目录中的 `.git/config` 文件）,这里的配置仅仅针对当前项目有效。使用 `git config --local`或 `省略 local参数`，读写的就是这个文件。

    `note` :

    - 每一个级别的配置都会覆盖上层的相同配置，所以 `.git/config` 里的配置会覆盖 `/etc/gitconfig` 中的同名变量。
    - `$RepoPath`为某仓库的本地路径

- 在 Windows 系统上
  - Git 会找寻用户主目录下的 .gitconfig 文件。主目录即 $HOME 变量指定的目录，一般都是 C:\Documents and Settings\$USER。此外，Git 还会尝试找寻 /etc/gitconfig 文件，只不过看当初 Git 装在什么目录，就以此作为根目录来定位。

</br>

## 准备

1. git工具: <https://git-scm.com/downloads>

2. GitHub账号: <https://github.com>

3. Gitee账号: <https://gitee.com>

</br>

## 配置

1. 清除 git 的全局设置 (没配置全局则跳过)

    - 查看全局变量

        ```py
        git config --global --list
        ```

    - 清除全局`user.name`和`user.email`

        ```py
        git config --global --unset user.name
        git config --global --unset user.email
        ```

2. 生成并添加 SSH Keys

    - [点此进入生成并添加 SSH Keys](https://www.cnblogs.com/cure/p/15390170.html "生成&添加 SSH公钥")

3. 多环境配置config文件

    - 在`~/.ssh/`目录下创建config文件
        > touch ~/.ssh/config

    - 配置config文件内容

      - 最简配置

        ```py
        # GitHub
            Host github.com
            HostName github.com
            IdentityFile ~/.ssh/id_ed25519
        ```

      - 完整配置

        ```py
        # Default gitHub user Self
            Host github.com
            HostName github.com
            User git
            PreferredAuthentications publickey
            IdentityFile ~/.ssh/id_ed25519
            AddKeysToAgent yes

        # Add gitee user
            Host gitee.com
            HostName gitee.com
            User git
            PreferredAuthentications publickey
            IdentityFile ~/.ssh/id_ed25519
            AddKeysToAgent yes
        ```

      - 参数解释

        - Host

            ```py
            它涵盖了下面一个段的配置，我们可以通过他来替代将要连接的服务器地址。
            这里可以使用任意字段或通配符。
            当ssh的时候如果服务器地址能匹配上这里Host指定的值，则Host下面指定的HostName将被作为最终的服务器地址使用，并且将使用该Host字段下面配置的所有自定义配置来覆盖默认的/etc/ssh/ssh_config配置信息。
            ```

        - Port

            ```py
            自定义的端口。默认为22，可不配置
            ```

        - User

            ```py
            自定义的用户名，默认为git,也可不配置
            ```

        - HostName

            ```py
            真正连接的服务器地址
            ```

        - PreferredAuthentications

            ```py
            指定优先使用哪种方式验证，支持密码和秘钥验证方式
            ```

        - IdentityFile

            ```py
            指定本次连接使用的密钥文件
            ```

        - AddKeysToAgent yes

            ```py
            将私钥加载到 ssh-agent，
            等同于 ssh-add ~/.ssh/id_ed25519
            ```

</br>

## 检验

1. clone 测试

    - GitHub 项目

        ```py
        $ git clone git@github.com:librarookie/spring-boot.git

        Cloning into 'spring-boot'...
        remote: Enumerating objects: 15, done.
        remote: Total 15 (delta 0), reused 0 (delta 0), pack-reused 15
        Receiving objects: 100% (15/15), done.
        ```

    - Gitee 项目

        ```py
        $ git clone git@gitee.com:librarookie/test.git

        Cloning into 'test'...
        remote: Enumerating objects: 19, done.
        remote: Counting objects: 100% (19/19), done.
        remote: Compressing objects: 100% (9/9), done.
        remote: Total 19 (delta 0), reused 0 (delta 0), pack-reused 0
        Receiving objects: 100% (19/19), done.
        ```

2. push 测试

    - commit

        ```py
        $ git commit -am "test"

        Author identity unknown

        *** Please tell me who you are.

        Run

        git config --global user.email "you@example.com"
        git config --global user.name "Your Name"

        to set your account's default identity.
        Omit --global to set the identity only in this repository.

        fatal: unable to auto-detect email address (got 'noname@G3.(none)')
        ```

      - 原因是没有配置 `user.name`和 `user.email`
        - 方案一： 设置全局变量的 `user.name`和 `user.email`

        ```py
        git config --global user.email "you@example.com"
        git config --global user.name "Your Name"
        ```

        note: 此方案适合只使用GitHub 或Gitee（可以试试GitHub和Gitee使用同一个账号）

        - 方案二： 设置项目库局部 `user.name`和 `user.email`
            1. 进入项目本地仓库
            2. 设置 `user.name`和 `user.email`

        ```py
        git config --local user.email "you@example.com"
        git config --local user.name "Your Name"
        ```

    - commit 2

        ```py
        $ git commit -am "5555" 

        [test 52bcd83] 5555
        1 file changed, 1 insertion(+)
        ```

    - push

        ```py
        $ git push 

        Enumerating objects: 5, done.
        Counting objects: 100% (5/5), done.
        Writing objects: 100% (3/3), 242 bytes | 242.00 KiB/s, done.
        Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
        remote: Powered by GITEE.COM [GNK-6.1]
        To gitee.com:librarookie/test.git
        a14d3de..52bcd83  test -> test
        ```

## 拓展

- [如何将 GitHub 项目导入码云？一步搞定！](https://blog.gitee.com/2018/06/05/github_to_gitee/ "如何将 GitHub 项目导入码云？一步搞定！")
- [git-config 配置多用户环境以及 includeIf用法](https://www.cnblogs.com/librarookie/p/15697181.html "git-config 配置多用户环境以及 includeIf用法")

</br>
</br>

Ref

- <https://duter2016.github.io/2021/01/22/Git%E5%90%8C%E6%97%B6%E4%BD%BF%E7%94%A8Gitee%E5%92%8CGithub%E5%B9%B6%E8%AE%BE%E7%BD%AE%E4%BB%A3%E7%90%86/>
- <https://www.jianshu.com/p/68578d52470c>
