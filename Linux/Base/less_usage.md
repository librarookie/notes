# less 介绍与使用

</br>
</br>

## 概念

> less 与 more 类似，less 可以随意浏览文件，支持翻页和搜索，支持向上翻页和向下翻页。而使用 more 命令浏览文件内容时，只能不断向后翻看。

</br>

## 介绍

- 用法:

    `less [OPTION]... [FILE]...`

- 常用参数:

  1. 常用选项及含义

      | Key | Value |
      | :--: | ---- |
      | -N | 显示每行的行号。 |
      | -S | 行过长时将超出部分舍弃。 |
      | -e | 当文件显示结束后，自动离开。 |
      | -g | 只标志最后搜索到的关键同。 |
      | -Q | 不使用警告音。 |
      | -i | 忽略搜索时的大小写。 |
      | -m | 显示类似 more 命令的百分比。 |
      | -f | 强迫打开特殊文件，比如外围设备代号、目录和二进制文件。 |
      | -s | 显示连续空行为一行。 |
      | -b | <缓冲区大小> 设置缓冲区的大小。 |
      | -o [file]  | 将 less 输出的内容保存到指定文件中。 |
      | -x [num] | 将【Tab】键显示为规定的数字空格。 |

  2. 交互指令及功能

      | Key | Value |
      | :--: | ---- |
      | /pattern | 向下搜索 “pattern” 的功能。 |
      | ?pattern | 向上搜索 “pattern” 的功能。 |
      | n | 重复*前一个搜索（与 / 成 ? 有关）。 |
      | N | 反向重复前一个搜索（与 / 或 ? 有关）。 |
      | h \| H | 显示帮助界面。 |
      | q \| Q \| ZZ | 退出 less 命令。 |
      | G | 移动至 “首行”。 |
      | g | 移动至 “尾行”。 |
      | j \| e | 向下移动一行。 |
      | k \| y | 向上移动一行。 |
      | d \| Ctrl-d | 向下移动半页。 |
      | u \| Ctrl-u | 向上移动半页。 |
      | f \| Ctrl-f \| z | 向下移动一页。 |
      | b \| Ctrl-b \| w | 向上移动一页。 |
      | v | 使用系统预设编的文本编辑器编辑当前文件。 |
      | F | 永远向前；像 "tail -f"。 |
      | m letter | 用 letter 标记当前顶行。 |
      | 'letter | 转到一个先前标记 letter 的位置。 |
      | '' | 转到之前的位置。 |
      | ESC-M letter | 清除一个标记。 |

      Tips: Ubuntu的预设文本编辑器是 `nano`，可通过 `sudo update-alternatives --config editor` 命令，然后指定编辑器来指定预设编辑器；

      ![20220721094030](https://gitee.com/librarookie/picgo/raw/main/images/md_20220721094030.png)

</br>

## 栗子

1. 查看文件

    `less log1.log`

    Tips:
    - 可以按大写 `F`，就会有类似 `tail -f` 的效果，读取写入文件的最新内容， 按 `ctrl+C` 停止。
    - 可以按 `v` 进入编辑模型， `shift+ZZ` 保存退出到 less 查看模式。
    - 使用参数 `N` 可以显示行号；

2. 分页显示“进程信息”或“历史记录”

    `ps -ef | less`
    `history | less`

3. 浏览多个文件

    `less log2.txt log3.txt`

    Tips:
    - `:n`: 切换到 log2.txt
    - `:p`: 切换到 log3.txt
    - `:e log3.txt` 打开新文件log3.txt

</br>

## less 参数大全

### UMMARY OF LESS COMMANDS(Less命令的摘要)

> 标有*的命令可以在前面加上一个数字，N。</br>
> 括号中的注释表示如果给定了N的行为。</br>
> 前面有一个圆点的键表示Ctrl键，因此^K是ctrl-K。</br>

```md
h H                   显示此帮助。
q :q Q :Q ZZ          退出。
```

</br>

### MOVING(移动)

```md
e  ^E  j  ^N  CR  *  前进一行（或_N行）。
y  ^Y  k  ^K  ^P  *  后退一行（或_N行）。
f  ^F  ^V  SPACE  *  前进一个窗口（或_N行）。
b  ^B  ESC-v      *  后退一个窗口（或_N行）。
z                 *  向前一个窗口（并将窗口设置为_N）。
w                 *  后退一个窗口（并将窗口设置为_N）。
ESC-SPACE         *  前进一个窗口，但不要停在文件的末端。
d  ^D             *  前进一个半窗口（并将半窗口设置为_N）。
u  ^U             *  后退一个半窗口（并将半窗口设置为_N）。
ESC-)  RightArrow *  向右移动半个屏幕宽度（或_N个位置）。
ESC-(  LeftArrow  *  左半屏宽度（或_N个位置）。
ESC-}  ^RightArrow   向右到最后一列显示。
ESC-{  ^LeftArrow    向左到第一栏。
F                    永远向前；像 "tail -f"。
ESC-F                像F一样，但在找到搜索模式时停止。
r  ^R  ^L            重新绘制屏幕。
R                    重新绘制屏幕，丢弃缓冲输入。

        ---------------------------------------------------
        默认的 "窗口 "是屏幕的高度。
        默认的 "半窗 "是屏幕高度的一半。
```

</br>

### SEARCHING(检索)

```md
/pattern          *  向前搜索（_N-th）匹配的行。
?pattern          *  向后搜索(第_N次)匹配的行。
n                 *  重复之前的搜索（第_N次出现）。
N                 *  以相反的方向重复之前的搜索。
ESC-n             *  重复先前的搜索，跨越文件。
ESC-N             *  重复先前的搜索，反方向搜索，并跨越文件。
ESC-u                撤销（切换）搜索高亮显示。
ESC-U                清除搜索高亮显示.
&pattern          *  只显示匹配行。

        ---------------------------------------------------
        一个搜索模式可以以下列一项或多项开始。
        ^N 或 !  搜索不匹配的行。
        ^E 或 * 搜索多个文件（通过文件末尾）。
        ^F 或 @ 从第一个文件（对于 /）或最后一个文件（对于 ?）开始搜索。
        ^K 突出显示匹配的文件，但不移动（保留位置）。
        ^R 不使用常规表达式。
        ^W 如果没有找到匹配，则进行WRAP搜索。
```

</br>

### JUMPING(跳转)

```md
g  <  ESC-<       *  转到文件的第一行（或第N行）。
G  >  ESC->       *  转到文件的最后一行（或第N行）。
p  %              *  转到文件的开头（或文件的N%）。
t                 *  转到（N-th）下一个标签。
T                 *  转到前一个标签（N-th）。
{  (  [           *  找出闭合括号 } ) ].
}  )  ]           *  查找大括号 { ( [.
ESC-^F <c1> <c2>  *  查找封闭括号 <c2>.
ESC-^B <c1> <c2>  *  查找开放括号 <c1>。

        ---------------------------------------------------
        每条 "查找括号" 命令都会前进到与顶行中（第N个）开放括号相匹配的括号处 
            匹配顶行中的（第N个）开放括号。
        每条 "查找开括号" 命令都会向后移动到开括号 
            匹配底行的（第N个）封闭括号。


m<letter>            用<letter>标记当前顶行。
M<letter>            用<letter>标记当前的底行。
'<letter>            转到一个先前标记的位置。
''                   转到之前的位置。
^X^X                 与'相同。
ESC-M<letter>        清除一个标记。

        ---------------------------------------------------
        一个标记是任何大写或小写的字母。
        某些标记是预定义的：
            ^ 表示文件的开始
            $ 表示文件的结束
```

</br>

### CHANGING FILES(改变文件)

```md
  :e [file]            检查一个新文件。
  ^X^V                 与 :e 相同。
  :n                *  检查命令行中的（N-th）下一个文件。
  :p                *  检查命令行中的前一个（N个）文件。
  :x                *  从命令行中检查第一个（或第N个）文件。
  :d                   从命令行列表中删除当前文件。
  =  ^G  :f            打印当前文件名。
```

</br>

### MISCELLANEOUS COMMANDS(其他命令)

```md
  -<flag>              切换一个命令行选项[见下面的 OPTIONS]。
  --<name>             按名称切换一个命令行选项。
  _<flag>              显示一个命令行选项的设置。
  __<name>             按名称显示一个选项的设置。
  +cmd                 每次检查一个新文件时，执行 less cmd。

  !command             执行带有 $SHELL 的 shell命令。
  |Xcommand            在当前位置和 标记X 之间管文件到 shell命令。
  s file               将输入内容保存到文件中。
  v                    用 $VISUAL 或 $EDITOR 编辑当前文件。
  V                    打印 "less "的版本号。
```

</br>

### OPTIONS(选项)

> 大多数选项可以在命令行上改变。</br>
> 或者在 less 中使用 - 或 -- 命令来改变。</br>
> 选项可以以两种形式之一给出：要么是以"-"开头的单个字符，要么是以"--"开头的名称。</br>

```md
  -?  ........  --help
                  显示帮助（来自命令行）。
  -a  ........  --search-skip-screen
                  搜索跳过当前屏幕。
  -A  ........  --SEARCH-SKIP-SCREEN
                  搜索从目标行后开始。
  -b [N]  ....  --buffers=[N]
                  缓冲区的数量。
  -B  ........  --auto-buffers
                  不要自动为管道分配缓冲区。
  -c  ........  --clear-screen
                  通过清除而不是滚动来重新绘制。
  -d  ........  --dumb
                  哑巴终端。
  -D xcolor  .  --color=xcolor
                  设置屏幕颜色。
  -e  -E  ....  --quit-at-eof  --QUIT-AT-EOF
                  在文件结束时退出。
  -f  ........  --force
                  强制打开非常规文件。
  -F  ........  --quit-if-one-screen
                  如果整个文件适合在第一屏幕上显示，则退出。
  -g  ........  --hilite-search
                  只突出最后一个匹配的搜索。
  -G  ........  --HILITE-SEARCH
                  不突出显示任何匹配的搜索。
  -h [N]  ....  --max-back-scroll=[N]
                  向后滚动的限制。
  -i  ........  --ignore-case
                  在不包含大写字母的搜索中忽略大小写。
  -I  ........  --IGNORE-CASE
                  忽略所有搜索中的大小写。
  -j [N]  ....  --jump-target=[N]
                  目标行的屏幕位置。
  -J  ........  --status-column
                  在屏幕的左边缘显示状态栏。
  -k [file]  .  --lesskey-file=[file]
                  使用一个lesskey文件。
  -K  ........  --quit-on-intr
                  响应ctrl-C，退出less。
  -L  ........  --no-lessopen
                  忽略 LESSOPEN 环境变量。
  -m  -M  ....  --long-prompt  --LONG-PROMPT
                  设置提示样式。
  -n  -N  ....  --line-numbers  --LINE-NUMBERS
                  不使用行数。
  -o [file]  .  --log-file=[file]
                  拷贝到日志文件（仅标准输入）。
  -O [file]  .  --LOG-FILE=[file]
                  拷贝到日志文件（无条件覆盖）。
  -p [pattern]  --pattern=[pattern]
                  从模式开始（来自命令行）。
  -P [prompt]   --prompt=[prompt]
                  定义新的提示。
  -q  -Q  ....  --quiet  --QUIET  --silent --SILENT
                  让终端的铃声安静下来。
  -r  -R  ....  --raw-control-chars  --RAW-CONTROL-CHARS
                  输出 "原始 "控制字符。
  -s  ........  --squeeze-blank-lines
                  挤掉多个空行。
  -S  ........  --chop-long-lines
                  切断（截断）长行，而不是包裹。
  -t [tag]  ..  --tag=[tag]
                  找到一个标签。
  -T [tagsfile] --tag-file=[tagsfile]
                  使用一个备用的标签文件。
  -u  -U  ....  --underline-special  --UNDERLINE-SPECIAL
                  改变对后缀的处理。
  -V  ........  --version
                  显示 "less "的版本号。
  -w  ........  --hilite-unread
                  突出显示转屏后的第一个新行。
  -W  ........  --HILITE-UNREAD
                  突出显示任何前移后的第一个新行。
  -x [N[,...]]  --tabs=[N[,...]]
                  设置制表符的位置。
  -X  ........  --no-init
                  不使用 termcap init/deinit 字符串。
  -y [N]  ....  --max-forw-scroll=[N]
                  向前滚动的限制。
  -z [N]  ....  --window=[N]
                  设置窗口的大小。
  -" [c[c]]  .  --quotes=[c[c]]
                  设置外壳引号字符。
  -~  ........  --tilde
                  不在文件结尾处显示蒂尔德。
  -# [N]  ....  --shift=[N]
                  设置水平滚动量（0=二分之一屏幕宽度）。
                --file-size
                  自动确定输入文件的大小。
                --follow-name
                  如果输入文件被重新命名，F命令会改变文件。
                --incsearch
                  在输入每个模式字符时搜索文件。
                --line-num-width=N
                  将-N行号字段的宽度设置为N个字符。
                --mouse
                  启用鼠标输入。
                --no-keypad
                  不发送termcap键盘初始/退出字符串。
                --no-histdups
                  从命令历史中删除重复的命令。
                --rscroll=C
                  设置用于标记截断行的字符。
                --save-marks
                  在调用less的过程中保留标记。
                --status-col-width=N
                  将-J状态栏的宽度设置为N个字符。
                --use-backslash
                  后面的选项使用反斜杠作为转义符。
                --use-color
                  启用彩色文本。
                --wheel-lines=N
                  每点击一次鼠标滚轮，就会移动N行。
```

</br>

### LINE EDITING(行编辑)

> 这些键可以用来编辑正在输入的文本</br>
> 在屏幕底部的 "命令行 "上编辑文本。</br>

```md
 RightArrow ..................... ESC-l ... 将光标向右移动一个字符。
 LeftArrow ...................... ESC-h ... 将光标向左移动一个字符。
 ctrl-RightArrow  ESC-RightArrow  ESC-w ... 将光标向右移动一个字。
 ctrl-LeftArrow   ESC-LeftArrow   ESC-b ... 将光标向左移动一个字。
 HOME ........................... ESC-0 ... 将光标移至行首。
 END ............................ ESC-$ ... 将光标移至行尾。
 BACKSPACE ................................ 删除光标左边的字符。
 DELETE ......................... ESC-x ... 删除光标下的字符。
 ctrl-BACKSPACE   ESC-BACKSPACE ........... 删除光标左侧的单词。
 ctrl-DELETE .... ESC-DELETE .... ESC-X ... 删除光标下方的字。
 ctrl-U ......... ESC (MS-DOS only) ....... 删除整行。
 UpArrow ........................ ESC-k ... 检索前一个命令行。
 DownArrow ...................... ESC-j ... 检索下一个命令行。
 TAB ...................................... 完成文件名和循环。
 SHIFT-TAB ...................... ESC-TAB   完成文件名和反向循环。
 ctrl-L ................................... 完成文件名，列出所有文件。
```

</br>
</br>
