# Sed 命令使用

</br>
</br>

> sed是一种流编辑器，能高效地完成各种替换、删除、插入等操作，按照文件数据行顺序，重复处理满足条件的每一行数据，然后把结果展示打印，且不会改变原文件内容。

sed会逐行扫描输入的数据，并将读取的数据内容复制到临时缓冲区中,称为“模式空间”（pattern space），然后拿模式空间中的数据与给定的条件进行匹配，如果匹配成功，则执行特定的sed指令，否则跳过输入的数据行，继续读取后面的数据。

</br>

## 一、命令介绍

### 1.1 命令语法

```sh
sed [OPTION]... {script-only-if-no-other-script} [input-file]...

#如：
sed [选项] '匹配条件和操作指令' 文件名
cat 文件名 | sed [选项] '匹配条件和操作指令'
```

### 1.2 选项参数

```sh
-n, --quiet, --silent
                #suppress automatic printing of pattern space
    --debug     #annotate program execution
-e script, --expression=script
                #add the script to the commands to be executed
-f script-file, --file=script-file
                #add the contents of script-file to the commands to be executed
--follow-symlinks
                #follow symlinks when processing in place
-i[SUFFIX], --in-place[=SUFFIX]
                #edit files in place (makes backup if SUFFIX supplied)
-l N, --line-length=N
                #specify the desired line-wrap length for the 'l' command
--posix         #disable all GNU extensions.
-E, -r, --regexp-extended
                #use extended regular expressions in the script (for portability use POSIX -E).
-s, --separate
                #consider files as separate rather than as a single, continuous long stream.
    --sandbox
                #operate in sandbox mode (disable e/r/w commands).
-u, --unbuffered
                #load minimal amounts of data from the input files and flush the output buffers more often
-z, --null-data
                #separate lines by NUL characters
    --help      #display this help and exit
    --version   #output version information and exit
```

| 选项 | 例子 |
| ---- | ---- |
| `-n, --quiet, --silent` </br> 禁止自动打印模式（常配合'p'使用，仅显示处理后的结果） | `sed -n '/hello/p'  filename` </br> 使用 /hello/ 匹配含有 "hello" 的行，p 打印匹配的行 |
| `--debug` </br> 以注解的方式显示 sed 的执行过程，帮助调试脚本 | `sed --debug 's/foo/bar/'  filename` </br> 当你使用 sed 修改内容时，它会显示调试信息，以便你了解脚本是如何执行的 |
| `-e script, --expression=script` </br> 在命令行中直接指定 sed 脚本（允许多个 sed 表达式） | `sed -e 's/foo/bar/' -e 's/hello/world/'  filename` </br> 将文件中的 foo 替换为 bar，然后将 hello 替换为 world |
| `-f script-file, --file=script-file` </br> 从指定的脚本文件中读取 sed 命令 | `sed -f script.sed  filename` </br> script.sed 是包含多个 sed 命令的脚本文件，sed 会按顺序执行这些命令 |
| `--follow-symlinks` </br> 当指定 -i 时，sed 会跟随符号链接（symlink）指向的实际文件进行编辑 | `sed -i --follow-symlinks 's/foo/bar/' symlink.txt` </br> 如果 symlink.txt 是一个符号链接文件，sed 会编辑它指向的实际文件 |
| `-i[SUFFIX], --in-place[=SUFFIX]` </br> 直接编辑文件（如果提供 SUFFIX，则进行备份） | `sed -i.bak 's/foo/bar/'  filename` </br> 直接在  filename 中将 foo 替换为 bar，并创建一个备份文件  filename.bak |
| `-l N, --line-length=N` </br> 当使用 l 命令（列出行内容）时，指定输出的行宽（N 表示字符数） | `echo 'hello world' \| sed -l 5 'l'` </br> 使用 l 命令显示 "hello world"，但每行最多显示 5 个字符 |
| `--posix` </br> 禁用 GNU 扩展，使 sed 遵循 POSIX 标准语法 | `sed --posix 's/foo/bar/'  filename` </br> 这将禁用 sed 的一些非标准特性，确保脚本在 POSIX 环境下工作 |
| `-E, -r, --regexp-extended` </br> 使用扩展的正则表达式（ERE），这与基本正则表达式（BRE）相比，简化了一些语法（例如不用转义括号和 +） | `echo "abc123" \| sed -E 's/[a-z]+([0-9]+)/\1/'` </br> 使用扩展正则表达式，匹配并提取字母后面的数字 |
| `-s, --separate` </br> 将多个输入文件视为独立的流，而不是作为一个连续的流处理 | `sed -s 's/foo/bar/' file1.txt file2.txt` </br> sed 会分别处理 file1.txt 和 file2.txt，而不是将它们作为一个整体处理 |
| `--sandbox` </br> 以沙盒模式运行，禁止使用 e, r, w 命令，防止 sed 修改文件或执行外部命令 | `sed --sandbox 's/foo/bar/'  filename` </br> 启用沙盒模式，防止 sed 脚本执行危险的操作 |
| `-u, --unbuffered` </br> 减少从输入文件读取数据时的缓冲区大小，并更频繁地刷新输出 | `sed -u 's/foo/bar/'  filename` </br> 立即将处理结果输出到标准输出，而不是等到处理大量数据后再输出 |
| `-z, --null-data` </br> 将输入中的行分隔符从换行符 \n 改为 NUL 字符 \0，这在处理二进制数据或以 NUL 作为分隔符的文本时很有用 | `sed -z 's/foo/bar/'  filename` </br> 使用 NUL 字符作为行分隔符处理文本 |

### 1.3 匹配条件

| 格式 | 描述|
| ---- | ---- |
| /regexp/ | 使用 "正则表达式"，匹配数据行 |
| n（数字） | 使用 "行号" 匹配，范围是 `1-$`（$ 表示最后一行） |
| addr1,addr2 | 使用 "行号或正则" 定位，匹配从 addr1 到 addr2 的所有行 |
| addr1,+n | 使用 "行号或正则" 定位，匹配从 addr1 开始及后面的 n 行 |
| n~step | 使用 "行号"，匹配从行号 n 开始，步长为 step 的所有数据行 |

#### 1.3.1 定界符

> / 在sed中作为定界符使用，也可以使用任意的定界符。

```sh
sed 's|foo|bar|g' filename
sed 's:foo:bar:g' filename

#定界符出现在样式内部时，需要进行转义：
sed 's/\/bin/\/usr\/bin/g' filename
```

#### 1.3.2 变量引用

> sed表达式使用单引号来引用，但是如果表达式内部包含"变量"字符串，则需要使用双引号。

```sh
foo="world"
echo "hello world" | sed "s/$foo/librarookie"
hello librarookie
```

### 1.4 操作指令

| 指令 | 描述| 例子 |
| ---- | ---- | ---- |
| ! <script\> | 表示后面的命令，对 "所有没有被选定" 的行发生作用 | `sed -n '/foo/!p' filename` </br> 只打印不含有 "foo" 的行 |
| p | 打印（print）当前匹配的数据行（常配合 -n 使用） | `sed -n '/foo/p' filename` </br> 只打印含有 "foo" 的行 |
| l | 小写L，打印当前匹配的数据行，并显示控制字符，如回车符\，结束符$等 | `sed -n '/foo/l' filename` </br> 只打印含有 "foo" 的行，并显示控制字符 |
| = | 打印当前读取的数据所在的 "行数" | `sed -n '$=' filename` </br> 打印文件最后一行的行数 |
| a\ <text\> | 在匹配的数据行 "后" 追加（append）文本内容 | `sed '/foo/a\hello librarookie' filename` </br> 在每个含有 "foo" 行，下面追加一行 "hello librarookie" |
| i\ <text\> | 在匹配的数据行 "前" 插入（insert）文本内容 | `sed '/foo/i\hello librarookie' filename` </br> 在每个含有 "foo" 行，上面插入一行 "hello librarookie" |
| c\ <text\> | 将匹配的数据行 "整行" 内容更改（change）为特定的文本内容 | `sed '/foo/c\hello librarookie' filename` </br> 将每个含有 "foo" 整行，替换为 "hello librarookie" |
| d | 行删除，删除（delete）匹配的数据行整行内容 | `sed '/foo/d' filename` </br> 删除每个含有 "foo" 的行 |
| r <filename\> | 从文件中读取（read）数据，并追加到匹配的数据行后面 | `sed -i '/foo/r datafile' filename` </br> 将文件 datafile 的内容，追加在文件 filename 中每个含有 "foo" 的行下面 |
| w <filename\> | 将当前匹配到的数据，写入（write）特定的文件中 | `sed -n '/foo/w newfile' filename` </br> 将文件 filename 中每个含有 "foo" 的行，写入到新文件 newfile 里面 |
| q [exit code] | 立刻退出（quit）sed脚本 | `sed '5q' filename` </br> 打印第 5 行前的数据，类似 `sed -n '1,5p` |
| s/regexp/replace/ | 使用正则匹配，将匹配的数据替换（substitute）为特定的内容 | `sed 's/foo/bar/' filename` </br> 将每个含有 "foo" 行中，第一次出现的 "foo"，替换为 "bar" |
| n（数字） | 只替换第 n 次出现的匹配项 | `sed 's/foo/bar/2' filename` </br> 将每个含有 "foo" 行中，第 2 次出现的 "foo"，替换为 "bar" |
| g | 全局替换（Global substitution）：替换每一行中的所有匹配项 | `sed 's/foo/bar/g' filename` </br> 将每行中的 "foo" ，替换为 "bar" |
| i | 忽略大小写（Ignore case）：进行不区分大小写的匹配 | `sed '/foo/i' filename` </br> 打印含有 "foo" 或 "FOO" 的行 |
| e | 执行（Execute）：允许在替换文本中进行命令执行 | `echo "ls /tmp" \| sed 's/ls/ls -l/e'` </br> 将sed命令的结果，当作命令执行；即输出 `ls -l /tmp` 命令的结果 |
| & | 引用匹配的整个字符串 | `echo "hello" \| sed 's/hello/& librarookie/'` </br> 将每行中的 "foo" ，替换为 "bar" |

### 1.5 高级操作指令

| 指令 | 描述|
| ---- | ---- |
| h | 将 "模式空间" 中的数据`复制`到 "保留空间" |
| H | 将 "模式空间" 中的数据`追加`到 "保留空间" |
| g | 将 "保留空间" 中的数据`复制`到 "模式空间" |
| G | 将 "保留空间" 中的数据`追加`到 "模式空间" |
| x | 将 "模式空间" 和 "保留空间" 中的数据交换 |
| n | 读取下一行数据`复制`到 "模式空间" |
| N | 读取下一行数据`追加`到 "模式空间" |
| :label | 为 t 或 b 指令定义1abel标签 |
| t label | 有条件跳转到标签(1abel)，如果没有 1abel ，则跳转到指令的结尾 |
| b label | 跳转到标签(1abel)，如果没有 label ，则跳转到指令的结尾 |
| y/源/目标/ | 以字符为单位将源字符转为为目标字符 |

</br>

## 二、常用实例

### 2.1 匹配范围

```sh
#行号范围：打印第3行到第5行
sed -n '3,5p' filename

#正则表达式匹配范围：从匹配start_pattern的行开始，到匹配end_pattern的行结束
sed -n '/start_pattern/,/end_pattern/p' filename

#命令组合：从第1行开始，到第一个空白行为止
sed -n '1,/^$/p' filename

#倒数行范围：从第1行开始，直到匹配end_pattern的行之前（使用!进行取反）
sed -n '1,/end_pattern/!p' filename

#指定行的倍数：打印所有奇数行（从第一行开始，步长为 2）
sed -n '1~2p' filename
```

### 2.2 增删改

#### 2.2.1 替换操作（s）

- 基础替换

```sh
#只替换文本中第一次出现的匹配项，并将结果输出到标准输出
sed 's/foo/bar/' filename

#只替换每行中第三次出现的匹配项
sed 's/foo/bar/3' filename

#只打印替换过的行
sed -n 's/foo/bar/p' filename

#编辑原文件，同时创建 filename.bak 备份
sed -i.bak 's/foo/bar/' filename

#忽略大小写进行替换
sed 's/foo/bar/i' filename

#全局替换
sed 's/foo/bar/g' filename

#全局替换，每行替换从第 2 次开始出现的匹配项
sed 's/foo/bar/2g' filename

```

- 组合替换

```sh
#替换并写入新文件：将替换过的行写入 output.txt
sed 's/foo/bar/w output.txt' filename

#结合标记符：在匹配的字符串后添加后缀
sed 's/foo/&.bak/' filename

#执行sed结果的命令（谨慎使用，可能导致安全风险）
sed 's/systemctl start/systemctl status/e' filename
echo "ls /tmp" | sed 's/ls/ls -l/e'

#行号范围：将第3行到第5行中的"foo"替换为"bar"
sed '3,5s/foo/bar/g' filename

#正则表达式匹配范围：从包含"start"的行开始，到包含"end"的行结束，替换"foo"为"bar"
sed '/start/,/end/s/foo/bar/g' filename

#命令组合：从第1行开始，到第一个空白行为止，替换"foo"为"bar"
sed '1,/^$/s/foo/bar/g' filename

#倒数行范围：从第1行开始，直到包含"end"的行之前，替换"foo"为"bar"
sed '1,/end/!s/foo/bar/g' filename

#指定行的倍数：替换所有奇数行中的"foo"为"bar"
sed '1~2s/foo/bar/g' filename
```

#### 2.2.2 更新操作（a\i\c\）

> a\,i\,c\ 分别表示在行下追加、行上插入和整行更新，字母符合后面 `\` 可以省略

##### 2.2.2.1 行下追加（a\）

```sh
#将 "this is a test line" 追加到含有 "hello" 行的下面
sed -i '/hello/a\this is a test line' filename

#在第 2 行之后插入 "this is a test line"
sed -i '2a\this is a test line' filename
```

##### 2.2.2.2 行上插入（i\）

```sh
#将 "this is a test line" 插入到含有 "librarookie" 的行上面
sed -i '/librarookie/i\this is a test line' filename

#在第 5 行之前插入 "this is a test line"
sed -i '5i\this is a test line' filename
```

##### 2.2.2.3 替换当前行（c\）

```sh
#将含有 "librarookie" 的行变成 "this is a test line"
sed -i '/librarookie/c\this is a test line' filename

#将第 5 行变成 "this is a test line"
sed -i '3c\this is a test line' filename
```

#### 2.2.3 删除操作（d）

```sh
#删除全文
sed -i 'd' filename

#删除第 2 行
sed -i '2d' filename

#删除最后一行
sed -i '$d' filename

#删除空白行
sed -i '/^$/d' filename

#以 # 号开头的行（删除注释）
sed -i '/^#/d' filename

#删除文件中所有开头是 test的行
sed -i '/^test/d' filename

#删除文件的第 2 行到 末尾所有行
sed -i '2,$d' filename
```

### 2.3 脚本文件（-f）

> sed脚本 scriptfile 是一个sed的命令清单，启动Sed时，以 -f 选项引导脚本文件名。Sed脚本规则如下：
> </br> 1. 在命令的末尾不能有任何空白或文本；
> </br> 2. 如果在一行中有多个命令，要用分号分隔；
> </br> 3. 以 # 开头的行为注释行，且不能跨行；

```sh
#这将按照 scriptfile.sed 文件中的命令来编辑 filename 文件
sed -f scriptfile.sed filename

#如果你不希望实际修改文件，可以添加 -n 标志和 p命令来打印结果而不是直接写入文件
sed -nf scriptfile.sed filename
```

scriptfile.sed 内容如下：

```sh
# 这是注释，会被sed忽略

# 替换文件中的第一行中的"old_string"为"new_string"
1s/old_string/new_string/

# 从第3行到第5行，替换"foo"为"bar"
3,5s/foo/bar/g

# 删除包含"delete_this_line"的行
/delete_this_line/d

# 在包含"insert_before"的行之前插入新行
/insert_before/i\
This is the new line to insert

# 在文件末尾添加一行
$ a\
This is the new line at the end of the file
```

### 2.4 标记操作

#### 2.4.1 已匹配字符串标记（&）

> 符合匹配条件字符串的标记，可以理解为匹配结果的变量名

```sh
#正则表达式 "\w\+" 匹配每一个单词，使用 [&] 替换它，& 对应于之前所匹配到的单词：
echo this is a test line | sed 's/\w\+/[&]/g'
[this] [is] [a] [test] [line]

# 将 hello 替换为 helloworld
sed 's/hello/&world/' filename
helloworld
```

#### 2.4.2 子串匹配标记（\1）

> 匹配给定样式的其中一部分：
> </br>1. `\(..\)` 用于匹配子串，对于匹配到的第一个子串就标记为 `\1`，依此类推匹配到的第二个结果就是 `\2`;
> </br>2. 未定义 `\(..\)` 时，效果等同于 `&` 标记;

```sh
#echo this is digit 7 in a number | sed 's/digit \([0-9]\)/\1/'
this is 7 in a number
#命令中 digit 7，被替换成了 7。样式匹配到的子串是 7。

#\(..\) 用于匹配子串。[a-z]+ 匹配小写字母，为第一个子串\1；[A-Z]+ 匹配大写字母，为第二个子串\2
echo "world HELLO" | sed 's/\([a-z]\+\) \([A-Z]\+\)/\2 \1/'
HELLO world

# HELLO 被标记为 \1，将
echo "hello world" | sed 's/\(hello\) world/\1 librarookie/'
hello librarookie
```

### 2.5 组合多个表达式（-e）

```sh
#1. 使用 -e 选项，指定多个 sed 表达式
sed -e '表达式' -e '表达式' filename

#2. 使用管道符 | ，对结果重复使用 sed 命令
sed '表达式' | sed '表达式' filename

#1. 在表达式中使用 ; 
sed '表达式; 表达式' filename
```

### 2.6 文件读写（r/w）

```sh
#1. 从文件读取（r）
#将文件 datafile 里的内容读取出来，显示在文件 filename 中匹配 test 的行下面
#如果匹配多行，则将文件 datafile 的内容，显示在文件 filename 中所有匹配 test 的行下面
sed -i '/test/r datafile' filename

#2. 写入新文件（w）
#将文件 filename 中所有匹配 test 的数据行，都写入新文件 newfile 里面
sed -n '/test/w newfile' filename

#将替换后的 filename 写入 newfile
sed 's/foo/bar/w newfile' filename
```

### 2.7 保留空间与模式空间

> 在 sed 编辑器中，有两个非常重要的概念：保留空间（hold space）和模式空间（pattern space）。

1. 模式空间（Pattern Space）

   - 模式空间是 sed 用来处理输入文本的地方。
   - 当 sed 读取输入文件的每一行时，它会将这一行放入模式空间，然后对模式空间中的内容执行指定的编辑命令。
   - 默认情况下，模式空间的内容在处理后被输出到标准输出（通常是屏幕）。
   - 模式空间的大小通常受限于系统内存，但通常足够处理单行文本。

2. 保留空间（Hold Space）

   - 保留空间是 sed 的第二个缓冲区，它允许 sed 在处理模式空间的内容时保存数据。
   - 保留空间可以用来存储模式空间中当前行的副本，或者用于在不同行之间传递数据。

#### 2.7.1 保持和获取（h/H/g/G）

```sh
#将任何包含 test 的行都被复制并追加到该文件的末尾
sed -e '/test/h' -e '$G' file

# -e '/test/h'
#1. 匹配 test 的行被找到后，将存入模式空间，
#2. h 命令将其复制并存入保留空间（保持缓存区的特殊缓冲区内）。
#
# -e '$G'
#1. 当到达最后一行（$）后，
#2. G 命令取出保留空间的行，然后把它放回模式空间中，且追加到现在已经存在于模式空间中的行的末尾。
#3. 在这个例子中就是追加到最后一行。
```

#### 2.7.2 保持和互换（h/x）

互换模式空间和保持缓冲区的内容。也就是把包含test与check的行互换：

```sh
sed -e '/test/h' -e '/check/x' file
```

### 2.8 打印奇数行或偶数行

```sh
#方法1：利用 n ，打印一行，隐藏一行
sed -n 'p;n' test.txt    #奇数行
sed -n 'n;p' test.txt    #偶数行

#方法2：利用步长 2 ，跳过非目标行
sed -n '1~2p' test.txt    #奇数行
sed -n '2~2p' test.txt    #偶数行
```

### 2.9 退出命令（q）

```sh
#打印完第10行后，退出sed
sed '10q' filename
```

</br>
</br>
