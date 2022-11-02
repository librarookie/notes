# MySQL 基础

</br>
</br>

## SQL 介绍

> SQL (Structured Query Language:结构化查询语言) 是用于管理关系数据库管理系统（RDBMS）。 SQL 的范围包括数据插入、查询、更新和删除，数据库模式创建和修改，以及数据访问控制。

- SQL 是什么？
  - SQL 指结构化查询语言
  - SQL 使我们有能力访问数据库
  - SQL 是一种 ANSI（American National Standards Institute，美国国家标准化组织）的标准计算机语言

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
  - `SQL`（Structured Query Language）结构化查询语言, 分为 `DDL`, `DML`和 `DCL`。
  
  - `DDL`（Data Definition Language）数据库定义语言，声明用于定义数据库结构或模式。主要包括三个关键字： `CREATE`, `ALTER`, `DROP`, 主要操作对象 有数据库、表、索引、视图等。
  
  - `DML`（Data Manipulation Language）数据操纵语言，用于管理模式对象中的数据。以 `INSERT`, `UPDATE`, `DELETE` 三种指令为核心，分别代表插入、更新与删除。
  
  - `DQL`（Data Query Language, DQL）数据查询语言，是SQL语言中，负责进行数据查询而不会对数据本身进行修改的语句，这是最基本的SQL语句。保留字SELECT是DQL（也是所有SQL）用得最多的动词，其他DQL常用的保留字有FROM，WHERE，GROUP BY，HAVING和ORDER BY。这些DQL保留字常与其他类型的SQL语句一起使用。

  - `DCL`（Data Control Language）数据库控制语言，由 `GRANT` 和 `REVOKE` 两个指令组成；DCL以控制用户的访问权限为主，GRANT为授权语句，对应的REVOKE是撤销授权语句。
  
  - `TCL`（Transaction Control Language）事务控制语言。
  
  - `RDBMS`（Relational Database Management System）关系型数据库管理系统。

</br>

## DDL（数据定义语言）

> 用于定义SQL模式、基本表、视图和索引的创建和删除操作。

</br>

### 数据库操作

- CREATE DATABASE - 创建新数据库
  > CREATE DATABASE [IF NOT EXISTS] db_name;

  Tips: `IF NOT EXISTS` 判断数据库是否存在，不存在则创建数据；存在则忽略创建语句，不再创建数据库。

- DROP DATABASE - 删除数据库
  > DROP DATABASE [IF EXISTS] db_name;

  Tips: `IF EXISTS` 判断数据库是否存在，存在则删除，不存在就结束，不会报错。（没有该关键字，删除不存在的数据库时会报错）

</br>

### 数据表操作

1. CREATE TABLE - 创建新表
    > CREATE TABLE [IF NOT EXISTS] table_name(col1 type,col2 type);

    Tips: `IF NOT EXISTS` 判断当前数据库中是否存在该表，不存在则创建数据表；存在在则忽略建表语句，不再创建数据表。

    ```sql
    CREATE TABLE [IF NOT EXISTS] 表名(
      字段名1 数据类型 [约束条件] [默认值],
      字段名2 数据类型 [约束条件] [默认值],
      字段名3 数据类型 [约束条件] [默认值],
      ...
    ) [chrset="字符编码"];
    ```

2. ALTER TABLE - 变更（改变）数据库表

    - 修改表名字
      > ALTER TABLE old_table RENAME AS new_table;

    - 新增字段，并排在某一字段后面
      > ALTER TABLE 表名 ADD [COLUMN] 字段名 数据类型 [完整性约束条件…] [FIRST | AFTER 字段名];

    - 修改字段

      - `MODIFY` 只能修改 -数据类型- 及其 -完整性约束条件-
        > ALTER TABLE 表名 MODIFY  字段名 新数据类型 [完整性约束条件…];

      - `CHANGE` 能修改 -字段名-、-数据类型- 及其 -完整性约束条件-
        > ALTER TABLE 表名 CHANGE 旧字段名 新字段名 新数据类型 [完整性约束条件…];

    - 删除字段
      > ALTER TABLE table_name DROP [COLUMN] column_name;

3. DROP TABLE - 删除表
    > DROP TABLE [IF EXISTS] table_name;

    Tips: `IF EXISTS` 判断当前数据库中是否存在该表，存在则删除数据表；不存在则忽略删除语句，不再执行删除数据表的操作。

4. TRUNCATE TABLE - 截断表（清空表）
    > TRUNCATE TABLE table_name;

</br>

### 常用约束

> 约束（Constraint）是Microsoft SQL Server 提供的自动保持数据库完整性的一种方法，定义了可输入表或表的单个列中的数据的限制条件。在SQL Server 中有5 种约束：主关键字约束（Primary Key Constraint）、外关键字约束（Foreign Key Constraint）、惟一性约束（Unique Constraint）、检查约束（Check Constraint）和缺省约束（Default Constraint）

- 主键约束 (`Primary Key Constraint`) 要求主键列唯一，并且不允许为空

- 唯一约束 (`Unique Constraint`)  要求该列唯一，允许为空，但只能出现一个空值

- 检查约束 (`Check Constraint`)  某列取值范围限制、格式限制等。（如：年龄，性别）

- 默认约束 (`Default Constraint`)  某列 的默认值（如：男性学员比较多，性别默认设为男）

- 外键约束 (`Foreign Key Constraint`)  用于在两表之间建立关系，需要指定引用主表的哪一列

  Tips:
  - 主键约束：指定表的 `一列或几列` 的组合的值在表中具有惟一性，即能惟一地指定一行记录。且IMAGE 和TEXT 类型的列不能被指定为主关键字，也不允许指定主关键字列有NULL 属性。
  - 多列组成的主键叫 `联合主键`，而且联合主键约束只能设定为表级约束；单列组成的主键，既可设定为列级约束，也可以设定为表级约束。
  - 唯一约束：指定 `一个或多个列` 的组合的值具有惟一性，以防止在列中输入重复的值。惟一性约束指定的列可以有NULL 属性。由于主关键字值是具有惟一性的，因此主关键字列不能再设定惟一性约束。惟一性约束最多由16 个列组成。
  - 检查约束：对输入列或整个表中的值设置检查条件，以限制输入值，保证数据库的数据完整性。可以对每个列设置复合检查。
  - 默认约束：通过定义列的缺省值或使用数据库的缺省值对象绑定表的列，来指定列的缺省值。

</br>

#### 约束操作

1. 添加约束
    > ALTER TABLE 表名 ADD CONSTRAINT 约束名 约束类型 具体的约束条件;

2. 删除约束
    > ALTER TABLE 表名 DROP CONSTRAINT 约束名;

3. 关闭约束
    > ALTER TABLE 表名 DISABLE CONSTRAINT 约束名 CASCADE;

    Tips: 如果没有被引用则不需 `CASCADE` 关键字

4. 打开约束
    > ALTER TABLE 表名 ENABLE CONSTRAINT 约束名;

    Tips: 打开一个先前关闭的被引用的主键约束, 并不能自动打开相关的外部键约束

5. 栗子

    ```sql
    -- 添加主键约束（将 stuNo 作为主键）
    Alter Table stuInfo
    Add Constraint  PK_stuNO primary Key(stuNo);

    -- 添加唯一约束（stuID 唯一）
    Alter Table stuInfo
    Add Constraint UQ_stuID unique(stuID);

    -- 添加默认约束（stuAddress 的默认值为 "地址不详"）
    Alter Table stuInfo
    Add Constraint DF_stuAddress default('地址不详') for stuAddress;

    -- 添加检查约束（对 stuAge 加以限制，15~20之间）
    Alter Table stuInfo
    Add Constraint CK_stuAge check(stuAge between 15 and 20);
    Alter Table stuInfo
    Add Constraint CK_stuSex check(stuSex='男' or stuSex='女');

    -- 添加外键约束（主表 stuInfo 和从表 stuMarks 建立关系，关联字段 stuNo）
    Alter Table stuMarks
    Add Constraint FK_stuNo foreign key(stuNo) references stuInfo(stuNo);
    ```

    Tips：约束名的命名规则推荐采用 `约束类型_约束字段` 的形式

</br>

### 索引操作

> 索引是一种特殊的查询表，可以被数据库搜索引擎用来加速数据的检索。简单说来，索引就是指向表中数据的指针。数据库的索引同书籍后面的索引非常相像。

1. CREATE INDEX - 创建索引（搜索键）
    - `单列索引`：基于单一的字段创建
      > CREATE INDEX index_name ON table_name (column_name);

    - `唯一索引`：不止用于提升查询性能，还用于保证数据完整性。（不允许向表中插入任何重复值）
      > CREATE UNIQUE INDEX index_name ON table_name (column_name);

    - `聚簇索引`：在表中两个或更多的列的基础上建立
      > CREATE INDEX index_name ON table_name (column1, column2);

2. DROP INDEX - 删除索引
    > DROP INDEX table_name.index_name;

Tips

- 删除索引时应当特别小心，数据库的性能可能会因此而降低或者提高
- 隐式索引由数据库服务器在创建某些对象的时候自动生成。（例如，对于主键约束和唯一约束，数据库服务器就会自动创建索引）
- 索引创建原则：
  - 仅在被频繁检索的字段上创建索引;
  - 针对大数据量的表创建索引，而不是针对只有少量数据的表创建索引;
  - 尽量不要在有大量重复值得字段上建立索引（比如性别字段、季度字段等）
  - 不在频繁进行大批量的更新或者插入操作的表创建索引；
  - 不在频繁操作的列创建索引;

</br>

## DML（数据操作语言）

> 数据操纵分成数据查询和数据更新两类。数据更新又分成插入、删除、和修改三种操作。 </br>
> CURD 是一个数据库技术中的缩写词，一般的项目开发的各种参数的基本功能都是CURD。作用是用于处理数据的基本原子操作。它代表创建（Create）、更新（Update）、读取（Retrieve）和删除（Delete）操作。

</br>

### SELECT - 从数据库表中获取数据

  > SELECT column_name(s) FROM table_name WHERE condition AND|OR condition;

</br>

### UPDATE - 更新数据库表中的数据

- 常规更新
  > UPDATE table_name SET col_name1=value1 WHERE condition;

- 更新日期
  - NOW() 函数
    > UPDATE table_name SET birthday=NOW() WHERE condition;

  - STR_TO_DATE() 函数
    > UPDATE table_name SET birthday=STR_TO_DATE('2022-04-18','%Y-%m-%d') WHERE condition;

- 把原表（src_table）的值设置到本表（tar_table）中
  > UPDATE src_table st,tar_table tt SET tt.tar_column=st.src_column WHERE tt.tar_condition | tt.tar_column=st.src_column;

</br>

### DELETE - 从数据库表中删除数据

- 请空表
  > DELETE FROM table_name [WHERE condition];

- 截断表
  > TRUNCATE TABLE table_name;

</br>

### INSERT INTO - 向数据库表中插入数据

#### 常规插入

- 单条记录插入
  - 全表插入
    > INSERT INTO table_name VALUES (value1, value2, value3, ...);

  - 插入指定字段
    > INSERT INTO table_name (column1, column2, column3)  VALUES (value1, value2, value3);

- 批量插入
  - 批量全表插入

    ```sql
    INSERT INTO table_name 
    VALUES 
      (value1, value2, value3, ...), 
      (value1, value2, value3, ...), 
      ...
      (value1, value2, value3, ...);
    ```

  - 批量插入指定字段

    ```sql
    INSERT INTO table_name (column1, column2, column3) 
    VALUES 
      (value1, value2, value3), 
      (value1, value2, value3),
      ...
      (value1, value2, value3);
    ```

Tips:

- 全表插入时，值列表中需要为表的每一个字段指定值，并且值的顺序必须和数据表中字段定义时的顺序相同;
- 插入指定字段时，在INSERT语句中只向部分字段中插入值，而其他字段的值为表定义时的默认值；
- 在 INSERT 子句中随意列出列名，但是一旦列出，VALUES中要插入的value1,…valuen需要与column1,…columnn 列一一对应。如果类型不同，将无法插入，并且MySQL会产生错误。
- INSERT语句可以同时向数据表中插入多条记录，插入时指定多个值列表，每个值列表之间用逗号分隔开;

</br>

#### 插入查询结果集

- 将查询的结果集插入表中

  ```sql
  INSERT INTO tar_table (tar_column1, tar_column2, ...) 
  SELECT (src_column1, src_column2, ...) FROM src_table 
  [WHERE src_condition];
  ```

  Tips:

  - 在 `INSERT` 语句中加入子查询;
  - 不必书写 `VALUES` 子句;

</br>

### MySQL 计算列（虚拟列）

1. MySQL 5.7 引入了生成列，支持虚拟和存储两种类型的生成列;

    - 语法:

      ```sql
      col_name data_type [GENERATED ALWAYS] AS (expr)
        [VIRTUAL | STORED]
        [NOT NULL | NULL] 
        [UNIQUE [KEY]] 
        [[PRIMARY] KEY]
        [COMMENT 'string']
      ```

      Tips:

      - `GENERATED ALWAYS` 可以省略;
      - `AS (expr)` 用于生成计算列值的表达式;
      - `VIRTUAL 或 STORED` 关键字表示是否存储计算列的值：
        - `VIRTUAL`：列值不存储，虚拟列不占用存储空间，默认设置为 VIRTUAL
        - `STORED`：在添加或更新行时计算并存储列值; 存储列需要存储空间，并且可以创建索引;
      - 如果表达式的结果类型与字段定义中的数据类型不同，将会执行隐式的类型转换
      - 生成列支持`NOT NULL`、`UNIQUE`、`主键`、`CHECK`以及 `外键` 约束，但是不支持 `DEFAULT` 默认值;
      - Generated column 表达式必须遵循以下规则:
        - 允许使用常量、确定性的内置函数以及运算符；
          - `确定性函数` 意味着对于表中的相同数据，多次调用返回相同的结果，与当前用户无关;
          - `非确定性函数` 包括 CONNECTION_ID()、CURRENT_USER()、NOW() 等；
        - 不允许使用存储函数和自定义函数；
        - 不允许使用存储过程和函数的参数；
        - 不允许使用变量（系统变量、自定义变量或者存储程序中的本地变量）；
        - 不允许子查询；
        - 允许引用表中已经定义的其他生成列；允许引用任何其他非生成列，无论这些列出现的位置在前面还是后面；
        - 不允许使用 AUTO_INCREMENT 属性；
        - 不允许使用 AUTO_INCREMENT 字段作为生成列的基础列；
        - 可以在计算列上创建索引，但不能在 VIRTUAL 类型的计算列上创建聚集索引；

    - 栗子

      ```sql
      -- 创建表 t_test ，其中计算列 sum 的值为 (a + b)
      CREATE TABLE t_test (
        a INT NOT NULL,
        b INT NOT NULL,
        sum INT GENERATED ALWAYS AS (a + b) [VIRTUAL]
      );

      -- 添加计算列 area 值为 (a * b)
      ALTER TABLE t_test ADD area INT AS (a * b) STORED;
      ```

2. 其他 SQL 类型
   - [其他 SQL 类型的计算列](https://blog.csdn.net/horses/article/details/104119208 "SQL 中的生成列/计算列以及主流数据库实现")

</br>

## DCL（数据控制语言）

> DCL 包括对基本表和视图的授权，完整性规则的描述，事务控制等内容。用于控制不同数据段直接的许可和访问级别的语句。这些语句定义了数据库、表、字段、用户的访问权限和安全级别。

</br>

### GRANT - 授权

> 将指定 `操作对象` 的指定 `操作权限` 授予指定的 `用户`; 发出该 GRANT语句的可以是数据库管理员，也可以是该数据库对象的创建者;

1. 查询

    - 查看用户自己权限
      > SHOW GRANTS;

    - 查看其他用户权限
      > SHOW GRANTS FOR 'username'@'host';

    Tips: host 可以使用通配符 `%`；如 'user'@'%', 'user'@'192.168.0.%';

2. 授权

    - 语法
      > GRANT 权限 ON 数据库对象 TO 用户 [WITH GRANT OPTION];

    - 栗子
      - 授予 super用户所有权限
        > GRANT ALL [PRIVILEGES] ON *.* TO username;

      - 授予用户 INSERT 权限
        > CREATE INSERT ON db_name.* username@'localhost' IDENTIFIED BY 'newpasswd';

      - 授予用户 SELECT, UPDATE, DELETE 权限
        > GRANT SELECT, UPDATE, DELETE ON db_name.* TO username

3. 刷新

    > flush privileges;

Tips:

- `WITH GRANT OPTION`: 表示是否能传播其权限；（授权命令是由数据库管理员使用的）
  - 指定 `WITH GRANT OPTION`，则获得该权限的用户可以把这种权限授予其他用户；但不允许循环传授，即被授权者不能把权限在授回给授权者或祖先；
  - 未指定，则获得某种权限的用户只能自己使用该权限，不能传播该权限；
- 在 `GRANT` 关键字之后指定`一个或多个`特权。如果要授予用户多个权限，则每个权限都将以`逗号`分隔(见下表中的特权列表);
- 指定确定特权应用级别的privilege_level;
  - MySQL支持全局(`*.*`)，数据库(`database.*`)，表(`database.table`)和列级别;
  - 如果您使用列权限级别，则必须在每个权限之后使用`逗号`分隔列的列表;
- 如果授予权限的用户已经存在，则GRANT语句修改其特权; 如不存在，则GRANT语句将创建一个新用户; 可选的条件 `IDENTIFIED BY` 允许为用户设置新密码;

</br>

### REVOKE - 回收授权

- 语法

  > REVOKE 权限 ON 数据库对象 FROM 用户 [CASCADE | RESTRICT];

- 栗子
  - 回收全部权限
    > REVOKE ALL [PRIVILEGES] ON *.* FROM username;

  - 回收 INSERT 权限
    > REVOKE INSERT ON db_name.* FROM username;

Tips

- `CASCADE | RESTRICT` 当检测到关联的特权时，RESTRICT(默认值) 导致REVOKE失败；
- `CASCADE` 可以回收所有这些关联的特权；（如U1授权U2, U2授权U3，此时使用级联（CASCADE）收回了U2和U3的权限，否则系统将拒绝执行该命令）

更多GRANT和REVOKE参考 <https://www.cnblogs.com/librarookie/p/16160252.html>

</br>
</br>
