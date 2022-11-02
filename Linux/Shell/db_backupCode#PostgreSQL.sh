#!/bin/bash
# PostgreSQL数据库备份脚本


# PG家目录(/opt/postgresql/pg96/)
PG_HOME=${PGHOME}
# pg数据库连接信息
PG_HOST="127.0.0.1"
PG_PORT="5432"
PG_USER="postgres"
# PG_PASSWD="pg@123456"

# 时间格式化,如 20211216
DATE="`date +%Y%m%d`"
# 备份文件目录
DIR_BACKUP="${HOME}/data/pg-backup"
# 日志目录: ${HOME}/data/db-backup/logs
DIR_LOG="${DIR_BACKUP}/logs"
# 日志文件: ${HOME}/data/db-backup/logs/db_backup.INFO.2021-12-30.log
FILE_LOG="${DIR_LOG}/db_backup.INFO.`date +%F`.log"

# 文件保留天数
DAY=7
DAY_LOG="`expr ${DAY} + 7`"
# 备份数据库名, 多数据间空格分隔
DATABASES=("db1" "db2" "db3")


# 测试目录， 目录不存在则自动创建
test -d ${DIR_LOG} || mkdir -p ${DIR_LOG}
test -d ${DIR_BACKUP}/${PG_USER}-${DATE} || mkdir -p ${DIR_BACKUP}/${PG_USER}-${DATE}
# ------------------- 2021-12-16_17:40:48 Start -------------------
echo -e "\n----------------- $(date +%F\ %T) Start -----------------"
echo -e "\n================= $(date +%F\ %T) Start =================" >> ${FILE_LOG}

# 遍历数据库名
for database in "${DATABASES[@]}"; do 
    echo "---------- Current backup database: [ ${database} ] ----------"
    echo "----------- Backed-up database: [ ${database} ] -----------" >> ${FILE_LOG}
    # 执行备份命令
    ${PG_HOME}/bin/pg_dump -h ${PG_HOST} -p ${PG_PORT} -U ${PG_USER} -w -d ${database} > ${DIR_BACKUP}/${PG_USER}-${DATE}/db_${database}_${DATE}.sql
done

# 压缩备份文件
cd ${DIR_BACKUP}
tar -czf ${PG_USER}-${DATE}.tar.gz ${PG_USER}-${DATE}/
echo "---------- Backup file created: [ ${PG_USER}-${DATE}.tar.gz ]"
echo "Backup file created: ${DIR_BACKUP}/${PG_USER}-${DATE}.tar.gz" >> ${FILE_LOG}

# 压缩后, 删除压缩前的备份文件和目录
rm -f ${DIR_BACKUP}/${PG_USER}-${DATE}/*
rmdir ${DIR_BACKUP}/${PG_USER}-${DATE}/


# ---------------------------------------------------------------------------------
# 至此, 备份已完成, 下面是清理备份的旧文件, 释放磁盘空间


# 方式一：清理旧文件
# 查找 7天前的文件
OLD_BACKUP="`find ${DIR_BACKUP} -type f -mtime +${DAY} -iname ${PG_USER}-\*.gz`"
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
# echo "`find ${DIR_BACKUP} -type f -mtime +${DAY} -iname ${PG_USER}-\*.gz`" >> ${FILE_LOG}
# echo "`find ${DIR_LOG} -type f -mtime +${DAY_LOG} -iname db_backup.INFO.\*.log`" >> ${FILE_LOG}
# find ${DIR_BACKUP} -type f -mtime +${DAY} -iname ${PG_USER}-\*.gz -exec rm -f {} \;
# find ${DIR_LOG} -type f -mtime +${DAY_LOG} -iname db_backup.INFO.\*.log -exec rm -f {} \;


echo -e "------------------ $(date +%F\ %T) End ------------------\n"
echo -e "================== $(date +%F\ %T) End ==================\n" >> ${FILE_LOG}
