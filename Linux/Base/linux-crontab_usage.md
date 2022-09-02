# Linux-crontab 定时任务设置

</br>
</br>

> `crontab` 是一个命令，常见于Unix和类Unix的操作系统之中，用于设置周期性被执行的指令。

## 用法

- crontab [-u user] file
- crontab [ -u user ] [ -i ] { -e | -l | -r }

</br>

## 参数

- `-e` - 编辑用户的定时任务 (edit user's crontab)
- `-l` - 列出用户的定时任务 (list user's crontab)
- `-r` - 删除用户的定时任务 (delete user's crontab)
- `-i` - 在删除用户的定时任务前提示 (prompt before deleting user's crontab)

</br>

## 栗子

- 编辑

    > crontab -e

- 执行计划 (每天23点执行 `service iptables status` 命令)

    `00 23 * * *  service iptables status`

- 详情

    ```sh
    # 格式介绍

    *  *  *  *  *  commad
    分 时  日 月 周  命令

    # 第 `1` 列表示分钟 `1~59`, 每分钟用 `*` 或者 `*/1`表示

    # 第 `2` 列表示小时 `1~23` (0表示0点)

    # 第 `3` 列表示日期 `1~31`

    # 第 `4` 列表示月份 `1~12`

    # 第 `5` 列表示星期 `0~6` (0表示星期日)

    # 第 `6` 列是要运行的命令
    ```

</br>
</br>
