# Oracle JDK 下载配置和验证

</br>
</br>

## 下载

### 解决官网下载JDK需要登录Oracle账号问题（JDK 8）

1. 免账号下载链接：

    - <http://www.codebaoku.com/jdk/jdk-index.html>
    - <https://www.injdk.cn/>
    - <https://github.com/frekele/oracle-java/releases>

2. JDK 1.8 官网下载地址：

    - <https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html>

3. 老版本下载地址：

    - <https://www.oracle.com/java/technologies/oracle-java-archive-downloads.html>

### Oracle账号

1. 账号方案一：找到一个Oracle账号（亲测有效）

    ```py
    账号：2696671285@qq.com
    密码：Oracle123
    ```

    账号来源：<https://blog.csdn.net/qq_41264674/article/details/89715321>

2. 账号方案二：Oracle账号分享地址

   - <http://www.codebaoku.com/jdk/jdk-oracle-account.html>
   - <http://bugmenot.com/view/oracle.com>

</br>

## 环境配置

### 环境变量说明

- `JAVA_HOME`：配置JDK根目录，指向JDK的安装目录；
  - Eclipse /NetBeans /Tomcat等软件通过搜索JAVA_HOME变量来找到并使用安装好的JDK

- `PATH`：配置JDK的bin目录，指定命令搜索路径；
  - 在中执行命令时，它会到PATH变量所配置的路径中找相应的命令程序

- `CLASSPATH`：配置.（点）和JDK的lib目录中的 dt.jar、tools.jar，指定类搜索命令；
  - JVM就通过CLASSPATH变量来寻找编译后的类文件

### 环境配置（配置后最好重启下）

1. 方案一：在 `/etc/profile`文件中配置

    - 编辑 `/etc/profile` 文件
        - `vi /etc/profile`

    - 文件末行添加Java环境

        ```py
        export JAVA_HOME=/usr/java/jdk1.8.0_271
        export PATH=$JAVA_HOME/bin:$PATH
        export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
        ```

    - 临时生效： `source /etc/profile`

2. 方案二：在 `/etc/profile.d/`中新建`sh文件`，将Java环境配置进去

    - 新建 java.sh文件（sh文件名随便命名）
        - `touch /etc/profile.d/java.sh`

    - 编辑 java.sh文件
        - `vi /etc/profile.d/java.sh`

    - 在文件中添加Java环境

        ```py
        export JAVA_HOME=/usr/java/jdk1.8.0_271
        export PATH=$JAVA_HOME/bin:$PATH
        export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
        ```

    - 临时生效：`source /etc/profile` 或者 `source /etc/profile.d/java.sh`

3. 方案三：修改用户目录下的 `.bashrc`文件（仅配置当前用户Java环境）

    - 编辑 .bashrc文件
        - `vi ~/.bashrc`

    - 在文件中添加Java环境

        ```py
        export JAVA_HOME=/usr/java/jdk1.8.0_271
        export PATH=$JAVA_HOME/bin:$PATH
        export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
        ```

    - 生效：`source ~/.bashrc`

4. 方案四：临时环境（不推荐）

    - 直接在终端中配置 Java环境标量

        ```py
        export JAVA_HOME=/usr/java/jdk1.8.0_271
        export PATH=$JAVA_HOME/bin:$PATH
        export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
        ```

        tips：只有当前终端窗口有效，输完Java环境变量即生效

</br>

## 验证Java环境配置是否生效

- 在终端中输入Java命令即可，最常用的就是查看JDK版本

    ```py
    java -version　　　　# 查看 JDK版本信息
    ```

- 出现下图现象就表示JDK配置成功了

    ![20220331143603](https://cdn.jsdelivr.net/gh/librarookie/Picgo/images/20220331143603.png)
