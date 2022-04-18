# MySQL 数据表操作

</br></br>

## [目录](#目录)

- [MySQL 数据表操作](#mysql-数据表操作)
  - [目录](#目录)
    - [数据表操作](#数据表操作)
      - [创建数据表](#创建数据表)
      - [查看数据表](#查看数据表)
      - [修改表名字](#修改表名字)
      - [清空数据表](#清空数据表)
      - [删除数据表](#删除数据表)
    - [复制表操作](#复制表操作)
      - [结构复制](#结构复制)
      - [全部复制（不会复制主键，外键，索引）](#全部复制不会复制主键外键索引)
      - [选择复制](#选择复制)
    - [表字段操作](#表字段操作)
      - [新增字段](#新增字段)
      - [修改字段](#修改字段)
      - [删除字段](#删除字段)

</br>

### [数据表操作](#目录)

每一张数据表都相当于一个文件，在数据表中又分为表结构与表记录。

> 表结构：包括存储引擎，字段，主外键类型，约束性条件，字符编码等;
>
> 表记录：数据表中的每一行数据（不包含字段行）;

#### [创建数据表](#数据表操作)

> 创建数据表其实大有讲究，它包括表名称，表字段，存储引擎，主外键类型，约束性条件，字符编码等。
>
> 如果InnoDB数据表没有创建主键，那么MySQL会自动创建一个以行号为准的隐藏主键。

- 语法

    ```py
    CREATE TABLE [IF NOT EXISTS] 表名(
    字段名1 类型[(宽度) 约束条件],
    字段名2 类型[(宽度) 约束条件],
    字段名3 类型[(宽度) 约束条件]
    ) [chrset="字符编码"];
    ```

    Tips:

    1. `IF NOT EXISTS` 判断数据库是否存在，不存在则创建数据；存在则忽略创建语句，不再创建数据库;
    2. 在同一张表中，字段名是不能相同;
    3. 宽度和约束条件可选;
    4. 字段名和类型是必须的;
    5. 表中最后一个字段不要加逗号;
    6. 也可以不进入数据库在外部或另外的库中进行创建，那么创建时就应该指定数据库;

#### [查看数据表](#数据表操作)

- 查看所有表
    > SHOW TABLES [FROM db_name];

- 查看表结构(字段, 类型, 约束条件等)

  - SQL 1
    > DESC table_name;

  - SQL 2
    > SHOW COLUMNS FROM table_name;

- 查看表创建信息
    > SHOW CREATE TABLE table_name;

- 数据库命令

  - 进入数据库
    > USE db_name;

  - 查看当前所在数据库
    > SELECT DATABASE();

#### [修改表名字](#数据表操作)

- SQL 1
  > RENAME TABLE old_table TO new_table;
  
- SQL 2
  > ALTER TABLE old_table RENAME AS new_table;

#### [清空数据表](#数据表操作)

- 截断表
  > TRUNCATE TABLE table_name;

- 清空表
  > DELETE FROM table_name;

Tips:

- 都可以实现对表中所有数据的删除，同时保留表结构;
- `TRUNCATE TABLE`：表数据全部清除; 数据是不可以回滚的;
- `DELETE FROM`：表数据可以全部清除; 数据是可以实现回滚的;

#### [删除数据表](#数据表操作)

- 单表删除
  > DROP TABLE [IF EXISTS] table_name;

- 批量删除
  > DROP TABLES table_name table_name2, ...;

  Tips:
  - `IF EXISTS` 判断当前数据库中是否存在该表，存在则删除数据表；不存在则忽略删除语句，不再执行删除数据表的操作;
  - 删除 `表数据` 和 `表结构`，且释放表空间；

</br>

### [复制表操作](#目录)

#### [结构复制](#复制表操作)

  > CREATE TABLE table_name LIKE temp_table_name;

#### [全部复制](#复制表操作)（不会复制主键，外键，索引）

  > CREATE TABLE table_name [AS] SELECT * FROM temp_table_name [WHERE 1<>1];

  Tips: where条件用来筛选数据，`WHERE 1<>1` 表示只复制表结构；

#### [选择复制](#复制表操作)

  > CREATE TABLE table_name SELECT field1,field2... FROM temp_table_name;

</br>

### [表字段操作](#目录)

  > 表字段是属于表结构的一部分，可以将他作为文档的标题。
  >
  > 其标题下的一行均属于当前字段下的数据。

#### [新增字段](#表字段操作)

- 增加多个字段

    ```sql
    ALTER TABLE 表名
                    ADD 字段名 数据类型 [完整性约束条件…],
                    ADD 字段名 数据类型 [完整性约束条件…];
    ```

- 增加单个字段，排在最前面
  > ALTER TABLE 表名 ADD 字段名 数据类型 [完整性约束条件…] FIRST;

- 增加单个字段，排在某一字段后面
  > ALTER TABLE 表名 ADD 字段名 数据类型 [完整性约束条件…] AFTER 字段名;

#### [修改字段](#表字段操作)

> 修改字段分为修改 `字段名` 或者修改其 `数据类型`

- `RENAME` 只改表字段名
  > ALTER TABLE 表名 RENAME COLUMN 旧字段名 TO 新字段名;

- `MODIFY` 只能修改 -数据类型- 及其 -完整性约束条件-
  > ALTER TABLE 表名 MODIFY  字段名 新数据类型 [完整性约束条件…];

- `CHANGE` 能修改 -字段名-、-数据类型- 及其 -完整性约束条件-
  - SQL 1
    > ALTER TABLE 表名 CHANGE 旧字段名 新字段名 旧数据类型 [完整性约束条件…];

  - SQL 2
    > ALTER TABLE 表名 CHANGE 旧字段名 新字段名 新数据类型 [完整性约束条件…];

#### [删除字段](#表字段操作)

  > ALTER TABLE table_name DROP [COLUMN] field_name;

</br>
</br>

Reference

- <https://www.cnblogs.com/Yunya-Cnblogs/p/13584553.html>
