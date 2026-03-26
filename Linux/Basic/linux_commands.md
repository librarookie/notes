
# Linux 常用命令


## bash

1. bash 是一个命令处理器，运行在文本窗口中，并能执行用户直接输入的命令；
2. bash 能从文件中读取 Linux命令，称之为“脚本”；
3. bash 支持通配符、管道、命令替换、条件判断等逻辑控制语句；

## $'...'（ANSI-C 引用）

> **ANSI-C引用**是Bash中一种特殊的引用形式，其格式为 **`$'string'`**。它允许在单引号字符串中使用类似C语言的转义序列，使字符串中的反斜杠（`\`）被特殊解释，从而方便地表示控制字符、特殊字符和不可打印字符。这是Bash中处理复杂字符串内容的强大工具。

```
$'string'
```

其中，`string` 可以包含以下内容：

- **普通字符**：原样保留。
- **转义序列**：以反斜杠（`\`）开头的特殊序列，会被解释为特定的字符baidu.com。

其工作原理是，Bash会将 `$'string'` 展开为一个新的字符串，其中的转义序列被替换为对应的字符

```sh
# 1. 处理特殊字符或单引号

# 输出制表符分隔的内容
echo $'姓名:\t张三\n年龄:\t25'

# 单引号转义，输出：It's a test
echo $'It\'s a test'

# 在grep模式中使用制表符进行匹配
grep $'\t' file.txt

# 在sed脚本中使用换行符作为模式
sed $'s/old/new\\\n/g' file.txt  # 注意这里的\\\n，第一个\\转义为\，然后与n组合成\n

# 输出绿色的“Success”并重置颜色
echo $'\e[32mSuccess\e[0m'
# 类似：echo -e '\e[32mSuccess\e[0m'


# 2. 在参数扩展等高级用法中精确匹配

# 删除变量值中的第一个制表符及其前的内容
var="name\tvalue"
echo "${var#*$'\t'}"  # 输出: value

在Bash的参数扩展（如 `${parameter#pattern}`）或字符串匹配中，需要精确表示制表符等字符时，ANSI-C引用是标准方法
```

## echo

> echo命令是Linux中最基本和最常用的命令之一，通常在shell脚本中用于打印消息或输出其他命令的结果。
> Linxu还有一个独立的/usr/bin/echo程序，但它们的行为与shell之间略有不同。通常shell内置版本将优先。

`echo [-neE]... [STRING]...`

将STRING(s)回传到标准输出。

```sh
-n      不输出后面的换行符
-e      启用反斜杠转义的解释
-E      禁用反斜杠转义的解释(默认)
```

- 常用转义符

```sh
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

```sh
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

```sh
echo -e "\033[1;37mWHITE"     # 打印白色 WHITE
echo -e "\033[0;30mBLACK"     # 打印黑色 BLACK
echo -e "\033[0;34mBLUE"      # 打印蓝色 BLUE
echo -e "\033[0;32mGREEN"     # 打印绿色 GREEN
echo -e "\033[0;36mCYAN"      # 打印青蓝色 CYAN
echo -e "\033[0;31mRED"       # 打印红色 RED
echo -e "\033[0;35mPURPLE"    # 打印紫色 PURPLE
echo -e "\033[0;33mYELLOW"    # 打印黄色 YELLOW
echo -e "\033[1;30mGRAY"      # 打印灰色 GRAY
```

## sed（流编辑器）

>sed是一种流编辑器，能高效地完成各种替换、删除、插入等操作，按照文件数据行顺序，重复处理满足条件的每一行数据，然后把结果展示打印，且不会改变原文件内容。

[sed命令介绍请前往](https://www.cnblogs.com/librarookie/p/18504458 “传送装”)：<https://www.cnblogs.com/librarookie/p/18504458>

## alias（别名）

> 添加别名 alias [-p] [name[=value] ...]
> 删除别名 unalias [-a] name [name ...]

1. 临时配置alias

> 此操作只有当前窗口生效，重新打开则失效；

```sh
# 列出所有别名
alias -p

# 新增/修改别名
alias la='ls -a'

# 删除别名
unalias la ll

# 临时删除所有别名
unalias -a
```

2. 永久配置alias

> 永久生效分用户级和系统级
> 用户级是将alias写入 `~/.bashrc` `$HOME/.bashrc` 文件；（推荐）
> 系统级是将alias写入 `/etc/bashrc` 文件。

- 更新配置文件
```sh
# 添加别名：在 bashrc 文件中添加一条别名规则
echo "alias la='ls -a'" >> $HOME/.bashrc

# 更新别名‘la’ -> ‘lsa’：在 bashrc 文件中找到目标别名‘la’，并修改
sed -i 's/la/lsa/' $HOME/.bashrc

# 更新别名‘lsa’：在 bashrc 文件中找到目标别名‘lsa’，并删除
sed -i '/lsa/d' $HOME/.bashrc

# 使配置生效
source $HOME/.bashrc
```


## history

TODO history

</br>
</br>

TAG Unreleased
