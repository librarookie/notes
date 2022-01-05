#!/bin/bash
# MySQL数据库备份脚本


# 数据库连接信息
DB_HOST="127.0.0.1"
DB_PORT="3306"
DB_USER="root"
DB_PASSWD="root"

# 时间格式化,如 20211216
DATE="`date +%Y%m%d`"
# 备份文件目录
DIR_BACKUP="${HOME}/data/db-backup"
# 日志目录: ${HOME}/data/db-backup/logs
DIR_LOG="${DIR_BACKUP}/logs"
# 日志文件: ${HOME}/data/db-backup/logs/db_backup.INFO.2021-12-30.log
FILE_LOG="${DIR_LOG}/db_backup.INFO.`date +%F`.log"

# 文件保留天数
DAY=7
DAY_LOG="`expr ${DAY} + 7`"
# 备份数据库名
DATABASES=("db1 db2 db3")


# 测试目录， 目录不存在则自动创建
# test -d ${DIR_LOG} || echo passwd | sudo -S mkdir -p ${DIR_LOG}
test -d ${DIR_LOG} || mkdir -p ${DIR_LOG}
# ------------------- 2021-12-16_17:40:48 Start -------------------
echo -e "\n----------------- $(date +%F\ %T) Start -----------------"
echo -e "\n================= $(date +%F\ %T) Start =================" >> ${FILE_LOG}

    # 遍历数据库
    for database in ${DATABASES[@]}; do 
        # 打印备份的数据库名
        echo "----------- Current backup database: [ ${database} ] ------------"
        echo "-------------- Backed-up database: [ ${database} ] --------------" >> ${FILE_LOG}
    done
    # 备份指定的数据库
    mysqldump --opt --single-transaction --master-data=2 --default-character-set=utf8 -h${DB_HOST} -P${DB_PORT} -u${DB_USER} -p${DB_PASSWD} -B ${DATABASES} | gzip > ${DIR_BACKUP}/mysql_backup_${DATE}.sql.gz


# # 备份全部数据库
# mysqldump --opt --single-transaction --master-data=2 --default-character-set=utf8 -h${DB_HOST} -P${DB_PORT} -u${DB_USER} -p${DB_PASSWD} -A | gzip > ${DIR_BACKUP}/mysql_backup_${DATE}.sql.gz

echo "------- Backup file created: [ mysql_backup_${DATE}.sql.gz ]"
echo "------- Backup file created: [ mysql_backup_${DATE}.sql.gz ]" >> ${FILE_LOG}

# ---------------------------------------------------------------------------------
# 至此, 备份已完成, 下面是清理备份的旧文件, 释放磁盘空间


# 方式一：清理旧文件
# 查找 7天前的文件
OLD_BACKUP="`find ${DIR_BACKUP} -type f -mtime +${DAY} -iname mysql-\*.gz`"
OLD_LOGS="`find ${DIR_LOG} -type f -mtime +${DAY_LOG} -iname db_backup.INFO.\*.log`"

# 遍历旧备份文件
for bak in "${OLD_BACKUP[@]}"; do 
    # 删除旧备份
    rm -f ${bak}
    echo "------------------- Deleted old bak files -------------------" >> ${FILE_LOG}
    echo "${bak}" >> ${FILE_LOG}
done
# 遍历旧日志
for log in "${OLD_LOGS[@]}"; do 
    # 删除旧日志
    rm -f ${log}
    echo "------------------- Deleted old log files -------------------" >> ${FILE_LOG}
    echo "${log}" >> ${FILE_LOG}
done


# 方式二：清理旧文件
# echo "--------------------- Deleted old files ---------------------" >> ${FILE_LOG}
# echo "`find ${DIR_BACKUP} -type f -mtime +${DAY} -iname mysql-\*.gz`" >> ${FILE_LOG}
# echo "`find ${DIR_LOG} -type f -mtime +${DAY_LOG} -iname db_backup.INFO.\*.log`" >> ${FILE_LOG}
# find ${DIR_BACKUP} -type f -mtime +${DAY} -iname mysql-\*.gz -exec rm -f {} \;
# find ${DIR_LOG} -type f -mtime +${DAY_LOG} -iname db_backup.INFO.\*.log -exec rm -f {} \;


echo -e "------------------ $(date +%F\ %T) End ------------------\n"
echo -e "================== $(date +%F\ %T) End ==================\n" >> ${FILE_LOG}
