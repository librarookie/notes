# Vim 文本替换介绍与使用

</br>
</br>

## 格式

- 用法

    `:[range]s/from/to/[flags]`

    tips: `[]` 表示该内容可选

- 参数

  - `from` 需要替换的字符串（可以是正则表达式）
  - `to` 替换后的字符串

  - `range` 作用范围

      ```sh
      空      # 默认为光标所在的行
      .       # 光标所在的行
      n       # 第 n 行（1表示第 1行，10表示第 10行），可使用:set nu 显示vim行号
      $       # 最后一行
      n,m     # n～m 行（22,33表示 22～33行）
      %       # 所有行（与 1,$ 等价）
      ```

      Tips: 上面的所有 `range` 都可以组合起来使用；表示方法都可以通过 `+、-` 操作来设置相对偏移量；且都可以套入 `n,m` 格式来设置范围，如：

    - `.+1` - 当前光标所在行的下面一行；
    - `$-1` - 倒数第二行；
    - `1,.` - 第1行 到 当前行；
    - `.,$` - 当前行 到 最后一行；
    - `1,$` - 第1行 到 最后一行（或者用符号 `%` 表示）；
    - `.+1,$-1` - 光标行下一行 到 倒数二行；

  - `flags` 替换标记

      ```sh
      空    # 替换第一个匹配项
      c     # confirm，每次替换前都会询问
      e     # 不显示error
      g     # globe，不询问，整个替换
      i     # ignore，即不区分大小写（默认为大小写敏感即I）
      &     # 重复使用最后的参数（效果和 g 类似）
      n     # 不会替代任何东西（提示执行该操作所影响的行数）
      ```

    Tips: 上面的所有 `flags` 都可以组合起来使用，如：

    - `gc` 表示匹配范围内全部替换，并且每次替换前都会`询问`；
    - `gi` 表示匹配范围内全部替换，并且`不区分`大小写；
    - `gin` 表示`不替换`，并且提示匹配范围中`不区分`大小写所影响的行数；

</br>

## 实例

![20220401113807](https://gitee.com/librarookie/picgo/raw/main/images/20220401113807.png "20220401113807")

### 图例

1. `:s/javascript/python/g`
   - 在当前行，用python替换javascript
   - `g` 标志表示全局

2. `:%s/css/sass/g`
   - 替换全局内容

3. `:5,12s/dev/pro/g`
   - 替换 第5 至 12行 的内容

4. `:.,+2s/bug/feature/g`
   - 对`当前行（.）`和`下两行（+2）`分别进行修改

5. `:g/^review/s/needs/donw/g`
   - 将每行开始为'review'的'needs'改为'donw'
   - `:g/review/s/needs/donw/g`
   - 将存在'review'的每行'needs'改为'donw'

6. `:%s/charome/firefox/gc`
   - 全局替换，每次替换前`询问`

7. `:%s/text/Editor/gi`
   - 全局替换，并且`忽略`关键字大小写

8. `:%s/\<static\>/dynamic/g`
   - 只改变完全匹配的`整个单词`

9. `:%s/remember/me/&`
   - 重复使用最后的参数（效果和 g 类似）

10. `:%s/remember/me/n`
    - 这个命令并`不替代`任何东西。它告诉我们，如果我们运行这个命令，会有多少个出现的词受到影响

### 进阶

1. 分隔符转换（几乎所有符号都可）

   - 将网址中的`/`替换成 `\`（\需要转义）
     - `:%s-/-\\-g`
     - `:%s#/#\\#g`

2. 特殊符号转义

   - 将所有的`.`替换成`0`
     - `:%s/\./0/g`

3. 替换正则选中内容

   - 日期替换（将所有日期替换为2022-4-1）
     - `:%s/[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}/2022-4-1/g`

4. 变量暂存并使用

   - 将所有 `hello world` 加上 `{}` 号
     - `:%s/\(hello world\)/{\1}/g`
   - 将所有日期加上`''`号
     - `:%s/[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}/'\1'/g`

      tips: 
      - `[0-9]` 表示 0 到 9 之间的任一个数字，这是正则中表示数字集合的标准写法。
      - `{n}` 表示将此符号前面的元素重复 n 遍，所以 [0-9]{4} 就表示一个四位数的数字。
      - 如果在匹配方案中用到了`()`，则表示要`暂存括号中所匹配到的内容`，而 `\1` 表示`替换为暂存的内容`（如果存在多个括号组，则后面要通过编号来依次对应，如 \1、\2、\3 等）

</br>
</br>