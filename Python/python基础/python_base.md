# Python 基础语法

</br>
</br>

## 基础语法

### 注释

* 单行注释

  ```python
  # 这是Python 单行注释内容
  ```

* 多行注释

  ```python
  '''
      这是Python 多行注释
      三个英文单引号
  '''
  或者
  """
      这也是Python 多行注释
      三个英文双引号
  """
  ```

  Tips: python 中 `'` 和 `"` 效果相同;

### print 行操作

* 换行操作

  ```python
  # eg. 多行打印
  # “;” 表示命令结束
    print("打印在第 1 行"); print("打印在第 2 行"); print("打印在第 3 行")
  ```

* 续行操作

  ```Python
  # eg. 多行打印 
  # “;” 表示命令结束，“\” 表示下一行继续， “>>>” 表示Python交互模式， “...” 表示接上面继续
  >>> print("打印在第 1 行");\  # 回车
  ... print("打印在第 2 行");\  # 回车
  ... print("打印在第 3 行")    # 回车
  ```

### 循环

* while 循环

  ```Python
  while 循环条件:
    循环体

  # 死循环
  while True:
    循环体
    if 退出条件:
      break
  ```

* for 循环

  ```python
  # for 循环；
  for 变量 in 可迭代对象:
  
  """
      for + range 循环；
      range： 范围，产生一个范围的整数；
  """
  # 0~5，默认开始 0，默认间隔 1；
  for item in range(5): 
    print(item) # 0 1 2 3 4
  # 1~5，默认间隔 1；
  for item in range(1, 5): 
    print(item) # 1 2 3 4
  # 1~9，间隔 2；
  for item in range(1, 9, 2): 
    print(item) # 1 3 5 7


  break      # 完全结束一个循环，跳出循环体
  continue    # 中止此次循环，继续下一个循环
  ```

### 字符操作

* 解码&编码

  [字符百科](https://unicode-table.com/cn/ "传送阵")

  ```python
  """
      ord()  解码，字 --> 数
      chr()  编码，数 --> 字
  """
  # 编码:字 --> 数
  number = ord("釹")
  print(number)   # 37369

  # 解码:数 --> 字
  char = chr(37369)
  print(char)     # 釹
  ```

* 字符串格式化

  ```python
  """
      定义:生成一定格式的字符串
      基础语法:
          "固定格式" % (变量1,变量2...)
        占位符(常用类型码):
          %d  整数
          %s  字符串
          %f  小数
        辅助格式
          %.2d  整数使用2位,不足用0填充
          %.2f  小数使用2位,不足用0填充
  """
      jin, liang = 5, 8
    # 拼接字符串
      print(str(jin) + "斤零" + str(liang) + "两")  # 5斤零8两
    # 字符串格式化
      print("%d斤零%d两" % (jin, liang))  # 5斤零8两

  """
      python 3.6+ 字面量格式化字符串 f-string
      f-string 格式化字符串以 f 开头，后面跟着字符串，字符串中的表达式用大括号 {} 包起来，它会将变量或表达式计算后的值替换进去;
  """
      name = "World"
      print(f"Hello {name}")    # Hello World，替换变量
      print(f"{1 + 2}")     # 3，使用表达式
    # 在 Python 3.8 的版本中可以使用 = 符号来拼接运算表达式与结果
      print(f"{1 + 4 = }")    # 1 + 4 = 5
  ```

* 索引

  ```python
  """
    容器名[整数]
    定位某个位置的数据
  """
  message = "你好世界"
  print(message[0])    # 你
  print(message[-3])    # 好
  ```

  ![202208241700892](https://gitee.com/librarookie/picgo/raw/master/img/202208241700892.png "202208241700892")

* 切片

  ```python
  """
      # 容器[整数: 整数: 整数]
      list[start: end: step]    # 范围： [start, end), 间隔：step
      定位多个数据
  """
  # 为了生成整数
  # for item in range(1, 5, 1):     # [1, 5)
  #     print(item)
  message = "我是齐天大圣孙悟空"

  print(message[1: 5: 1])    # [1, 5) 是齐天大
  # 注意:间隔默认为 1
  print(message[1: 5])    # [1, 5) 是齐天大
  # 注意:开始默认为头
  print(message[: 5])    # [start, 5) 我是齐天大
  # 注意:结束默认为尾
  print(message[:])    # [start, end] 我是齐天大圣孙悟空

  # 特殊1: 没有越界
  print(message[:100])    # [start, end) 我是齐天大圣孙悟空
  # 特殊2: step=-1表示反转
  print(message[::-1])    # [end, start] 空悟孙圣大天齐是我
  ```

  ![202208241701909](https://gitee.com/librarookie/picgo/raw/master/img/202208241701909.png "202208241701909")

## 常用函数

* 字符串处理

  ```python
  title()    # 将字符串转换成首字母大写
  upper()    # 将字符串转换成全部大写
  lower()    # 将字符串转换成全部小写
  strip()    # 去除字符串两端的空白, 如 “ Hello ” -> "Hello", "\n\tHello\n\t" -> "Hello"
    rstrip()   # 只去除字符串末尾的空白,如 “Hello  ” -> “Hello”, " Hello " -> " Hello"
    lstrip()   # 只去除字符串前面的空白,如 “  Hello” -> “Hello”, " Hello " -> "Hello "
  ```

## list 基本操作

* 创建

  ```python
  listName = list(iterable)     # iterable: 可迭代对象
    or
  listName = [element, element ...]
  ```

* 添加

  ```python
  # 新元素添加在最后面
  listName.append(element)
  ```

* 插入

  ```python
  # 新元素插入在下标index，元素向后移动
  listName.insert(index, element)
  ```

* 删除

  ```python
  # 1. 移除
  listName.remove(element)

  # 2. 根据定位删除 del 容器名[索引或者切片]
  ## 删除第一个元素
  del listName[0]
  ## 根据切片删除，删除开始到下标2 [0, 2) 
  del listName[: 2]
  ```

* 倒序

  ```python
  # 将list中的元素倒序排布
  listName.reverse()
  ```

* 清空

  ```python
  # 清空list中所有元素
  listName.clear()
  ```

* 读取

  ```python
  listName[index]
  ```

* 修改

  ```python
  # 当index < 0 时，从最后开始取
  listName[index] = element
  ```

* 切片

  ```python
  # 当step < 0 时，从最后开始取
  listName[start: end: step]
  ```

  [Python3 字符串篇](https://www.runoob.com/python3/python3-string.html "菜鸟驿站")

* 栗子

  ```python
  hello_list = ["你", "好", "，", "世", "界"]
  hello_list = list("你好，世界")
  print(hello_list)          # ['你', '好', '，', '世', '界']

  hello_list.append("吖")
  print(hello_list)          # ['你', '好', '，', '世', '界', '吖']

  hello_list(2, "啊")
  print(hello_list)          # ['你', '好', '啊', '，', '世', '界', '吖']

  hello_list.remove("好")
  print(hello_list)        # ['你', '啊', '，', '世', '界', '吖']

  del hello_list[0]
  print(hello_list)        # ['啊', '，', '世', '界', '吖']

  del hello_list[: 2]
  print(hello_list)        # ['世', '界', '吖']

  hello_list.reverse()
  print(hello_list)        # ['吖', '界', '世']

  hello_list.clear()
  print(hello_list)        # []    
  ```

</br>
</br>
