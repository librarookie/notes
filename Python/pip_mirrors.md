# Python-pip 配置国内源

</br>
</br>

> pip 是一个现代的，通用的 Python 包管理工具。提供了对 Python 包的查找、下载、安装、卸载的功能;

## 常用的国内源

- 阿里云 <http://mirrors.aliyun.com/pypi/simple/>
- 豆瓣(douban) <http://pypi.douban.com/simple/>
- 清华大学 <https://pypi.tuna.tsinghua.edu.cn/simple/>
- 中国科技大学 <https://pypi.mirrors.ustc.edu.cn/simple/>
- 中国科学技术大学 <http://pypi.mirrors.ustc.edu.cn/simple/>

</br>

## pip 源配置

### 临时生效

> pip 安装时，指定下载源，本次安装有效

```sh
# 安装包时，使用-i参数，指定pip源
pip install numpy -i http://pypi.douban.com/simple/

# 此参数“--trusted-host”表示信任，如果上一个提示不受信任，就使用这个
pip install numpy -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com  
```

</br>

### 永久生效

- Linux 平台

  1. 修改`~/.pip/pip.conf`(没有就创建一个)

      ```sh
      # 创建 ~/.pip/pip.conf 命令
      mkdir ~/.pip && touch ~/.pip/pip.conf
      ```

  2. 在 `pip.conf` 文件中，添加以下内容

      ```sh
      [global] 
      index-url = https://pypi.tuna.tsinghua.edu.cn/simple/
      [install] 
      trusted-host = pypi.tuna.tsinghua.edu.cn
      ```

      Tips: `trusted-host`此参数是为了避免麻烦，否则使用的时候可能会提示不受信任

- Windows 平台

  1. 在 User 目录中创建一个 pip目录，如：`C:\Users\xxx\pip`
  2. 在`pip目录`下新建文件`pip.txt`并改后缀为`ini`, 即：`pip.ini`

      ![202209011532941](https://gitee.com/librarookie/picgo/raw/master/img/202209011532941.png "202209011532941")

  3. 在 `pip.ini` 文件中，添加以下内容

      ```sh
      [global] 
      index-url = https://pypi.tuna.tsinghua.edu.cn/simple/
      [install] 
      trusted-host = pypi.tuna.tsinghua.edu.cn
      ```

      Tips：`trusted-host`此参数是为了避免麻烦，否则使用的时候可能会提示不受信任

</br>

## 测试

查看 pip 配置: `pip config list`

![202209011535456](https://gitee.com/librarookie/picgo/raw/master/img/202209011535456.png "202209011535456")

</br>
</br>

Via

- <https://www.cnblogs.com/schut/p/10410087.html>
