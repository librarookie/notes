-- database

-- 1.学生表
-- student(s_id, s_name, s_age, s_sex) --s_id 学生编号,s_name 学生姓名,s_age 出生年月,s_sex 学生性别

-- 2.课程表
-- course(c_id, c_name, t_id) --c_id --c_id 课程编号,c_name 课程名称,t_id 教师编号

-- 3.教师表
-- teacher(t_id, t_name) --t_id 教师编号,t_name 教师姓名

-- 4.成绩表
-- credits(s_id, c_id, score) --s_id 学生编号,c_id 课程编号,score 分数


-- 添加测试数据
-- 1.学生表

create table student(s_id varchar(10), s_name nvarchar(10), s_age datetime, s_sex nvarchar(10));

insert into student values('01' , '赵雷' , '1990-01-01' , '男');

insert into student values('02' , '钱电' , '1990-12-21' , '男');

insert into student values('03' , '孙风' , '1990-05-20' , '男');

insert into student values('04' , '李云' , '1990-08-06' , '男');

insert into student values('05' , '周梅' , '1991-12-01' , '女');

insert into student values('06' , '吴兰' , '1992-03-01' , '女');

insert into student values('07' , '郑竹' , '1989-07-01' , '女');

insert into student values('08' , '王菊' , '1990-01-20' , '女');

-- 2.课程表

create table course(c_id varchar(10), c_name nvarchar(10), t_id varchar(10));

insert into course values('01' , '语文' , '02');

insert into course values('02' , '数学' , '01');

insert into course values('03' , '英语' , '03');

-- 3.教师表

create table teacher(t_id varchar(10), t_name nvarchar(10));

insert into teacher values('01' , '张三');

insert into teacher values('02' , '李四');

insert into teacher values('03' , '王五');

-- 4.成绩表

create table credits(s_id varchar(10), c_id varchar(10), score decimal(18,1));

insert into credits values('01' , '01' , 80);

insert into credits values('01' , '02' , 90);

insert into credits values('01' , '03' , 99);

insert into credits values('02' , '01' , 70);

insert into credits values('02' , '02' , 60);

insert into credits values('02' , '03' , 80);

insert into credits values('03' , '01' , 80);

insert into credits values('03' , '02' , 80);

insert into credits values('03' , '03' , 80);

insert into credits values('04' , '01' , 50);

insert into credits values('04' , '02' , 30);

insert into credits values('04' , '03' , 20);

insert into credits values('05' , '01' , 76);

insert into credits values('05' , '02' , 87);

insert into credits values('06' , '01' , 31);

insert into credits values('06' , '03' , 34);

insert into credits values('07' , '02' , 89);

insert into credits values('07' , '03' , 98);





/*
varchar 和 nvarchar的区别（推荐是用nvarchar）
    1. varchar是非unicode可变长度类型，nvarchar是unicode编码可变长度类型
    2. 它们两者的最大长度不一样。(nvarchar的最大值是4000， varchar最大值是8000)
    3. varchar能存储的字节数就是它的长度，nvarchar能存储的字节数是它 长度的2倍
    4. nvarchar是支持多种语言，可以避免每次从数据库读取或写入时候，进行编码转换，转换需要时间，并且很容易出错。
*/

/*
decimal是mysql中存在的精准数据类型，语法格式“decimal(m,d)”。
    -- 其中，m是数字的最大数（精度），其范围为“1～65”，默认值是10；
    -- d是小数点右侧数字的数目（标度），其范围是“0～30”，但不得超过m。

mysql中支持浮点数的类型有float、double和decimal类型，decimal 类型不同于float和double，decimal 实际是以串存放的。
    decimal 可能的最大取值范围与double 一样，但是其有效的取值范围由m 和d 的值决定。如果改变m 而固定d，则其取值范围将随m 的变大而变大
    说明：float占4个字节，double占8个字节，decimail(m,d)占m+2个字节。

    当数值在其取值范围之内，小数位多了，则直接截断小数位。
    若数值在其取值范围之外，则用最大(小)值对其填充。
*/
