# Linux-crontab 定时任务配置

</br>
</br>

![202211021502430](https://gitee.com/librarookie/picgo/raw/master/img/202211021502430.png "202211021502430")

## 介绍

> `crontab` 是一个命令，常见于Unix和类Unix的操作系统之中，用于设置周期性被执行的指令。

- Linux crontab 是用来定期执行程序的命令。
- crontab 可理解为 cron_table，表示 cron 的任务列表。
- crontab 的服务进程名为 crond，英文意为周期任务。
- crond 每分钟会定期检查是否有要执行的工作，如果有要执行的工作便会自动执行该工作。

而 linux 任务调度的工作主要分为以下两类：

1. 系统执行的工作： 系统周期性所要执行的工作，如备份系统数据、清理缓存
2. 个人执行的工作： 某个用户定期要做的工作，例如每隔 10 分钟检查邮件服务器是否有新信，这些工作可由每个用户自行设置

关于crontab的用途很多，如

- 定时系统检测；
- 定时数据采集；
- 定时日志备份；
- 定时更新数据缓存；
- 定时生成报表 ...

Tips： 新创建的 cron 任务，不会马上执行，至少要过 2 分钟后才可以，当然你可以重启 cron 来马上执行。

</br>

## 语法

> crontab 是用来让使用者在固定时间或固定间隔执行程序之用，换句话说，也就是类似使用者的时程表或定时任务。

- 用法

    ```sh
    crontab [-u user] file
    # Or
    crontab [ -u user ] [ -i ] { -e | -l | -r }
    ```

- 参数

    ```sh
    -u user # 是指设定指定 user 的时程表，这个前提是你必须要有其权限(比如说是 root)才能够指定他人的时程表。如果不使用 -u user 的话，就是表示设定自己的时程表。
    -i      # 在删除用户的定时任务前提示 (prompt before deleting user's crontab)
    -e      # 编辑用户的定时任务列表，保存会检查任务配置是否符合规则。 (等同打开任务列表配置文件，路径 `/var/spool/cron/` 下，文件以用户名命名，如 /var/spool/cron/root)
    -l      # 列出用户的定时任务列表
    -r      # 删除用户的定时任务列表
    ```

</br>

## 规则

### 任务格式

> 验证网站： <https://crontab.guru/>

```sh
.--------------------- 分 minute (0 - 59)
|  .------------------ 时 hour (0 - 23)
|  |  .--------------- 日 day of month (1 - 31)
|  |  |  .------------ 月 month (1 - 12) OR jan,feb,mar,apr,may,jun,jul,aug,sept,oct,nov,dec
|  |  |  |  .--------- 周 day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
|  |  |  |  |    .---- 执行的命令或程序
|  |  |  |  |    |
*  *  *  *  *  command-to-be-executed
```

- 第 `1` 列表示 “分钟” `0 - 59`
- 第 `2` 列表示 “小时” `0 - 23` (0 表示 24点)
- 第 `3` 列表示 “日期” `1 - 31`
- 第 `4` 列表示 “月份” `1 - 12` 或者用月份缩写，即 `jan`,`feb`,`mar`,`apr`,`may`,`jun`,`jul`,`aug`,`sept`,`oct`,`nov`,`dec`
- 第 `5` 列表示 “星期” `0 - 6` (0 或 7 表示星期日) OR 或用周缩写，即 `sun`,`mon`,`tue`,`wed`,`thu`,`fri`,`sat`
- 第 `6` 列是执行的 “命令或程序” (多个命令用分号 `;` 隔开) 即 command1；command2

</br>

### 时间格式

- `*` 的格式介绍：

    1. `*` 表示所有时间执行。
         - 如 `1 为 *` 表示每分钟执行，`2 为 *` 表示每小时执行，以此类推
    2. `n-m` 表示 n 到 m 时间执行。
         - 如 `1 为 n-m` 表示从第 n 到第 m 分钟执行，`2 为 n-m` 表示从第 n 到第 m 小时执行，以此类推
    3. `a, b, c,...` 表示第 a, b, c,... 时刻执行。
         - `1 为 a, b, c` 表示第 a, b, c...个分钟要执行，`2 为 a, b, c` 表示第 a, b, c...个小时要执行，以此类推
    4. `*/n` 表示每 n 时间间隔执行一次。如
         - `1 为 */n` 表示每 n 分钟个时间间隔执行一次,`2 为 */n` 表示每 n 小时个时间间隔执行一次，以此类推

- Crontab 范例

    | 格式 | 执行时间 |
    | :--- | :--- |
    | `* * * * *` | 每分钟执行 |
    | `*/10 * * * *` | 每10分钟执行 |
    | `0 * * * *` | 每小时执行 |
    | `0 0 * * *` | 每天执行 |
    | `0 0 * * 0` | 每周执行 |
    | `0 0 1 * *` | 每月执行 |
    | `0 0 L * *` | 每月底执行 |
    | `0 0 1 1 *` | 每年执行 |

如果不确定书写的定时任务是否符合需求，可以去此地址进行验证：

<https://crontab.guru/>

</br>

## 特殊符号 `%`

> % 在 crontab 是特殊符号，第一个 % 表示 `标准输入（STDIN）` 的开始，其他 % 用于表示crontab条目中的一个新行。

### `%` 例子

- 例1，一个 `%`

    `* * * * * cat >> /tmp/cat.txt 2>&1 % stdin input`

    输出如下

    ```sh
    $ cat /tmp/cat.txt
    stdin input
    ```

    Tips: `cat >> /tmp/cat.txt` 作用是将标准输入重定向至/tmp/cat.txt。

- 例2，多个 `%`

    `* * * * * cat >> /tmp/cat_line.txt 2>&1 % stdin input 1 % stdin input 2 % stdin input 3`

    第一个 `%` 为标准输入开始，后面的 `%` 相当于换行符，故输出如下

    ```sh
    $ cat /tmp/cat_line.txt
    stdin input 1
    stdin input 2
    stdin input 3
    ```

</br>

### `%` 使用

> 如何将 crontab 行中的%作为 `%` 而不是作为新行使用？

1. 转义 `%`

    `* * * * * cat >> /tmp/cat_special.txt 2>&1 % per cent is \%. 2>&1`

    输出如下

    ```sh
    $ cat /tmp/cat_special.txt
    per cent is %.
    ```

2. shell脚本

    将命令写入 shell脚本，然后 cron 执行 shell脚本即可避免 % 问题，shell脚本格式如下

    ```sh
    #/bin/sh

    command
    ```

3. 通过 `sed` 传递文本

    `* * * * echo '% another \% minute \% has \% passed'| sed -e 's|\\|| g'`

    输出如下

    ```sh
    % another % minute % has % passed
    ```

    常用场景：

    ```sh
    在crontab中使用MySQL命令时，这种技术非常有用。MySQL命令中经常出现 %，如下

    SET @monyy=DATE_FORMAT(NOW(),"%M %Y")
    SELECT * FROM table WHERE name LIKE 'fred%'
    
    因此，要有一个crontab条目来运行MySQL命令

    mysql -vv -e "SELECT * FROM table WHERE name LIKE 'Fred%'" member_list

    将必须在crontab中显示为

    echo "SELECT * FROM table WHERE name LIKE 'Fred\%'" | sed -e 's|\||g' | mysql -vv member_list

    把crontab的拆开如下：

    1. echo 命令将 MySQL命令发送到 STDOUT
    2. sed 在将输出发送到 STDOUT 之前删除了任何 反斜杠（\）
    3. mysql命令处理器从 STDIN 读取其命令。
    ```

</br>

## 调试

1. 命令是否正确
    - 将执行结果重新向到日志文件并查看

        `* * * * * php /root/index.php >> /tmp/debug.log 2>&1`

    - 将命令部分直接在 shell 中执行并检查

2. 任务是否执行
    - 检查 crond 服务是否启动

        ```sh
        service crond status    # 查看
        service crond start     # 启动
        service crond restart   # 重启
        ```

    - 查看日志，检查任务执行情况

        crontab 日志文件位置： `/var/log/cron` ，部分内容如下

        ```sh
        ...
        Dec 31 19:17:01 localhost crond[1455]: (CRON) bad day-of-week (/var/spool/cron/root)   # /var/spool/cron/root的任务配置有错
        Dec 31 19:17:01 localhost CROND[4409]: (root) CMD (date) ...                # 12月21 19时17分1秒执行了date命令。
        ```

        Ubuntu 默认不生成cron日志文件，需要手动开启 cron 日志，操作如下

        ```sh
        # 1. 修改 系统日志（rsyslog）服务配置
        $ sudo vim /etc/rsyslog.d/50-default.conf
        然后找到 cron.* ，把前面的 # 去掉，保存退出
        # 2. 重启 rsyslog 和 cron 服务
        $ service rsyslog restart
        $ service cron restart
        ```

</br>

## 栗子

### 时间配置段类型

- 根据时间列中值的不同设置方式，总结出以下五种类型：

    ```sh
    1. 固定某值，指定固定值，如指定1月1日0时0分执行任务
    0 0 1 1 * command

    2. 列表值，时间值是一个列表，如指定一个月内2、12、22日0时执行任务
    0 0 2,12,22 * * command
    # 上述日指定多个值，2号、12号和22号，以英文逗号分隔；

    3. 连续范围值，时间为连续范围的值，如指定每个月1至9号0时执行任务
    0 0 1-9 * * command
    # 上述日期为连续范围的值 1 到 9 号

    4. 步长值，根据指定数值跳跃步长确定执行时间，如指定凌晨1时开始每割3个小时0分执行一次任务
    0 0-23/3 * * * command
    # 上述指定从凌晨0时每3个小时执行任务，如0点0分，4点0分，7点0分等。

    5. 混合值，支持以上类型的组合，如指定每小时0至10分，22、33分以及0-60分钟每隔20分钟执行任务，如下
    0-10,22,33,*/20 * * * * command
    # 这里的分钟值采取了多种类型组合指定，包括连续范围值(0-10)，列表值(22,33)，步长值(*/20)。
    ```

</br>

### 常用实例

- 在 12 月内, 每天的早上 6 点到 12 点，每隔 3 个小时 0 分钟执行一次 /usr/bin/backup：

    `0 6-12/3 * 12 * /usr/bin/backup`

- 每月每天的午夜 0 点 20 分, 2 点 20 分, 4 点 20 分....执行 echo "haha"：

    `20 0-23/2 * * * echo "haha"`

- 特定的某几个月或某几天执行任务

    `* * * jan,may,aug * /script/script.sh`

    `0 17 * * sun,fri /script/scripy.sh`

- 多个任务在一条命令中配置

    `* * * * * /scripts/script.sh; /scripts/scrit2.sh`

- 每年执行一次任务

    `@yearly /scripts/script.sh`

- 系统重启时执行

    `@reboot /scripts/script.sh`

</br>
</br>

Via

- <https://zhuanlan.zhihu.com/p/58719487>
- <https://www.hcidata.info/crontab.htm>
