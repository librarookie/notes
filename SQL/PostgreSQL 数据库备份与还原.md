# PostgreSQL 数据库备份与还原

</br></br>

## [目录](#目录)

* [备份](#备份)
* [还原](#还原)
* [栗子](#栗子)

</br>

### [备份](#目录)

* Usage:

  > pg_dump [option]... [dbname]

    *note:*
    `dbname`不指定默认是系统变量PGDATABASE指定的数据库。

* Options

  * General options:(一般选项)

      ```md
      -f, --file=FILENAME          output file or directory name(导出后保存的文件名)
      -F, --format=c|d|t|p            output file format (custom, directory, tar, plain text (default))(导出文件的格式,默认纯文本)
      -j, --jobs=NUM                  use this many parallel jobs to dump(并行数)
      -v, --verbose                　  verbose mode (详细模式)
      -V, --version                　  output version information, then exit(输出版本信息, 然后退出)
      -Z, --compress=0-9          compression level for compressed formats(被压缩格式的压缩级别)
      --lock-wait-timeout=TIMEOUT  fail after waiting TIMEOUT for a table lock(在等待表锁超时后操作失败)
      -?, --help                   show this help, then exit(显示此帮助信息, 然后退出)
      ```

  * Options controlling the output content:(控制输出的选项)

      ```md
      -a, --data-only              dump only the data, not the schema(只导出数据，不包括模式)
      -b, --blobs                  include large objects in dump(在转储中包括大对象)
      -c, --clean                  clean (drop) database objects before recreating(在重新创建之前，先清除（删除）数据库对象)
      -C, --create                 include commands to create database in dump(在转储中包括命令,以便创建数据库（包括建库语句，无需在导入之前先建数据库）)
      -E, --encoding=ENCODING      dump the data in encoding ENCODING(转储以ENCODING形式编码的数据)
      -n, --schema=SCHEMA          dump the named schema(s) only(只转储指定名称的模式)
      -N, --exclude-schema=SCHEMA  do NOT dump the named schema(s)(不转储已命名的模式)
      -o, --oids                   include OIDs in dump(在转储中包括 OID)
      -O, --no-owner               skip restoration of object ownership in plain-text format(跳过以纯文本格式恢复对象所属者)
      -s, --schema-only            dump only the schema, no data(只转储模式, 不包括数据(不导出数据))
      -S, --superuser=NAME         superuser user name to use in plain-text format(在转储中, 指定的超级用户名)
      -t, --table=TABLE            dump the named table(s) only(只转储指定名称的表)
      -T, --exclude-table=TABLE    do NOT dump the named table(s)(只转储指定名称的表)
      -x, --no-privileges          do not dump privileges (grant/revoke)不要转储权限 (grant/revoke)
      --binary-upgrade             for use by upgrade utilities only(只能由升级工具使用)
      --column-inserts             dump data as INSERT commands with column names(以带有列名的INSERT命令形式转储数据)
      --disable-dollar-quoting     disable dollar quoting, use SQL standard quoting(取消美元 (符号) 引号, 使用 SQL 标准引号)
      --disable-triggers           disable triggers during data-only restore在只恢复数据的过程中禁用触发器
      --exclude-table-data=TABLE   do NOT dump data for the named table(s)(以INSERT命令，而不是COPY命令的形式转储数据)
      --inserts                    dump data as INSERT commands, rather than COPY
      --no-security-labels         do not dump security label assignments
      --no-synchronized-snapshots  do not use synchronized snapshots in parallel jobs
      --no-tablespaces             do not dump tablespace assignments不转储表空间分配信息
      --no-unlogged-table-data     do not dump unlogged table data
      --quote-all-identifiers      quote all identifiers, even if not key words
      --section=SECTION            dump named section (pre-data, data, or post-data)
      --serializable-deferrable    wait until the dump can run without anomalies
      --use-set-session-authorization
                              use SET SESSION AUTHORIZATION commands instead of
                              ALTER OWNER commands to set ownership
      ```

  * Connection options:(控制连接的选项)

      ```md
      -d, --dbname=DBNAME      database to dump (数据库名)
      -h, --host=HOSTNAME      database server host or socket directory(数据库服务器的主机名或套接字目录)
      -p, --port=PORT          database server port number(数据库服务器的端口号)
      -U, --username=NAME      connect as specified database user(以指定的数据库用户联接)
      -w, --no-password        never prompt for password(永远不提示输入口令)
      -W, --password           force password prompt (should happen automatically)(强制口令提示 (自动))
      --role=ROLENAME          do SET ROLE before dump
      ```

</br>

### [还原](#目录)

* Usage:

  > psql [option]... [dbname [username]]
  >
  > pg_

* Options

</br>

### [栗子](#目录)

* [备份数据库](#备份数据库)
* [还原数据库](#还原数据库)

</br>

#### [备份数据库](#栗子)

* 常用备份
  > pg_dump [-h 127.0.0.1 -p 5432] -U username [-c -C] -d db_name  -f db_backup.sql
  >
  > pg_dump [-h 127.0.0.1 -p 5432] -U username [-c -C] -d db_name > db_backup.sql

* 备份归档格式
  > pg_dump [-h 127.0.0.1 -p 5432] -U username [-c -C] -F c -d db_name  -f db_backup.sql

* 备份指定模式（schema） `-n` `-N`
  > pg_dump [-h 127.0.0.1 -p 5432] -U username -d db_name -n schema_name [-n schema_name2]... -f db_backup.sql
  >
  > pg_dump [-h 127.0.0.1 -p 5432] -U username  [-c -C] -d db_name -N schema_name [-N schema_name2]... -f db_backup.sql
  
  note:
  * -n: 指定备份的模式, 可以指定多个模式
  * -N： 指定不备份的模式, 可以指定多个模式
  * 还原时，不指定数据库默认还原到postgres库

* 只备份模式（只备份所有模式，不备份数据） `-s`
  > pg_dump [-h 127.0.0.1 -p 5432] -U username [-c -C] -d db_name -s -f db_backup.sql

note

* `-c` 删除原数据库（备份文件中有删除原库的SQL）
* `-C` 创建数据库（备份文件中有创建原库名的新数据库）
  * `-c` 参数： 还原过程中会先删除原数据库；
  * 使用 `-C` 参数时，创建数据库并备份所有模式。还原时无需指定数据库，自动创建原库的同名库，并把所有模式还原其中；
  * 不使用 `-C` 参数时，只备份所有模式。还原时需要指定数据库；

note:

* -C 在转储中创建数据库的命令，还原时无需在导入之前先建数据库

#### [还原数据库](#栗子)

* 常用还原
  > psql [-h 127.0.0.1 -p 5432] -U username -d db_name -f db_backup.sql
  >
  > psql [-h 127.0.0.1 -p 5432] -U username -d db_name > db_backup.sql

* 还原

* 修改所有表 `OWNER`(postgres用户 除外)
  
  > REASSIGN OWNED BY old_role [, ...] TO new_role

</br></br>

Reference

* <https://www.cnblogs.com/BillyYoung/p/11057854.html>
* <https://www.postgresql.org/docs/9.6/sql-reassign-owned.html>
