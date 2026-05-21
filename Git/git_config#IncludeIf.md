# git-config 配置多用户环境以及 includeIf用法

</br>
</br>

## 背景

> 开发人员经常遇到这样的问题，公司仓库和个人仓库的用户名和邮箱配置是有区别的，为了能够很好地区分工程上传到不同的远程仓库，我们需要分别处理，保证在不同的工程使用不同的账户

</br>

## 介绍

- Git支持多级配置，分别是`system(系统级)`、`global（用户级）`、`local（项目级）`和`worktree（工作区级）`

- 配置优先级： `worktree > local > global > system`

- 在Linux环境中，分别对应

  - `system`
    - `/etc/gitconfig`： 系统级配置文件；对系统中所有用户都普遍适用的配置。使用 `git config --system`读写的就是这个文件。

  - `global`
    - `~/.gitconfig`： 用户级配置文件；用户目录下的配置文件只适用于该用户。使用 `git config --global`读写的就是这个文件。

  - `local`
    - `$RepoPath/.git/config`： 项目级配置文件；当前项目的 git仓库目录中的配置文件（也就是工作目录中的 `.git/config` 文件）,这里的配置仅仅针对当前项目有效。使用 `git config --local`或 省略 `local参数`，读写的就是这个文件。

  - `worktree`： 工作区级配置；此配置仅仅针对当前工作区有效。使用 `git config --worktree`进行配置。

    `note` :

    - 每一个级别的配置都会覆盖上层的相同配置，所以 `.git/config` 里的配置会覆盖 `/etc/gitconfig` 中的同名变量。
    - `$RepoPath`为某仓库的本地路径

- 在 Windows 系统上
  - Git 会找寻用户主目录下的 `.gitconfig` 文件。主目录即 `$HOME变量`指定的目录，一般都是 `C:\Documents and Settings\$USER`。此外，Git 还会尝试找寻 `/etc/gitconfig` 文件，只不过看当初 Git 装在什么目录，就以此作为根目录来定位。

</br>

## 配置

1. 常规用法

    - 全局配置
      - 方法一： 在`~/.gitconfig`文件中添加`用户名`和`邮箱`
      - 方法二： 配置全局的`用户名`和`邮箱`

        ```py
        git config --global user.email "you@example.com"
        git config --global user.name "Your Name"
        ```

    - 项目仓库配置
      - 方法一： 在`$RepoPath/.git/config`文件中添加`用户名`和`邮箱`
      - 方法二： 配置项目的`用户名`和`邮箱`

        ```py
        # 进入 $RepoPath目录，并执行
        git config --local user.email "you@example.com"
        git config --local user.name "Your Name"
        ```

2. `includeIf` 用法

    > 可以在git的配置文件中使用 `include` 和 `includeIf` 关键字来包含其它配置文件，git在解析配置文件时，会将被包含的配置文件的内容内联到 包含指令 所在的位置；所以，被包含的配置文件的配置项会覆盖包含指令之前的配置项，包含指令之后的配置项会覆盖被包含的配置文件的配置项，即，优先级是：`包含指令后面的配置项 > 被包含的配置文件的配置项 > 包含指令之前的配置项`；

    - 示例

        ```py
        [include]
            path = /path/to/foo.inc ; # 绝对路径
            path = foo.inc ;    # 相对路径，相对于当前的配置文件
            path = ~/foo.inc ;  # 相对用户目录 `$HOME` 路径
        ```

    - `gitdir` 和 `gitdir/i`

        ```py
        # 当仓库所在目录包含gitdir之后的路径才会使用.inc文件
        [includeIf "gitdir:/path/to/foo/.git"]
            path = /path/to/foo.inc

        # 所有仓库目录在gitdir之后的路径下的，都会使用.inc文件
        [includeIf "gitdir:/path/to/group/"]
            path = /path/to/foo.inc

        # 路径描述也可以用定义过的环境变量代替 $HOME/to/group
        [includeIf "gitdir:~/to/group/"]
            path = /path/to/foo.inc
        ```

    - `onbranch`

        ```py
        # 包括只有当我们是在一个工作树，其中 foo-branch 目前已核实
        [includeIf "onbranch:foo-branch"]
            path = foo.inc
        ```

    **note：**
    - 在2017年，git新发布的版本2.13.0包含了一个新的功能includeIf配置，可以把匹配的路径使用对应的配置用户名和邮箱;
    - `"条件类型:匹配模式"` 是 `includeIf` 的条件；只有当条件成立时，才会包含 `path` 选项指定的配置文件；
    - `条件类型 和 匹配模式` 用 `:` 分隔;
    - `条件类型` 共有以下几种 `gitdir`、`gitdir/i`、`onbranch`;
      - `gitdir`、`gitdir/i`: 路径匹配模式，表示 如果 当前 git仓库的 `.git 目录`的位置 符合 `路径匹配模式`, 就加载对应的配置文件;（`gitdir/i`表示 `匹配模式`忽略大小写）
      - .git 目录的位置可能是 git 自动找到的 或是 $GIT_DIR 环境变量的值；
      - `onbranch`: 分支匹配模式, 表示 如果我们位于当前检出的分支名称 与 分支匹配模式 匹配的工作树中，就加载对应的配置文件;
    - `匹配模式` 采用标准的 `glob 通配符` 再加上 表示任务路径的通配符 `**`;
    - `path` 用于指定配置文件的路径;
    - 可以通过写`多个 path` 来表示包含`多个配置`文件;

</br>

## 栗子

1. 在用户配置文件 `~/.gitconfig` 中添加以下内容

   - 指定工程的用户配置

       ```py
       # 配置demo项目
       [includeIf "gitdir/i:~/workspace/private/demo/.git"]
           path = ~/.gitconfig_self
       ```

   - 指定目录的用户配置

       ```py
       # 配置public目录
       [includeIf "gitdir/i:~/workspace/public/"]
           path = ~/.gitconfig_work

       # 配置private目录
       [includeIf "gitdir/i:~/workspace/private/"]
           path = ~/.gitconfig_self
       ```

   - 指定分支的用户配置

       ```py
       # 配置 test-branch分支
       [includeIf "onbranch:test-branch"]
           path = ~/.gitconfig_self
       ```

2. 配置子配置文件

   - 方法一： 直接在`$path`文件中添加`用户名`和`邮箱`，如：

      ```py
      [user]
          name = librarookie
          email = librarookie@163.com
      ```

   - 方法二： 用`git config -f|--file`指定`$path`文件的`用户名`和`邮箱`

      > git config -f $path user.name "Your Name"</br>
      > git config -f $path user.email "you@example.com"

      ```py
      git config -f ~/.gitconfig_self user.name librarookie
      git config -f ~/.gitconfig_self user.email librarookie@163.com
      ```

</br>
</br>

Ref

- <https://git-scm.com/docs/git-config#_includes>
- <https://www.jianshu.com/p/2627ab5742a5>
- <https://www.codenong.com/js3a91b66ce374/>
