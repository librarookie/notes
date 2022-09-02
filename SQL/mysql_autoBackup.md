# MySQL 数据库自动备份

</br>
</br>

## MySQL 备份命令

> 手抖、写错条件、写错表名、错连生产库造成的误删库表和数据总有听说，那么删库之后除了跑路，还能做什么呢，当然是想办法恢复，恢复数据的基础就在于完善的备份策略。下面就来介绍下MySQL自带备份工具`mysqldump`

</br>

### mysqldump 介绍

- 用法

    ```sh
    Usage: mysqldump [OPTIONS] database [tables]
    OR     mysqldump [OPTIONS] --databases [OPTIONS] DB1 [DB2 DB3...]
    OR     mysqldump [OPTIONS] --all-databases [OPTIONS]
    ```

- 常用参数
  - `--opt` 如果有这个参数表示同时激活了mysqldump命令的`quick，add-drop-table，add-locks，extended-insert，lock-tables`参数，它可以给出很快的转储操作并产生一个可以很快装入MySQL服务器的转储文件。当备份大表时，这个参数可以防止占用过多内存。（反之使用 `--skip-opt`）
  - `--single-transaction` 设置事务的隔离级别为可重复读，然后备份的时候开启事务，这样能保证在一个事务中所有相同的查询读取到同样的数据。注意，这个参数只对支持事务的引擎有效，如果有 MyISAM 的数据表，并不能保证数据一致性。(自动关闭选项 `--lock-tables`)
  - `--default-character-set=charset` 指定转储数据时采用何种字符集。(默认使用数据库的字符集)
  - `--master-data=2` 表示在备份过程中记录主库的 binlog 和 pos 点，并在dump文件中注释掉这一行，在使用备份文件做新备库时会用到
  - `-x` `--lock-all-tables` 锁表备份。由于 MyISAM 不能提供一致性读，如果要得到一份一致性备份，只能进行全表锁定。
  - `-l` `--lock-tables` 锁定所有的表以便读取。(默认为打开；使用`--skip-lock-tables`来禁用。)
  - `--dump-date` 在输出的最后加上转储日期。(默认为打开；使用`--skip-dump-date`来禁用。)
  - `-h` `--host=name` 连接主机
  - `-P` `--port=#` 端口号
  - `-u` `--user=username` 用户名
  - `-p` `--password[=passwd]` 密码
  - `-A` `--all-databases` 转储全部数据库
  - `-Y` `--all-tablespaces` 转储所有的表空间。(反之 `-y` `--no-tablespaces`不转储任何表空间信息)
  - `-B` `--databases` 转储指定数据库
    - `--tables` 转储指定表， 覆盖选项 `--databases`
  - `--ignore-table=name` 不转储指定的表。要指定一个以上的忽略的表，请多次使用该指令，每个表一次为每个表使用一次。每个表都必须同时指定数据库和表名(如`--ignore-table=database.table`)
  - `-d` `--no-data` 不转储行记录。（只有表结构，没有表数据）
  - `--add-drop-database` 在每次创建前添加一个DROP DATABASE。
  - `--add-drop-table` 在每次创建前添加一个DROP TABLE。(默认添加)

</br>

### 数据备份

- InnoDB 全库备份

    > mysqldump --opt --single-transaction --master-data=2 --default-character-set=utf8 -h<host> -u<user> -p<passwd> -A > backup.sql

- MyISAM 全库备份

    > mysqldump --opt --lock-all-tables --master-data=2 --default-character-set=utf8 -h<host> -u<user> -p<passwd> -A > backup.sql

- 备份带上压缩

    > mysqldump -h<host> -u<user> -p<passwd> -A | gzip >> backup.sql.gz

- 备份指定库（可多个库）

    > mysqldump -h<host> -u<user> -p<passwd> --databases <dbname1> <dbname2> > backup.sql

</br>

### 数据恢复

- SQL文件恢复

    > mysql -h<host> -u<user> -p<passwd> < backup.sql

- 压缩文件恢复

    > gzip -d backup.sql.gz | mysql -h<host> -u<user> -p<passwd>

    Tips: `gzip -d`为解压， 下面介绍下gzip用法与参数介绍（gzip命令只是压缩，不做打包操作）

</br>

### gzip 介绍

- gzip 用法参考： <https://www.cnblogs.com/librarookie/p/16650613.html>

</br>

## MySQL 备份脚本

- MySQL 数据库备份脚本参考： <https://www.cnblogs.com/librarookie/p/15767567.html>

</br>

## 定时任务-crontab

> `crontab` 是一个命令，常见于Unix和类Unix的操作系统之中，用于设置周期性被执行的指令。

- 定时任务设置参考： <https://www.cnblogs.com/librarookie/p/16650225.html>

</br>
</br>

Via

- <https://segmentfault.com/a/1190000019955399>
