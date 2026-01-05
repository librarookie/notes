# 数据库操作命令

</br>
</br>

## MySQL

### 基础命令

  | Key | Command |
  | :--- | :--- |
  | 清屏 | `system clear`  </br> `Ctrl + l` (滚屏[^1]) |
  | 登录 | `mysql -u root -p` |
  | 切换数据库 |`USE dbname`|
  | 查看数据库 |`SHOW DATABASES`|
  | 查看表 |`SHOW TABLES`|
  | 查看表结构 |`DESC tb_name` \| `SHOW COLUMNS FROM tb_name`|
  | 退出 |`quit` \| `exit` \| `\q`|
  | 帮助 |`？` \| `help`|

</br>

### 配置命令

  | Key | Command |
  | :--- | :--- |
  | 查看可用字符集 |`SHOW CHARSET`|
  | 查看默认字符集 |`SHOW VARIABLES LIKE 'character_set_%'` </br> `SHOW VARIABLES LIKE 'collation_%'`|
  | 设置默认字符集 |`SET NAMES 'utf8mb4'`[^2]|
  | 修改数据库字符集 |`ALTER DATABASE db_name DEFAULT CHARACTER SET 'utf8mb4'`|
  | 修改表字符集 |`ALTER TABLE tb_name CONVERT CHARACTER SET 'utf8mb4'`|
  | 修改字段字符集 |`ALTER TABLE tb_name MODIFY field_name field_properties  CHARACTER SET 'utf8mb4'`|

[^1]: 滚屏，本质上只是让终端显示页向后翻了一页，如果向上滚动屏幕还可以看到之前的操作信息。

Tips

* 在mysql中查看系统路径的方法是通过 `system` + 系统命令 `ls`
* `SET NAMES 'utf8mb4'` 相当于
  * SET character_set_client = utf8;
  * SET character_set_connection = utf8;
  * SET character_set_results = utf8;
  * SET collation_connection = utf8
* MySQL 配置文件中字符集相关变量

  ```sh
  # 客户端请求数据的字符集
  character_set_client

  # 从客户端接收到数据，然后传输的字符集
  character_set_connection

  # 默认数据库的字符集，无论默认数据库如何改变，都是这个字符集；如果没有默认数据库，那就使用 character_set_server 指定的字符集，这个变量建议由系统自己管理，不要人为定义。
  character_set_database

  # 把操作系统上的文件名转化成此字符集，即把 character_set_client 转换 character_set_filesystem， 默认 binary 是不做任何转换的
  character_set_filesystem

  # 结果集的字符集
  mcharacter_set_results

  # 数据库服务器的默认字符集
  character_set_server

  # 存储系统元数据的字符集，总是 utf8，不需要设置
  character_set_system
  ```

* MySQL 8.0 默认的是 `utf8mb4_0900_ai_ci`，属于 `utf8mb4_unicode_ci` 中的一种，具体含义如下：
  * `utf8mb4` 表示用 UTF-8 编码方案，每个字符最多占 `4` 个字节。
  * `0900` 指的是 Unicode 校对算法版本。（Unicode 归类算法是用于比较符合 Unicode 标准要求的两个 Unicode 字符串的方法）。
  * `ai` 指的是口音不敏感。也就是说，排序时 `e，è，é，ê` 和 `ë` 之间没有区别。
  * `ci` 表示不区分大小写。也就是说，排序时 `p` 和 `P` 之间没有区别。
* 如果需要重音灵敏度和区分大小写，则可以使用 `utf8mb4_0900_as_cs` 代替。

[^2]: `utf8`是MySQL中的一种字符集，表示用`UTF-8`编码方案，每个字符最多占`3`个字节。而`utf8mb4`每个字符最多占`4`个字节。

</br>

### 备份与还原

| Key | Command                                                                                                                                                                                                                        |
| :-- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 备份  | `mysqldump -u root -p db_name tb_name1 [tb2 tb3...] > db_tables.sql`（表备份） </br>  `mysqldump -u root -p --databases DB1 [DB2 DB3...] > db_backup.sql`（数据库备份） </br> `mysqldump -u root -p --all-databases > db_all.sql`（备份所有数据库） |
| 还原  | `mysql -u root -p db_name < db_backup.sql`                                                                                                                                                                                     |

Tips

* 登录MySQL, 可以执行 `source db_backup.sql`还原数据库;
* `--databases` `-B` 指定数据库，可以指定多个库;（备份单个数据库时不加改参数， 还原时需要手动创建数据库）
* `--all-databases` `-A` 备份所有数据库;

</br>

## PostgreSQL

### 常用命令

| Key | Command |
| :--- | :--- |
| 清屏 | `Ctrl + l` (滚屏[^1]) |
| 登录 | `psql -U username [-d db_name] [-h db_host] [-p db_port]` |
| 查看数据库 | `\l` |
| 查看表 | `\dt` |
| 切换数据库 | `\c db_name [db_user]`|
| 显示历史命令 | `\s [file]` |
| 退出 | `\q` |
| 帮助 | `\? [commands]` |
| SQL语法 | `\h [sql_name]` |
| 修改用户密码 | `\password [username]` |
| 显示 /修改字符集 | `\encoding [utf8]` |

</br>

### 查看命令

| Key | Command |
| :--- | :--- |
| 查看数据库 | `\l` |
| 查看结构 | `\d tb_name` |
| 查看所有 | `\d` |
| 查看表 | `\dt` |
| 查看角色（roles） | `\dg` \| `\du` |
| 查看模式（schemas） | `\dn` |
| 查看索引（indexes） | `\di` |
| 查看序列（sequences） | `\ds` |
| 查看视图（views） | `\dv` |
| 查看类型（types） | `\dT` |
| 查看访问权限（access） | `\dp` \| `\z` |

Tips

* `+` = 显示额外细节（表大小和表描述等）
* `S` = 显示系统对象
* 如： `\dt` 查看表， `\dt+` 查看 **当前库** 所有表细节, `\dt+S` 查看所有表细节(当前库和系统库)

</br>

### 备份与恢复

| Key | Command |
| :--- | :--- |
| 备份| `pg_dump -U username db_name > db_backup.sql` </br> `pg_dump -U username -Fc db_name > db_backup.tar` |
| 还原 | `psql -U username -d db_name < db_backup.sql` |
| 恢复 | `pg_restore -U username -d db_name < db_backup.tar` |

更多参考： <https://www.cnblogs.com/librarookie/p/15534021.html>

</br>
</br>

Via

* <https://blog.csdn.net/weixin_38004638/article/details/109291324>
