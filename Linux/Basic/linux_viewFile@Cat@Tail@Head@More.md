# Linux 查看文件的最后几行

</br>
</br>

## 背景

> 当我们需要查看某个很大的文件时，查看全部内容会非常耗时，还会因为文件过大，查看起来非常的不方便，下面我们介绍一下Linux的几种文件查看方式

查看 catalina.out 文件后100行

`tail -n 100 catalina.out`

</br>

## 查看文件命令

### cat & tac

> cat 命令为从首行显示到尾行，一次展示文件全部内容，当文件比較大时，来不及看就翻屏过了。tac效果与cat相似，是从尾行显示到首行；

#### cat

> cat 是 concatenate（连接、连续）的简写。</br>
> cat file1 file2 > file3 --将文件file1 和 file2 的内容合并到 file3

- Usage:

    `cat [OPTION]... [FILE]...`

- Options:

    | key | value |
    | ---- | ---- |
    |-n, --number | 显示行号；输出所有行的数量 |
    |-b, --number-nonblank | 显示非空行号；非空的输出行数，覆盖-n |
    |-s, -squeeze-blank | 抑制重复的空行输出（连续重复的空行显示为一行） |
    |-E, --show-ends | 在每一行的末尾显示$。 |
    |-T, --show-tabs | 显示TAB字符为^I |
    |-A, --show-all | 相当于-vET，用于列出所有隐藏符号，包括回车符（$）、Tab 键（^I）等 |
    |-e | 相当于 -vE |
    |-t | 相当于 -vT |
    |-u | 忽略 |
    |--v, --show-nonprinting | 使用^和M-符号，LFD和TAB除外 |
    |    --help | 显示此帮助并退出 |
    |    --version | 输出版本信息并退出 |

    Tips：cat 命令用于查看文件内容时，不论文件内容有多少，都会一次性显示。如果文件非常大，那么文件开头的内容就看不到了。不过 Linux 可以使用PgUp+上箭头组合键向上翻页，但是这种翻页是有极限的，如果文件足够长，那么还是无法看全文件的内容。因此，cat 命令适合查看不太大的文件。

#### tac

- Usage:

    `tac [OPTION]... [FILE]...`

- Options:

    | key | value |
    | ---- | ---- |
    |-b, --before | 将分隔符放在前面而不是后面 |
    |-r, --regex | 将分隔符解释为一个正则表达式 |
    |-s, --separator=STRING | 使用 STRING 作为分隔符而不是换行符 |
    |    --help | 显示此帮助并退出 |
    |    --version | 输出版本信息并退出 |

</br>

### tail & head

> tail 命令显示文件结尾内容，默认显示文件最后 `10` 行； head 命令显示文件开头内容，默认显示文件开头 `10` 行；

- tail Usage:

    `tail [OPTION]... [FILE]...`

- head Usage:

    `head [OPTION]... [FILE]...`

- Options:

    | key | tail | head |
    | ---- | ---- | ---- |
    |-c, --bytes=[+]NUM | 输出最后的 NUM个字节；`+NUM`，从 NUM个字节开始输出 | 打印开头的 NUM字节；`-NUM`，打印文件除最后 NUM个字节的所有内容 |
    |-n, --lines=[+]NUM | 输出最后的 NUM行；`+NUM`，从 NUM行开始输出 | 打印开头的 NUM行；`-NUM`，打印文件除最后 NUM行的所有内容 |
    |-f, --follow[={name\|descriptor}] | 随着文件的增长，输出附加的数据；没有选项参数意味着 "descriptor" | X |
    |-F | 与 --follow=name --retry 相同 | X |
    |    --retry | 在文件无法访问的情况下继续尝试打开该文件 | X |
    |-s, --sleep-interval=N | 与-f一起使用，睡眠时间大约为N秒 (默认为1.0)。 至少每隔N秒检查一次 | X |
    |    --pid=PID | 与-f使用，在进程ID、PID死亡后终止 | X |
    |-q, --quiet, --silent | 不输出文件名的标题（默认） | 不打印提供文件名的标题 |
    |-v, --verbose | 总是输出文件名的头文件 | 总是打印文件名的标题 |
    |-z, --zero-terminated | 行的分隔符是NUL，不是换行符 |行的分隔符是NUL，不是换行符  |
    |    --help | 显示此帮助并退出 | 显示此帮助并退出 |
    |    --version | 输出版本信息并退出 | 输出版本信息并退出 |

Tips：

- `tail -num` 等价于 `tail -n num`, head 也一样；
- NUM 可以有一个乘数后缀:
  - `b 512`, `kB 1000`, `K 1024`, `MB 1000*1000`, `M 1024*1024`,
`GB 1000*1000*1000`, `G 1024*1024*1024`, 以此类推，`T`、`P`、`E`、`Z`、`Y`。
  - 也可以使用二进制前缀。`KiB=K`，`MiB=M`，以此类推。

</br>

### more & less

> less 与 more命令相似，都是分页显示文件全部内容。

#### more

- Usage:

    `more [options] [file]...`

- Options:

    | key | value |
    | ---- | ---- |
    |-d, --silent | 显示帮助而不是响铃 |
    |-f, --logical | 计算逻辑而不是屏幕行数 |
    |-l, --no-pause | 禁止在表格输入后暂停。 |
    |-c, --print-over | 不滚动，显示文本和干净的行尾 |
    |-p, --clean-print | 不滚动，清洁屏幕并显示文本 |
    |-s, --squeeze | 将多个空行挤压成一行 |
    |-u, --plain | 抑制下划线和加粗。 |
    |-n, --lines [number] | 每个屏幕的行数 |
    |-[number] | 与-lines相同 |
    |+[number] | 显示从行号开始的文件 |
    |+/[pattern] | 显示从模式匹配开始的文件 |
    |-h, --help | 显示此帮助 |
    |-V, --version | 显示版本 |

- 常用交互命令

    | 交互指令 | 功能 |
    | ---- | ---- |
    | h \| ？ | 交互命令帮助 |
    | q \| Q | 退出 more |
    | v | 在当前行启动系统预设文本编辑器 |
    | = | 显示当前行的行号 |
    | :f | 显示当前文件的文件名和行号 |
    | !<命令> 或 :!<命令> | 在子Shell中执行指定命令 |
    | 回车键 | 向下移动一行 |
    | 空格键 | 向下移动一页 |
    | Ctrl+l | 刷新屏幕 |
    | ' | 转到上一次搜索开始的地方 |
    | Ctrf+f | 向下滚动一页 |
    | . | 重复上次输入的命令 |
    | /字符串| 搜索指定的字符串 |
    | d | 向下移动半页 |
    | b | 向上移动一页 |

#### less

[less命令介绍](https://www.cnblogs.com/librarookie/p/16499068.html "less 介绍与使用")

</br>
</br>

## 栗子

1. 查看开头或结尾内容

    ```sh
    tail -n 200 catalina.out    # 输出 最后200行内容
    tail -n 2b catalina.out    # 输出 最后 2 * 512行内容

    head -n 100 catalina.out    # 输出 开头100行内容
    head -n b catalina.out    # 输出 开头 512行内容
    ```

2. 排除开头或结尾内容

    ```sh
    tail -n +200 catalina.out   # 输出 开头200行 以后的内容，即从200行开始打印

    head -n -100 catalina.out    # 输出 最后100行 以前的内容， 即打印到最后100行为止
    ```

    Tips: tail 和 head 都支持乘数后缀（b, K ,M 等等）

3. 查看显示行号

    ```sh
    cat -n catalina.out     # 显示所有行号(包括空行)

    cat -b catalina.out     # 显示所有行号(但不包括空行)

    less -N catalina.out        # 显示所有行号(包括空行)

    nl [-ba] catalina.out       # 显示所有行号(包括空行)

    nl -bt catalina.out     # 显示所有行号(但不包括空行)
    ```

4. 实时查看文件内容

    ```sh
    tail -f catalina.out

    less catalina.out --> F
    ```

5. 合并文件

    ```sh
    cat file1 file2 > file3
    ```

</br>
</br>
