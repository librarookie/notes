# gzip 介绍和使用

</br>
</br>

## 用法

> gzip [OPTION]... [FILE]...

</br>

## 常用参数

- `-d` `--decompress` 解压
- `-c` `--stdout` 保留原始文件，把压缩/解压流重定向到新文件（如： `gzip -c aa > aa.gz`）
- `-l` `--list` 列出压缩文件信息，并不解压
- `-r` `--recursive` 对目录进行递归操作
- `-t` `--test` 测试压缩文件的完整性
- `-v` `--verbose` 冗长模式
- `-num` num为压缩效率，是一个介于`1~9`的数值，预设值为“`6`”，指定愈大的数值，压缩效率就会愈高；
  - `-1` `--fast`  最快压缩方法（低压缩比）
  - `-9` `--best`  最慢压缩方法（高压缩比）

</br>

## 栗子

- 把 test目录下的每个文件压缩成.gz文件
    > gzip test/*

- 把上例中每个压缩的文件解压，并列出详细的信息
    > gzip -dv test/*

- 详细显示test中每个压缩的文件的信息，并不解压
    > gzip -l test/*

- 压缩一个tar备份文件，此时压缩文件的扩展名为.tar.gz
    > gzip -r log.tar

- 递归的压缩目录
    > gzip -rv test

  这样，所有test下面的文件都变成了*.gz，目录依然存在只是目录里面的文件相应变成了*.gz.这就是压缩，和打包不同。因为是对目录操作，所以需要加上-r选项，这样也可以对子目录进行递归了。

- 递归地解压目录

    > gzip -dr test

- 保留原始文件，把压缩/解压流重定向到新文件

    > gzip -c aa > aa.gz </br>
    > gzip -dc bb.gz > bb

</br>
</br>

Via

- <https://wangchujiang.com/linux-command/c/gzip.html>
