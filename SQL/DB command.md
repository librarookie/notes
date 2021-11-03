# DB commands

</br></br>

> 常用数据库操作命令

## [目录](#目录)

* [MySQL](#mysql)
* [PostgreSQL](#postgresql)

</br>

### [MySQL](#目录)

| Key | Command |
| :--- | :--- |
| 清屏 | `system clear`  </br> `Ctrl + l` (滚屏[^1]) |
| 登录 | `mysql -u root -p` |
| 切换数据库 |`USE dbname`|
| 查看数据库 |`SHOW DATABASES`|
| 查看表 |`SHOW TABLES`|
| 查看表结构 |`DESC tb_name` `SHOW COLUMNS FROM tb_name`|
| 退出 |`quit` `exit` `\q`|
| 帮助 |`？` `help`|
| 查看可用字符集 |`SHOW CHARSET`|
| 查看默认字符集 |`SHOW VARIABLES LIKE 'character_set_%'` </br> `SHOW VARIABLES LIKE 'collation_%'`|
| 设置默认字符集 |`SET NAMES 'utf8mb4'`[^1]|
| 修改数据库字符集 |``|
| 修改表字符集 ||
| 修改字段字符集 ||
|||
|||

[^1]: 滚屏，本质上只是让终端显示页向后翻了一页，如果向上滚动屏幕还可以看到之前的操作信息。

`SET NAMES 'utf8mb4'` 相当于 `SET character_set_client = utf8;
SET character_set_connection = utf8;
SET character_set_results = utf8;
SET collation_connection = utf8`

</br>

### [PostgreSQL](#目录)

* [常用命令](#常用命令)
* [查看命令](#查看命令)
* [备份与还原](#备份与还原)

</br>

#### [常用命令](#postgresql)

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

#### [查看命令](#postgresql)

| Key | Command |
| :--- | :--- |
| 查看数据库 | `\l` |
| 查看结构 | `\d tb_name` |
| 查看所有 | `\d` |
| 查看表 | `\dt` |
| 查看角色（roles） | `\dg` `\du` |
| 查看模式（schemas） | `\dn` |
| 查看索引（indexes） | `\di` |
| 查看序列（sequences） | `\ds` |
| 查看视图（views） | `\dv` |
| 查看类型（types） | `\dT` |
| 查看访问权限（access） | `\dp` `\z` |

*note:*

* `+` = 显示额外细节（表大小和表描述等）
* `S` = 显示系统对象
* 比如：
  * `\dt` 查看表， `\dt+` 查看**当前库**所有表细节,`\dt+S` 查看所有表细节(当前库和系统库)

</br>

#### [备份与还原](#postgresql)

| Key | Command |
| :--- | :--- |
| 备份数据库 | `pg_dump -U user_name db_name > db_name.sql` |
| 还原数据库 | `psql -U user_name < db_name.sql` |

</br></br>
