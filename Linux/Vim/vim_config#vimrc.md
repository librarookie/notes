# Vim 环境配置 -- vimrc 配置

</br>
</br>

> Vim 是一款类 Unix 系统下的自由文本编辑器，源自 Vi 编辑器（Vi Improved），并在Vi的基础上改进和增加了很多特性，使用下面这些配置项可以提高编辑效率和代码可读性，但具体的配置还需要根据个人习惯和需求来进行选择。

</br>

## 一、临时配置

vim 打开文件后，在命令模式下，输入冒号(:)加对应的配置项命令，如显示行号:

```sh
: set number
#或缩写
: set nu
```

## 二、永久配置

1. 配置范围

    用户级配置
    - 更新 vim 的用户配置文件，文件位置：`~/.vimrc` 或 `~/.vim/vimrc`
    - 文件不存在，则手动创建即可

    系统级配置
    - 方法一：更新 vim 系统配置文件，将配置添加到配置文件末尾，文件位置：`/etc/vimrc`
    - 方法二：在配置文件中添加子文件配置，然后将配置添加到子文件中，如：

        ```sh
        sudo tee -a /etc/vimrc <<-EOF
        
        " Source a global configuration file if available
        if filereadable("/etc/vimrc.local")
            source /etc/vimrc.local
        endif

        EOF
        ```

        - filereadable()：检查文件是否存在且可读
        - source：加载指定的 Vim 脚本文件
        - 用途：允许系统管理员在 /etc/vimrc.local 中添加自定义配置，而不直接修改主 vimrc

2. 常用配置项

    根据个人习惯和需求来进行选择配置项，并添加至 vimrc 配置文件

    ```vimrc
    syntax on     " 开启语法高亮，可以让不同的代码元素以不同的颜色显示
    set number    " nu: 显示行号
    set relativenumber   " rnu: 显示相对行号，可以方便地计算行数距离和移动行光标，如：3j
    set expandtab     " et: 将输入的 Tab 键转换为空格
    set tabstop=4     " ts: 设置 Tab 键的宽度为 4 个空格（默认为 8）
    set autoindent    " ai: 启用自动缩进功能，当前行的缩进会基于上一行的缩进自动调整
    set smartindent   " si: 启动智能缩进，分析上下文自动调整缩进
    set shiftwidth=4    " sw: 设置自动缩进时使用 4 个空格
    set incsearch       " is: 启用增量搜索（Incremental Search）, 在用户输入搜索字符串时动态显示匹配结果
    set ignorecase      " ic: 搜索时忽略大小写
    set smartcase       " scs: 搜索时区别大小写，和ic一起配置后，搜全小写匹配全部结果，搜大写只匹配大写结果
    autocmd BufWritePre * :%s/\s\+$//e    " 去掉行末空格；自动命令（autocmd）BufWritePre，意思是在写入缓冲区之前执行该命令

    set cursorline      " 显示当前行
    set cursorcolumn    " 显示当前列，cursorline 和 cursorcolumn 都启用的果类似 WPS表格 中的阅读模式（十字）
    set mouse=a     " 允许使用鼠标，启用后可以用鼠标来定位光标位置了
    set backupdir=~/.vim/backup    " 设置备份文件目录（默认为当前目录）
    ```

    - 配置项第一部分推荐配置，第二部分按需选择配置
    - 配置文件 vimrc 中的双引号（"）：表示注释从双引号开始到行末的所有内容

</br>
</br>
