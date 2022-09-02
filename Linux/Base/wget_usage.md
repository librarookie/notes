# wget 命令介绍与使用

</br>
</br>

## 介绍

### 用法

```sh
wget  [OPTION]...  [URL]...
wget  [参数列表]    [目标软件、网页的网址]
```

*Tips*: 长选项所必须的参数在使用短选项时也是必须的

</br>

### 常用参数

- 启动：

    ```sh
    -V,  --version                   # 显示 Wget 的版本信息并退出
    -h,  --help                      # 打印帮助
    -b,  --background                # 启动后转入后台
    ```

- 记录和输入文件：

    ```sh
    -o,  --output-file=FILE          # 将日志信息写入【FILE】
    -a,  --append-output=FILE        # 将信息添加至【FILE】
    -q,  --quiet                     # 安静模式 (无信息输出)
    -v,  --verbose                   # 详细输出 (默认)
    -nv, --no-verbose                # 关闭详细输出，但不进入安静模式
    -i,  --input-file=FILE           # 下载本地或外部 [FILE] 中的 URL
    ```

- 下载：

    ```sh
    -t,  --tries=NUMBER              # 设置重试次数为【NUMBER】(0 代表无限制)
        --retry-connrefused         # 即使拒绝连接也重试
    -O,  --output-document=FILE      # 将文档写入【FILE】（可以理解为把下载的文件重命名改为【FILE】）
    -nc, --no-clobber                # 不要下载已存在文件
    -c,  --continue                  # 断点续传下载文件（继续获取部分下载）
    -N,  --timestamping              # 只获取比本地文件新的文件
    -S,  --server-response           # 打印服务器响应头信息
        --spider                    # 不下载任何文件
        --limit-rate=RATE           # 限制下载速率为 [RATE]
        --ignore-case               # 匹配文件/目录时忽略大小写
        --user=USER                 # 将 ftp 和 http 的用户名均设置为【USER】
        --password=PASS             # 将 ftp 和 http 的密码均设置为【PASS】
        --ask-password              # 提示输入密码
    ```

- 目录：

    ```sh
    -nd, --no-directories            # 不创建目录
    -x,  --force-directories         # 强制创建目录
    -nH, --no-host-directories       # 不要创建主机（www.cnglogs.com）目录
        --protocol-directories      # 在目录中使用协议名称（从https开始创建目录）
    -P,  --directory-prefix=PREFIX   # 保存文件到指定的【PREFIX】目录
        --cut-dirs=NUMBER           # 忽略远程目录中【NUMBER】个目录层。
    ```

- HTTP选项：

    ```sh
    --http-user=USER            # 设置 http 用户名为【USER】
    --http-password=PASS        # 设置 http 密码为【PASS】
    --no-cache                  # 不使用服务器缓存的数据。
    --default-page=NAME         # 改变默认页名称 (通常是“index.html”)
    --no-cookies                # 不使用 cookies
    --save-cookies=FILE         # 会话结束后保存 cookies 至【FILE】
    ```

- HSTS选项：

    ```sh
    --no-hsts                   # 禁用 HSTS
    --hsts-file                 # HSTS 数据库路径（将覆盖默认值）
    ```

- FTP选项：

    ```sh
    --ftp-user=USER             # 设置 ftp 用户名为【USER】
    --ftp-password=PASS         # 设置 ftp 密码为【PASS】
    --no-glob                   # 不在 FTP 文件名中使用通配符展开
    --preserve-permissions      # 保留远程文件的权限
    --retr-symlinks             # 递归目录时，获取链接的文件 (而非目录)
    ```

- 递归下载：

    ```sh
    -r,  --recursive            # 指定递归下载
    -l,  --level=NUMBER         # 最大递归深度 (inf 或 0 代表无限制，即全部下载)。
        --delete-after         # 下载完成后删除本地文件
        --backups=N            # 写入文件 X 前，轮换移动最多 N 个备份文件
    -K,  --backup-converted     # 在转换文件 X 前先将它备份为 X.orig
    ```

- 递归接受/拒绝：

    ```sh
    -A,  --accept=LIST          # 逗号分隔的可接受的扩展名列表
    -R,  --reject=LIST          # 逗号分隔的要拒绝的扩展名列表
        --accept-regex=REGEX        # 匹配接受的 URL 的正则表达式
        --reject-regex=REGEX        # 匹配拒绝的 URL 的正则表达式
        --regex-type=TYPE           # 正则类型 (posix|pcre)
    -D,  --domains=LIST              # 逗号分隔的可接受的域名列表
        --exclude-domains=LIST      # 逗号分隔的要拒绝的域名列表
    -I,  --include-directories=LIST  # 允许目录的列表
    -X,  --exclude-directories=LIST  # 排除目录的列表
    -np, --no-parent                 # 不追溯至父目录
    ```

</br>

## 常用实例

- 下载单个文件/网页

    ```sh
    wget https://www.rarlab.com/rar/rarlinux-6.0.1.tar.gz   # 下载rarlinux-6.0.1.tar.gz文件
    wget https://www.rarlab.com/download.htm        # 下载 download.htm 网页
    ```

- 将下载的文件名改为指定文件名 （参数 `O` ）

    ```sh
    wget -O edit.html https://i.cnblogs.com/posts/editpostId=14660645
    # 默认下载保存的文件为“editpostId=14660645”
    # 使用 -O 参数后，保存的文件为指定文件名，这里是“edit.html”
    ```

- 断点下载（参数 `c` ）

    ```sh
    # 这个参数适合下载大文件，网速不理想的场景
    # 借助参数 "c", 可以继续从文件中断的地方继续下载
    wget -c https://www.rarlab.com/rar/rarlinux-6.0.1.tar.gz
    ```

- 后台下载（参数 `b` ）

    ```sh
    # 对于下载大文件时，我们可以使用参数 “b”，将进程切换到后台下载
    # 切换后台下载后，我们可以通过 “wget-log” 查看下载进度（wget-log 在当前目录下）
    # 可以搭配 -t 参数使用，表示重试次数，例如需要重试100次，那么就写-t 100，如果设成-t 0，那么表示无穷次重试，直到连接成功
    wget -b https://www.rarlab.com/rar/rarlinux-6.0.1.tar.gz
    ```

- 批量下载（参数 `i` ）

    ```sh
    # 自定义一个文件URLlist.txt，将需要下载的URL都输入进去，然后使用参数 “i”指定改文件即可
    wget -i URLlist.txt
    ```

- 检查网页是否可访问，而不用下载（ `S` ：打印响应信息， `spaider` ：不下载）

    ```sh
    wget [-S] --spaider https://www.cnblogs.com/librarookie/p/14660645.html
    ```

- 指定文件格式下载（ `A` 指定下载文件格式， `R` 指定忽略下载文件格式）

    ```sh
    # LIST 表示可以指定多个格式
    wget -A png https://www.cnblogs.com/    或  wget --accept=LIST https://www.cnblogs.com/
    wget -R gif https://www.cnblogs.com/    或  wget --reject=LIST https://www.cnblogs.com/
    ```

- 指定用户名密码下载

    ```sh
    # 此场景适合部分访问需要用户名和密码验证的 URL下载
    wget --user=USER --password=PASS https://www.cnblogs.com/librarookie/p/14660645.html   # 此方式密码明文显示
    wget --user=USER --ask-password https://www.cnblogs.com/librarookie/p/14660645.html    # 此方式密码是按回车后，提示输入密码，密码不显示（推荐）
    ```

- 下载URL中的当前位置的所有文件

    ```sh
    # 场景： 我需要下载文件服务器某一路径下的全部文件，但是不需要保存主页 “index.html”

    wget -r -np -nd -R html,tmp  https://www.cnblogs.com/librarookie/p/
        或者：
    wget -r -np -nd -A txt,zip,png[...]  https://www.cnblogs.com/librarookie/p/

    # 参数介绍：
    # -r   递归下载（最好跟上np参数，不然会下载整个网站的数据及关联网站数据）
    # -np  不追溯到父级（表示只访问当前位置）
    # -nd  不创建文件夹
    # -R   忽略/拒绝下载的格式（wget下载会默认下载主页“index.html”，拒绝下载html格式时，会保存为html.tmp文件）
    # -A   指定下载的格式（只下载指定格式的文件，这样也不会下载主页“index.html”）
    ```

</br>
</br>

Via

- <https://www.jianshu.com/p/59bb131bc2ab>
