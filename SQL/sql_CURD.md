# SQL 基础语法

</br>
</br>

- [SQL 基础语法](#sql-基础语法)
  - [SQL 介绍](#sql-介绍)
  - [DDL（数据定义语言）](#ddl数据定义语言)
    - [CREATE DATABASE - 创建新数据库](#create-database---创建新数据库)
    - [DROP DATABASE - 删除数据库](#drop-database---删除数据库)
    - [CREATE TABLE - 创建新表](#create-table---创建新表)
      - [五大约束](#五大约束)
    - [ALTER TABLE - 变更（改变）数据库表](#alter-table---变更改变数据库表)
    - [DROP TABLE - 删除表](#drop-table---删除表)
    - [TRUNCATE TABLE - 截断表](#truncate-table---截断表)
    - [CREATE INDEX - 创建索引（搜索键）](#create-index---创建索引搜索键)
    - [DROP INDEX - 删除索引](#drop-index---删除索引)
  - [DML（数据操作语言）](#dml数据操作语言)
    - [SELECT - 从数据库表中获取数据](#select---从数据库表中获取数据)
    - [UPDATE - 更新数据库表中的数据](#update---更新数据库表中的数据)
    - [DELETE - 从数据库表中删除数据](#delete---从数据库表中删除数据)
    - [INSERT INTO - 向数据库表中插入数据](#insert-into---向数据库表中插入数据)
  - [DCL（数据控制语言）](#dcl数据控制语言)
    - [GRANT - 授权](#grant---授权)
    - [REVOKE - 取消授权](#revoke---取消授权)

</br>

> CURD是一个数据库技术中的缩写词，一般的项目开发的各种参数的基本功能都是CURD。作用是用于处理数据的基本原子操作。它代表创建（Create）、更新（Update）、读取（Retrieve）和删除（Delete）操作。

## SQL 介绍

> SQL (Structured Query Language:结构化查询语言) 是用于管理关系数据库管理系统（RDBMS）。 SQL 的范围包括数据插入、查询、更新和删除，数据库模式创建和修改，以及数据访问控制。

- SQL 是什么？
  - SQL 指结构化查询语言
  - SQL 使我们有能力访问数据库
  - SQL 是一种 ANSI 的标准计算机语言

    `note`： ANSI（American National Standards Institute），美国国家标准化组织

- SQL 能做什么？
  - SQL 面向数据库执行查询
  - SQL 可从数据库取回数据
  - SQL 可在数据库中插入新的记录
  - SQL 可更新数据库中的数据
  - SQL 可从数据库删除记录
  - SQL 可创建新数据库
  - SQL 可在数据库中创建新表
  - SQL 可在数据库中创建存储过程
  - SQL 可在数据库中创建视图
  - SQL 可以设置表、存储过程和视图的权限

- 名词解释
  - `SQL`（Structured Query Language）结构化查询语言, 分为 `DDL` 和 `DML`
  - `DDL`（Data Definition Language）数据库定义语言。声明用于定义数据库结构或模式。
  - `DML`（Data Manipulation Language）数据操纵语言语句。用于管理模式对象中的数据。
  - `DCL`（Data Control Language）数据库控制语言。授权，角色控制等。
  - `TCL`（Transaction Control Language）事务控制语言
  - `RDBMS`（Relational Database Management System）关系型数据库管理系统。

</br>

## DDL（数据定义语言）

> 用于定义SQL模式、基本表、视图和索引的创建和撤消操作。

### CREATE DATABASE - 创建新数据库

> CREATE DATABASE db_name;

### DROP DATABASE - 删除数据库

> DROP DATABASE db_name;

### CREATE TABLE - 创建新表

> CREATE TABLE table_name(col1 type,col2 type);

```py
CREATE TABLE 表名(
字段名1 类型[(宽度) 约束条件],
字段名2 类型[(宽度) 约束条件],
字段名3 类型[(宽度) 约束条件]
) [chrset="字符编码"];
```

#### 五大约束

1. 主键约束 (`PRIMARY KEY`)

不能为空，不能重复。

2. 外键约束 (`FOREIGN KEY`)

3. 唯一约束 (`UNIQUE`)
4. 非空约束 (`NOT NULL`)

5. 检查约束 (`CHECK`)

### ALTER TABLE - 变更（改变）数据库表

- 修改表名字

  > RENAME TABLE old_table TO new_table;
  >
  > ALTER TABLE old_table RENAME AS new_table;

- 新增字段，并排在某一字段后面

  > ALTER TABLE 表名 ADD 字段名 数据类型 [完整性约束条件…] AFTER 字段名;

- 修改字段

  - `MODIFY` 只能修改 -数据类型- 及其 -完整性约束条件-

    > ALTER TABLE 表名 MODIFY  字段名 新数据类型 [完整性约束条件…];

  - `CHANGE` 能修改 -字段名-、-数据类型- 及其 -完整性约束条件-
    > ALTER TABLE 表名 CHANGE 旧字段名 新字段名 新数据类型 [完整性约束条件…];

- 删除字段

  > ALTER TABLE table_name DROP [COLUMN] column_name;

### DROP TABLE - 删除表

> DROP TABLE table_name;

### TRUNCATE TABLE - 截断表

> TRUNCATE TABLE table_name;

### CREATE INDEX - 创建索引（搜索键）

> CREATE INDEX index_name ON table_name (column_name);
>
> CREATE UNIQUE INDEX index_name ON table_name (column_name);

### DROP INDEX - 删除索引

> DROP INDEX index_name;

</br>

## DML（数据操作语言）

>数据操纵分成数据查询和数据更新两类。数据更新又分成插入、删除、和修改三种操作。

### SELECT - 从数据库表中获取数据

> SELECT column_name(s) FROM table_name WHERE condition AND|OR condition;

### UPDATE - 更新数据库表中的数据

> UPDATE table_name SET column1=value, column2=value,... WHERE condition;

### DELETE - 从数据库表中删除数据

> DELETE FROM table_name [WHERE condition];

### INSERT INTO - 向数据库表中插入数据

> INSERT INTO table_name VALUES (value1, value2, value3,....)
>
> INSERT INTO table_name (column1, column2, column3,...) VALUES (value1, value2, value3,....)

</br>

## DCL（数据控制语言）

> DCL 包括对基本表和视图的授权，完整性规则的描述，事务控制等内容。

### GRANT - 授权

### REVOKE - 取消授权

</br>
