# Linux 常用命令

## bash

1. bash 是一个明林处理器，运行在文本窗口中，并能执行用户直接输入的命令；
2. bash 能从文件中读取 Linux命令，称之为“脚本”；
3. bash 支持通配符、管道、命令替换、条件判断等逻辑控制语句；

## echo

### echo介绍

> echo命令是Linux中最基本和最常用的命令之一。传递参数给echo将打印到标准输出。echo通常在shell脚本中用于打印消息或输出其他命令的结果。Linxu还有一个独立的/usr/bin/echo程序，但它们的行为与shell之间略有不同。通常shell内置版本将优先。

- Usage:

> echo [-neE]... [STRING]...

将STRING(s)回传到标准输出。

- Options:

    ```md
    -n      不输出后面的换行符
    -e      启用反斜杠转义的解释
    -E      禁用反斜杠转义的解释(默认)
    ```

- 常用转义符

    ```md
    \\      识别反斜杠（backslash）
    \a      警报（alert）
    \b      退格（backspace）
    \c      不产生进一步的输出
    \e      转义（escape）
    \f      换页（form feed）
    \n      换行（new line）
    \r      回车（carriage return）
    \t      水平制表符（horizontal tab）
    \v      垂直制表符（vertical tab）
    \0NNN   八进制值NNN的字节（1到3位）
    \xHH    十六进制值HH的字节（1到2位）
    ```

### echo栗子

1. 常用打印

    ```md
    # 标准打印一行文本
    echo "Hello, World"         --> Hello, World
    # 转义常用符号
    echo "Hello, \"World\""     --> Hello, "World"
    # 使用转义字符
    echo -e "Hello, Wo\brld"    --> Hello, Wrld
    # 使用配置字符
    echo Log files: *.log       --> Log files: info.log debug.log error.log
    # 将输出重定向到文件（`>` 覆盖文件，`>>` 追加到下一行）
    echo "This is the content" > file.txt      --> cat file.txt      --> This is the content
    # 打印变量
    echo $USER                  --> root
    # 打印命令的输出
    echo "Date: $(date +%F)"    --> Date: 2022-06-16
    ```

2. 以彩色进行echo打印

    ```md
    echo -e "\033[1;37mWHITE"     –打印白色 WHITE
    echo -e "\033[0;30mBLACK"     –打印黑色 BLACK
    echo -e "\033[0;34mBLUE"      –打印蓝色 BLUE
    echo -e "\033[0;32mGREEN"     –打印绿色 GREEN
    echo -e "\033[0;36mCYAN"      –打印青蓝色 CYAN
    echo -e "\033[0;31mRED"       –打印红色 RED
    echo -e "\033[0;35mPURPLE"    –打印紫色 PURPLE
    echo -e "\033[0;33mYELLOW"    –打印黄色 YELLOW
    echo -e "\033[1;30mGRAY"      –打印灰色 GRAY
    ```

## alias（别名）

### alias介绍

- Usage:

    > 添加别名 alias [-p] [name[=value] ...]
    > 删除别名 unalias [-a] name [name ...]

    -p 列出所有alias

1. 临时配置alias

    > 此操作只有当前窗口生效，重新打开则失效；

    - 新增 |修改别名
        > alias la='ls -a'

    - 删除别名
        > unalias la ll

        Tips: `unalias -a` 临时删除所有别名

2. 永久配置alias

    > 永久生效分用户级和系统级，用户级是将alias写入 ~/.bashrc 文件， 系统级是将alias写入 /etc/bashrc 文件（推荐使用用户级）

    - 更新配置文件（~/.bashrc）
      - 添加alias
          > echo "alias la='ls -a'" >> ~/.bashrc

      - 修改 |删除alias
        打开并编辑 ~/.bashrc 文件
          1. 打开配置文件
              > vim ~/.bashrc （不习惯用vim的，可以使用自己习惯的工具）

          2. 找到配置的alias，更新或删除该alias

    - 使配置生效
        > source ~/.bashrc

3. 查看别名
    > alias -p

## history


