# Ubuntu 彻底卸载 MySQL 数据库

</br>
</br>

> 实例： Ubuntu 18.04 彻底卸载MySQL 5.7.31

</br>

## 查看 **MySQL** 依赖

```sh
dpkg --list|grep mysql
```

</br>

## 卸载 mysql-common

```sh
sudo apt remove mysql-common
```

</br>

## 卸载 mysql-server

```sh
sudo apt autoremove --purge mysql-server
```

</br>

## 清除残留数据

```sh
dpkg -l|grep ^rc|awk '{print $2}'|sudo xargs dpkg -P
```

</br>

## 检查依赖

> 再次查看 **MySQL** 的剩余依赖项（一般这时候就卸载干净了）

```sh
dpkg --list|grep mysql
```

</br>

## 删除依赖

> 继续删除依赖项；如果检查依赖时，还有残留，则执行此步删除依赖

```sh
sudo apt autoremove --purge mysql-apt-config
```

</br>

## 扩展

- MySQL安装传送门： <https://www.cnblogs.com/librarookie/p/14001729.html>

</br>
</br>
