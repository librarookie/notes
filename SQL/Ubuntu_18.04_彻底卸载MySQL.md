# Ubuntu 18.04 彻底卸载MySQL 5.7.31

</br></br>

## 1. 查看**MySQL**的依赖项

```md
      dpkg --list|grep mysql
```

</br>

## 2. 卸载 mysql-common

```md
      sudo apt remove mysql-common
```

</br>

## 3. 卸载 mysql-server

```md
      sudo apt autoremove --purge mysql-server
```

</br>

## 4. 清除残留数据

```md
      dpkg -l|grep ^rc|awk '{print$2}'|sudo xargs dpkg -P
```

</br>

## 5. 再次查看**MySQL**的剩余依赖项（一般这时候就卸载干净了）

```md
      dpkg --list|grep mysql
```

</br>

## 6. 继续删除依赖项（如果步骤 5还有剩余依赖，则继续 6）

```md
      sudo apt autoremove --purge mysql-apt-config
```

</br></br>

[MySQL安装传送门](https://www.cnblogs.com/librarookie/p/14001729.html "MySQL安装")
