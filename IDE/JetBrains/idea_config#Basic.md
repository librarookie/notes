# IDEA 常用配置

</br>

## 启动进入欢迎页（项目选择页），而非直接进入项目

> File > Settings > Appearance & Behavior > System Settings

```md
在 Startup/Shutdown 栏目处，默认勾选 "Reopen last project on startup"（在启动的时候打开上次的项目）
去掉勾选之后，点击确认即可
```

![202208300950071](https://gitee.com/librarookie/picgo/raw/master/img/202208300950071.png "202208300950071")

</br>

## 退出时，启用确认关闭的提示窗口，防止误操作关闭了当前的工作空间

> File > Settings > Appearance & Behavior > System Settings

```md
# 这个默认是开启的，如果你勾了 "Do not ask me again" ，退出就不会提醒了， 下面是开启操作
  在 Startup/Shutdown 栏目处，将Confirm application exit勾选上，应用确认即可
```

![202208300950811](https://gitee.com/librarookie/picgo/raw/master/img/202208300950811.png "202208300950811")

</br>

## 配置字符集

> Ctrl + Shift + a  -->  File Encodings

```md
# 路径： File --> Settings --> Editor --> File Encodings
  - Global Encoding     # 全局编码： UTF-8
  - Project Encoding    # 项目编码： UTF-8
  - Default encoding for properties files   # properties 文件编码： UTF-8
  - Transparent native-to-ascii conversion  # 是否转换成 ASCII 码保存：建议勾上，团队开发时就和团队保持一致
```

![202208300951259](https://gitee.com/librarookie/picgo/raw/master/img/202208300951259.png "202208300951259")

</br>

## 配置代码提示忽略大小写

> Ctrl + Shift + a  -->  Code Completion

```md
# 路径： File --> Settings --> Editor --> General --> Code Completion
  取消勾选 Match case
# 老版本将 “Case sensitive completion” 设置为 "None"
```

![202208300951936](https://gitee.com/librarookie/picgo/raw/master/img/202208300951936.png "202208300951936")

![202208300951152](https://gitee.com/librarookie/picgo/raw/master/img/202208300951152.png "202208300951152")

</br>

## 自动导入包去除星号（import xxx.*）

> Ctrl + Shift + a  -->  Code Style

```md
# 路径： File --> Settings --> Editor --> Code Style --> Java --> Scheme Default --> Imports
  ① 将 Class count to use import with "*" 改为 99（导入同一个包的类超过这个数值自动变为 * ）
  ② 将 Names count to use static import with "*" 改为 99（同上，但这是静态导入的）
  ③ 将 Package to Use import with "*" 删掉默认的这两个包（不管使用多少个类，只要在这个列表里都会变为 * ）
```

Tips：Scheme Default 是针对全局的，你也可以只修改某个 Project 的

![202208300952790](https://gitee.com/librarookie/picgo/raw/master/img/202208300952790.png "202208300952790")

</br>

## 扩展

- 关闭 IDEA 自动更新: <https://www.cnblogs.com/librarookie/p/14111237.html>
- IDEA 配置注释模板: <https://www.cnblogs.com/librarookie/p/14741738.html>
- IDEA 配置背景颜色: <https://www.cnblogs.com/librarookie/p/14766448.html>

</br>
</br>
