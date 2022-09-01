# Python-print 打印不换行展示

</br>
</br>

## print 介绍

> print() 有两个比较重要的可选参数，一个是 `end` 一个是 `sep`，分别表示结束符 和 分隔符

- `end`: 指定结束符（默认 `\n`）
- `sep`: 指定分隔符（默认空格）
- print() 打印中支持常用制表符, 如 `\t`, `\n`

    ```py
    # 默认样式
    print(end='\n'， sep=' ')
    ```

print() 函数中默认 `end='\n'`，所以会自动换行;

</br>

## 不换行方案

- Python 2
  - 在 print 语句的末尾加上一个逗号，如 `print "Hello World",`

- Python 3
  - 把参数 `end` 设置成你想要的就行了，如 `print("Hello World", end="")`

</br>

## 栗子

```py
# end 在上面已经有介绍了，下面介绍 sep 

print('cats', 'dogs', 'mice')   
输出：  cats dogs mice

print('cats', 'dogs', 'mice', sep=',')
输出：  cats,dogs,mice

# 上述就是用的 ',' 替换掉了分隔符 ,当然你也可以用于替换成其他你想要的符号，这个功能有时候会比较有用

# 譬如2019-10-01是我们祖国70周年
print('2019','10','01', sep='-')
输出：  2019-10-01
```

</br>
</br>

Via

- <https://www.cnblogs.com/tinglele527/p/11540232.html>
