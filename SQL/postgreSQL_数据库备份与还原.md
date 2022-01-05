# PostgreSQL 数据库备份与还原

</br></br>

## [目录](#目录)

* [备份](#备份)
* [还原](#还原)
* [栗子](#栗子)
* [拓展](#拓展)

</br>

### [备份](#目录)

> PostgreSQL提供的一个工具pg_dump,逻辑导出数据，生成sql文件或其他格式文件，pg_dump是一个客户端工具，可以远程或本地导出逻辑数据，恢复数据至导出时间点。

* Usage:

  > pg_dump [option]... [dbname]

    *note:*
    `dbname` 如果没有提供数据库名字, 那么使用 `PGDATABASE` 环境变量的数值.

* Options

  * General options:(一般选项)

    ```md
    -f, --file=FILENAME          输出文件或目录名
    -F, --format=c|d|t|p         输出文件格式 ((定制, 目录, tar) 明文 (默认值))
    -j, --jobs=NUM               执行多个并行任务进行备份转储工作
    -v, --verbose                详细模式
    -V, --version                输出版本信息，然后退出
    -Z, --compress=0-9           被压缩格式的压缩级别
    --lock-wait-timeout=TIMEOUT  在等待表锁超时后操作失败
    -?, --help                   显示此帮助, 然后退出
    ```

  * Options controlling the output content:(控制输出内容选项:)

    ```md
    -a, --data-only              只转储数据,不包括模式
    -b, --blobs                  在转储中包括大对象
    -c, --clean                  在重新创建之前，先清除（删除）数据库对象
    -C, --create                 在转储中包括命令,以便创建数据库
    -E, --encoding=ENCODING      转储以ENCODING形式编码的数据
    -n, --schema=SCHEMA          只转储指定名称的模式
    -N, --exclude-schema=SCHEMA  不转储已命名的模式
    -o, --oids                   在转储中包括 OID
    -O, --no-owner               在明文格式中, 忽略恢复对象所属者

    -s, --schema-only            只转储模式, 不包括数据
    -S, --superuser=NAME         在明文格式中使用指定的超级用户名
    -t, --table=TABLE            只转储指定名称的表
    -T, --exclude-table=TABLE    不转储指定名称的表
    -x, --no-privileges          不要转储权限 (grant/revoke)
    --binary-upgrade             只能由升级工具使用
    --column-inserts             以带有列名的INSERT命令形式转储数据
    --disable-dollar-quoting     取消美元 (符号) 引号, 使用 SQL 标准引号
    --disable-triggers           在只恢复数据的过程中禁用触发器
    --enable-row-security        启用行安全性（只转储用户能够访问的内容）
    --exclude-table-data=TABLE   不转储指定名称的表中的数据
    --if-exists              当删除对象时使用IF EXISTS
    --inserts                    以INSERT命令，而不是COPY命令的形式转储数据
    --no-security-labels         不转储安全标签的分配
    --no-synchronized-snapshots  在并行工作集中不使用同步快照
    --no-tablespaces             不转储表空间分配信息
    --no-unlogged-table-data     不转储没有日志的表数据
    --quote-all-identifiers      所有标识符加引号，即使不是关键字
    --section=SECTION            备份命名的节 (数据前, 数据, 及 数据后)
    --serializable-deferrable   等到备份可以无异常运行
    --snapshot=SNAPSHOT          为转储使用给定的快照
    --strict-names               要求每个表和/或schema包括模式以匹配至少一个实体
    --use-set-session-authorization
                                使用 SESSION AUTHORIZATION 命令代替
                  ALTER OWNER 命令来设置所有权
    ```

  * Connection options:(联接选项:)

    ```md
    -d, --dbname=DBNAME       对数据库 DBNAME备份
    -h, --host=主机名        数据库服务器的主机名或套接字目录
    -p, --port=端口号        数据库服务器的端口号
    -U, --username=名字      以指定的数据库用户联接
    -w, --no-password        永远不提示输入口令
    -W, --password           强制口令提示 (自动)
    --role=ROLENAME          在转储前运行SET ROLE
    ```

  * [PG_DUMP 文档](https://www.postgresql.org/docs/9.6/app-pgdump.html "https://www.postgresql.org/docs/9.6/app-pgdump.html")
  * [PG_DUMP 中文文档](http://postgres.cn/docs/9.6/app-pgdump.html "http://postgres.cn/docs/9.6/app-pgdump.html")

</br>

### [还原](#目录)

* Usage:

  > psql [option]... [dbname [username]]
  >
  > pg_restore [option]... [file]

  *note:* 还原前需要创建 table 所需的 role；

* Options

  psql
  * [PSQL 文档](https://www.postgresql.org/docs/9.6/app-psql.html "https://www.postgresql.org/docs/9.6/app-psql.html")
  * [PSQL 中文文档](http://postgres.cn/docs/9.6/app-psql.html "http://postgres.cn/docs/9.6/app-psql.html")

  pg_restore
  * [PG_RESTORE 文档](https://www.postgresql.org/docs/9.6/app-pgrestore.html "https://www.postgresql.org/docs/9.6/app-pgrestore.html")
  * [PG_RESTORE 中文文档](http://www.postgres.cn/docs/9.6/app-pgrestore.html "http://www.postgres.cn/docs/9.6/app-pgrestore.html")

</br>

### [栗子](#目录)

* [备份数据库](#备份数据库)
* [还原数据库](#还原数据库)

* 基础参数

  | Option | Value |
  | :--- | :--- |
  | `-h` `--host=HOSTNAME` | 数据库服务器IP或主机名 |
  | `-p` `--port=PORT` | 数据库端口号 |
  | `-U` `--username=NAME` | 用户名 |
  | `-d` `--dbname=DBNAME` | 数据库名 |
  | `-f` `--file=FILENAME` | 指定导出文件名（也可以使用`<` `>`） |
  | `-v` `--verbose` | 详细模式（打印操作过程） |

* 常用参数

  | Option | Value |
  | :--- | :--- |
  | `-F` `--format=c\|d\|t\|p` | 输出文件格式 (定制, 目录, tar, 明文 (默认值)) |
  | `-c` `--clean` | 在重新创建之前，先清除（删除）数据库对象 |
  | `-C` `--create` | 在转储中包括创库命令,以便创建数据库 |
  | `-E` `--encoding=ENCODING` | 转储以ENCODING形式编码的数据 |
  | `-n` `--schema=SCHEMA` | 只转储指定名称的模式 |
  | `-N` `--exclude-schema=SCHEMA` | 不转储指定名称的模式 |
  | `-t` `--table=TABLE` | 只转储指定名称的表 |
  | `-T` `--exclude-table=TABLE` | 不转储指定名称的表 |
  | `-s` `--schema-only` | 只转储模式, 不包括数据(不导出数据) |
  | `-Z` `--compress=0-9` | 指定压缩格式的压缩级别（0-9） |

*note：*

* 操作远程数据库时必须加上 `-h` `-p` 参数;
* 还原时，不指定数据库默认还原到 `postgres` 库（环境变量中的`PGDATABASE`）;
* `--if-exists` 当删除对象时使用IF EXISTS（配合 `-c` 参数使用）
* `-c` 删除原数据库对象（备份文件中有删除原库的SQL）
* `-C` 创建数据库（备份文件中有创建原库名的新数据库的SQL）
  * `-c` 参数： 还原过程中会先删除原数据库；
  * 使用 `-C` 参数时，创建数据库并备份所有模式。还原时无需指定数据库，自动创建原库的同名库，并把所有模式还原其中；
  * 不使用 `-C` 参数时，只备份所有模式。还原时需要指定数据库；* -C 在转储中创建数据库的命令，还原时无需在导入之前先建数据库;

</br>

#### [备份数据库](#栗子)

* 常用备份
  > pg_dump [-h host -p 5432] -U username [-c -C] -d db_name  -f db_backup.sql [-v]
  >
  > pg_dump [-h host -p 5432] -U username [-c -C] -d db_name > db_backup.sql [-v]

* 备份归档格式 `-F c|d|t|p`(默认为`p`)
  > pg_dump [-h host -p 5432] -U username [-c -C] -F c -d db_name  -f db_backup.sql [-v]

* 备份使用指定压缩级别 `-Z 0-9`
  > pg_dump [-h host -p 5432] -U username -F c -d db_name  -f db_backup.sql [-v]
  
  *note:*
  * `0` 不压缩, `1-9` 压缩级别；
  * `-Fc` 对于自定义归档格式，这会指定个体表数据段的压缩，并且默认是进行中等级别的压缩；
  * `-Fp` 对于纯文本输出，设置一个非零压缩级别会导致整个输出文件被压缩，就好像它被gzip处理过一样，但是默认是不压缩；
  * `-Ft` tar 归档格式当前完全不支持压缩；

* 备份指定模式（schema） `-n` `-N`
  > pg_dump [-h host -p 5432] -U username -d db_name -n schema_name [-n schema_name2]... -f db_schema.sql [-v]
  >
  > pg_dump [-h host -p 5432] -U username  [-c -C] -d db_name -N schema_name [-N schema_name2]... -f db_exclude-schema.sql [-v]

* 备份指定对象（table, view, etc） `-t` `-T`
  > pg_dump [-h host -p 5432] -U username -d db_name [-n schema_name] -t tb_name [-t tb_name2]... -f db_table.sql [-v]
  >
  > pg_dump [-h host -p 5432] -U username -d db_name [-n schema_name] -T tb_name [-T tb_name2]... -f db_exclude-table.sql [-v]

  *note:* 导出表 `username` 为 表的所有者

* 只备份模式（只备份所有模式，不备份数据） `-s`
  > pg_dump [-h host -p 5432] -U username [-c -C] -d db_name -s -f db_only_schema_backup.sql [-v]

</br>

#### [还原数据库](#栗子)

* 还原
  > psql [-h host -p 5432] -U username -d db_name -f db_backup.sql
  >
  > psql [-h host -p 5432] -U username -d db_name < db_backup.sql

* 恢复
  > pg_restore [-h host -p 5432] -U username -d db_name -f db_backup.tar

  *note:*
  * 错误日志： pg_restore: [archiver] input file appears to be a text format dump. Please use psql.
  * pg_resotre仅支持Fc/Ft格式的导出文件，Fp格式的文件是sql脚本，需要使用psql工具导入脚本数据

* 修改所有表 `OWNER`(postgres用户 除外)
  
  > REASSIGN OWNED BY old_role [, ...] TO new_role

  * [REASSIGN OWNED 文档](https://www.postgresql.org/docs/9.6/sql-reassign-owned.html "https://www.postgresql.org/docs/9.6/sql-reassign-owned.html")
  * [REASSIGN OWNED 中文文档](http://www.postgres.cn/docs/9.6/sql-reassign-owned.html "http://www.postgres.cn/docs/9.6/sql-reassign-owned.html")

</br>

### [拓展](#目录)

* [PostgreSQL 数据库备份脚本](https://www.cnblogs.com/cure/p/15767952.html "https://www.cnblogs.com/cure/p/15767952.html")

</br></br>

Reference

* [PostgreSQL 官网手册](https://www.postgresql.org/docs/9.6/index.html "https://www.postgresql.org/docs/9.6/index.html")
* [PostgreSQL 中文手册](http://www.postgres.cn/docs/9.6/index.html "http://www.postgres.cn/docs/9.6/index.html")
* <https://blog.csdn.net/qq_31156277/article/details/90374872>
