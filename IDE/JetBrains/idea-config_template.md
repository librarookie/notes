# IDEA 配置注释模板

</br>
</br>

## 新建类模板

> Ctrl + Shift + a  -->  File and Code Templates

```java
// 路径：File --> Settings --> Editor --> File and Code Templates
    将下面的模板加入 Files -> Class 
    或着 Includes -> File Header 中即可
```

```java
/**
 * @Author lc
 * @Description ${Description}
 * @Date ${DATE}
 */
```

</br>

## 类和方法模板

> Ctrl + Shift + a  -->  Live Templates

```java
// 路径：File --> Settings --> Editor --> Live Templates
    1. 安装上面两种方法，找到Live Templates（位置1）
    2. 找到By Default expand with（位置2），选择下拉框中的Enter选项
    3. 点击“+”号（位置3），首先选择Template Group，新建一个模板分组ybyGroup（相当于文件夹）
    4. 继续点击“+”号（位置3），选择Live Template，创建一个注释模版（下面以方法注释模板为例）
    5. 填入下面的参数：
        - Abbreviation：是使用模板的缩写，这里我们使用 *（方法注释）
        - Description：是这个模板的注释，方便后面注释选择
        - Template text：是添加具体的模板代码（位置5），注意这里是使用 $变量$
    6. 第一次创建时，点击底部的Define（位置6），然后勾选Java
    7. 最后点击 Edit variables（位置7），这会将$变量$ 动态赋值
```

![202208300926454](https://gitee.com/librarookie/picgo/raw/master/img/202208300926454.png "202208300926454")

- 类注释模板

    ```java
    **
    * @Author lc 
    * @Description $description$ 
    * @Date $date$ 
    */
    ```

- 方法注释模板（第一行 * 并不是缩进问题，全部复制即可）

    ```java
    *
     * @Author lc 
     * @Description: $description$ 
     * @Date: $date$ 
     * @Param: $params$ 
     * @Return: $returns$ 
     */
    ```

- Params 变量动态复制表达式

    ```java
    groovyScript("def result=''; def params=\"${_1}\".replaceAll('[\\\\[|\\\\]|\\\\s]', '').split(',').toList(); for(i = 0; i < params.size(); i++) {result+='' + params[i] + ((i < params.size() - 1) ? '\\n':'')}; return result", methodParameters())
    ```

</br>
</br>
  