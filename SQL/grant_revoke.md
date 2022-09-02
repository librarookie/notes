# MySQL 的 GRANT和REVOKE 命令

</br>
</br>

## GRANT - 授权

> 将指定 `操作对象` 的指定 `操作权限` 授予指定的 `用户`; 发出该 GRANT语句的可以是数据库管理员，也可以是该数据库对象的创建者;

</br>

### 查询

- 查看用户自己权限
  > SHOW GRANTS;

- 查看其他用户权限
  > SHOW GRANTS FOR 'user'@'host';

    Tips: host 可以使用通配符 `%`；如 `'user'@'%'`, `'user'@'192.168.0.%'`;

</br>

### 授权操作

1. 语法

    > GRANT 权限 ON 数据库对象 TO 用户 [WITH GRANT OPTION];

2. 刷新

    > FLUSH PRIVILEGES;

</br>

### GRANT 栗子

- 授予 super用户所有权限
  > GRANT ALL [PRIVILEGES] ON *.* TO 'user'@'%';

- 授予用户 INSERT 权限
  > CREATE INSERT ON db_name.* TO 'user'@'%' IDENTIFIED BY 'newpasswd';

- 授予用户 SELECT, UPDATE, DELETE 权限
  > GRANT SELECT, UPDATE, DELETE ON db_name.* TO 'user'@'localhost'

- 刷新
  > FLUSH PRIVILEGES;

  Tips

  - `WITH GRANT OPTION`: 表示是否能传播其权限；（授权命令是由数据库管理员使用的）
    - 指定 `WITH GRANT OPTION` ，则获得该权限的用户可以把这种权限授予其他用户；但不允许循环传授，即被授权者不能把权限在授回给授权者或祖先；
    - 未指定，则获得某种权限的用户只能自己使用该权限，不能传播该权限；
  - 在 `GRANT` 关键字之后指定 `一个或多个` 特权。如果要授予用户多个权限，则每个权限都将以 `逗号` 分隔(见下表中的特权列表);
  - 指定确定特权应用级别的privilege_level;
    - MySQL支持全局( `*.*` )，数据库( `database.*` )，表( `database.table` )和列级别;
    - 如果您使用列权限级别，则必须在每个权限之后使用 `逗号` 分隔列的列表;
  - 如果授予权限的用户已经存在，则GRANT语句修改其特权; 如不存在，则GRANT语句将创建一个新用户; 可选的条件 `IDENTIFIED BY` 允许为用户设置新密码;

</br>

## REVOKE - 回收授权

</br>

### 回收授权操作

> REVOKE 权限 ON 数据库对象 FROM 用户 [CASCADE | RESTRICT];

</br>

### REVOKE 栗子

- 回收全部权限
    > REVOKE ALL [PRIVILEGES] ON *.* FROM 'user'@'%';

- 回收 INSERT 权限
    > REVOKE INSERT ON db_name.* FROM 'user'@'%';

Tips

- `CASCADE | RESTRICT` 当检测到关联的特权时，RESTRICT(默认值) 导致REVOKE失败；
- `CASCADE` 可以回收所有这些关联的特权；（如U1授权U2, U2授权U3，此时使用级联（CASCADE）收回了U2和U3的权限，否则系统将拒绝执行该命令）

</br>

## GRANT允许的特权

- 下表说明了可用于GRANT和REVOKE语句的所有可用权限：

  | 权限 | 含义 | 全局 | 数据库 | 表 | 列 | 过程 | 代理 |
  | ---- | ---- | :--: | :--: | :--: | :--: | :--: | :--: |
  | `ALL [PRIVILEGES]` | 授予除了grant option之外的指定访问级别的所有权限 |  |  |  |  |  |  |
  | `ALTER` | 允许用户使用alter table语句 | X | X | X |  |  |  |
  | `ALTER ROUTINE` | 允许用户更改或删除存储程序, 可以使用{alter \| drop} {procedure \| unction} | X | X |  |  | X |  |
  | `CREATE` | 允许用户创建数据库和表 | X | X | X |  |  |  |
  | `CREATE ROUTINE` | 可以使用{create \| alter \| drop} {procedure \| function} | X |  |  |  |  |  |
  | `CREATE TABLESPACE` | 允许用户创建，更改或删除表空间和日志文件组 | X |  |  |  |  |  |
  | `CREATE TEMPORARY TABLES` | 允许用户使用create temporary table创建临时表 | X | X |  |  |  |  |
  | `CREATE USER` | 允许用户使用create user，drop user，rename user和revoke all privileges语句 | X |  |  |  |  |  |
  | `CREATE VIEW` | 允许用户创建或修改视图 | X | X | X |  |  |  |
  | `DELETE` | 允许用户使用delete | X | X | X |  |  |  |
  | `DROP` | 允许用户删除数据库，表和视图 | X | X | X |  |  |  |
  | `EVENT` | 能够使用事件计划的事件 | X | X |  |  |  |  |
  | `EXECUTE` | 允许用户执行存储过程/存储函数 | X | X |  |  |  |  |
  | `FILE` | 允许用户读取数据库目录中的任何文件 | X |  |  |  |  |  |
  | `GRANT OPTION` | 允许用户有权授予或撤销其他帐户的权限 | X | X | X |  | X | X |
  | `INDEX` | 允许用户创建或删除索引 | X | X | X |  |  |  |
  | `INSERT` | 允许用户使用insert语句 | X | X | X | X |  |  |
  | `LOCK TABLES` | 允许用户在具有select权限的表上使用lock tables | X | X |  |  |  |  |
  | `PROCESS` | 允许用户使用show processlist语句查看所有进程 | X |  |  |  |  |  |
  | `PROXY` | 启用用户代理 |  |  |  |  |  |  |
  | `REFERENCES` | 允许用户创建外键 | X | X | X | X |  |  |
  | `RELOAD` | 允许用户使用flush操作 | X |  |  |  |  |  |
  | `REPLICATION CLIENT` | 允许用户查询主服务器或从服务器的位置 | X |  |  |  |  |  |
  | `REPLICATION SLAVE` | 允许用户使用复制从站从主机读取二进制日志事件 | X |  |  |  |  |  |
  | `SELECT` | 允许用户使用select语句 | X | X | X | X |  |  |
  | `SHOW DATABASES` | 允许用户显示所有数据库 | X |  |  |  |  |  |
  | `SHOW VIEW` | 允许用户使用show create view语句 | X | X | X |  |  |  |
  | `SHUTDOWN` | 允许用户使用mysqladmin shutdown命令 | X |  |  |  |  |  |
  | `SUPER` | 允许用户使用其他管理操作，如change master to，kill，purge binary logs，set global和mysqladmin命令 | X |  |  |  |  |  |
  | `TRIGGER` | 允许用户使用trigger操作 | X | X | X |  |  |  |
  | `UPDATE` | 允许用户使用update语句 | X | X | X | X |  |  |
  | `USAGE` | 连接（登陆）权限（默认授予且不能被回收）|  |  |  |  |  |  |

</br>

## 实例

</br>

### 用户操作

1. 创建用户
    > CREATE USER 'user'@'%' IDENTIFIED BY 'newpasswd';

2. 重命名用户
    > CREATE USER 'old_user'@'%' TO 'new_user'@'%';

3. 删除用户
   1. 查询用户
      > SELECT user,host FROM mysql.user;

   2. 删除用户
      > DROP USER 'user'@'host';

</br>

### 查看和刷新权限

- 查看权限
  > SHOW GRANTS [FOR 'user'@'host'];

- 刷新权限
  > FLUSH PRIVILEGES;

</br>

### 授权与取消授权

1. 用法

    ```sql
    GRANT 权限 ON 数据库对象 TO 用户 [WITH GRANT OPTION];   -- 授权
    REVOKE 权限 ON 数据库对象 FROM 用户 [CASCADE | RESTRICT];   -- 取消授权
    ```

    Tips: REVOKE 跟 GRANT 的语法差不多，只需要把关键字 `TO` 换成 `FROM` 即可

2. 栗子

    - 添加权限（和已有权限合并，不会覆盖已有权限）

      ```sql
      -- 添加普通数据用户，查询、插入、更新、删除 数据库中所有表数据的权利
      grant select, insert, update, delete on testdb.* to common_user@'%'

      -- 添加数据库开发人员，创建表、索引、视图、存储过程、函数。。。等权限
      grant create, alter, drop on testdb.* to developer@'192.168.0.%';

      -- 添加操作 MySQL 外键权限
      grant references on testdb.* to developer@'192.168.0.%';
      
      -- 添加操作 MySQL 临时表权限
      grant create temporary tables on testdb.* to developer@'192.168.0.%';
      
      -- 添加操作 MySQL 索引权限
      grant index on testdb.* to developer@'192.168.0.%';
      
      -- 添加操作 MySQL 视图、查看视图源代码 权限
      grant create, show view on testdb.* to developer@'192.168.0.%';
      ```

    - 删除授权

      ```sql
      -- 删除普通数据用户，查询、插入、更新、删除 数据库中所有表数据的权利
      revoke select, insert, update, delete on testdb.* from common_user@'%'

      -- 删除数据库开发人员，创建表、索引、视图、存储过程、函数。。。等权限
      revoke create, alter, drop on testdb.* from developer@'192.168.0.%';

      -- 删除操作 MySQL 外键权限
      revoke references on testdb.* from developer@'192.168.0.%';
      
      -- 删除操作 MySQL 临时表权限
      revoke create temporary tables on testdb.* from developer@'192.168.0.%';
      
      -- 删除操作 MySQL 索引权限
      revoke index on testdb.* from developer@'192.168.0.%';
      
      -- 删除操作 MySQL 视图、查看视图源代码 权限
      revoke create, show view on testdb.* from developer@'192.168.0.%';
      ```

    - DBA 权限管理

      ```sql
      -- 普通 DBA 管理某个 MySQL 数据库的权限
      grant all [privileges] on testdb to dba@'localhost'

      -- 高级 DBA 管理 MySQL 中所有数据库的权限。
      grant all on *.* to dba@'localhost'
      ```

    - 细密度授权

      ```sql
      -- 作用在整个 MySQL 服务器上
      grant select on *.* to dba@localhost;   -- dba 可以查询 MySQL 中所有数据库中的表
      grant all    on *.* to dba@localhost;   -- dba 可以管理 MySQL 中的所有数据库
      
      -- 作用在单个数据库上
      grant select on testdb.* to dba@localhost; -- dba 可以查询 testdb 中的表。
      
      -- 作用在单个数据表上
      grant select, insert, update, delete on testdb.t_orders to dba@localhost;
      
      -- 作用在表中的列上
      grant select(id, username, sex) on testdb.t_user to dba@localhost;
      ```

    - 权限传播与收回

      ```sql
      -- 授权 dba 查询权限，并且可以将这些权限 grant 给其他用户
      grant select on testdb.* to dba@localhost with grant option;

      -- 收回 dba 和其传播用户的权限
      revoke select on testdb.* from dba@localhost cascade;
      ```

    Tips: 权限发生改变后， 需要重新加载一下权限，将权限信息从内存中写入数据库；

</br>
</br>

Via

- <https://www.cnblogs.com/hcbin/archive/2010/04/23/1718379.html>
