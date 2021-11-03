-- Database

-- 1.学生表
-- Student(SID,Sname,Sage,Ssex) --SID 学生编号,Sname 学生姓名,Sage 出生年月,Ssex 学生性别

-- 2.课程表
-- Course(CID,Cname,TID) --CID --CID 课程编号,Cname 课程名称,TID 教师编号

-- 3.教师表
-- Teacher(TID,Tname) --TID 教师编号,Tname 教师姓名

-- 4.成绩表
-- SC(SID,CID,score) --SID 学生编号,CID 课程编号,score 分数


-- 添加测试数据
-- 1.学生表

create table Student(SID varchar(10),Sname nvarchar(10),Sage datetime,Ssex nvarchar(10));

insert into Student values('01' , '赵雷' , '1990-01-01' , '男');

insert into Student values('02' , '钱电' , '1990-12-21' , '男');

insert into Student values('03' , '孙风' , '1990-05-20' , '男');

insert into Student values('04' , '李云' , '1990-08-06' , '男');

insert into Student values('05' , '周梅' , '1991-12-01' , '女');

insert into Student values('06' , '吴兰' , '1992-03-01' , '女');

insert into Student values('07' , '郑竹' , '1989-07-01' , '女');

insert into Student values('08' , '王菊' , '1990-01-20' , '女');

-- 2.课程表

create table Course(CID varchar(10),Cname nvarchar(10),TID varchar(10));

insert into Course values('01' , '语文' , '02');

insert into Course values('02' , '数学' , '01');

insert into Course values('03' , '英语' , '03');

-- 3.教师表

create table Teacher(TID varchar(10),Tname nvarchar(10));

insert into Teacher values('01' , '张三');

insert into Teacher values('02' , '李四');

insert into Teacher values('03' , '王五');

-- 4.成绩表

create table SC(SID varchar(10),CID varchar(10),score decimal(18,1));

insert into SC values('01' , '01' , 80);

insert into SC values('01' , '02' , 90);

insert into SC values('01' , '03' , 99);

insert into SC values('02' , '01' , 70);

insert into SC values('02' , '02' , 60);

insert into SC values('02' , '03' , 80);

insert into SC values('03' , '01' , 80);

insert into SC values('03' , '02' , 80);

insert into SC values('03' , '03' , 80);

insert into SC values('04' , '01' , 50);

insert into SC values('04' , '02' , 30);

insert into SC values('04' , '03' , 20);

insert into SC values('05' , '01' , 76);

insert into SC values('05' , '02' , 87);

insert into SC values('06' , '01' , 31);

insert into SC values('06' , '03' , 34);

insert into SC values('07' , '02' , 89);

insert into SC values('07' , '03' , 98);




/*
varchar 和 nvarchar的区别（推荐是用nvarchar）
    1. varchar是非Unicode可变长度类型，nvarchar是Unicode编码可变长度类型
    2. 它们两者的最大长度不一样。(nvarchar的最大值是4000， varchar最大值是8000)
    3. varchar能存储的字节数就是它的长度，nvarchar能存储的字节数是它 长度的2倍
    4. nvarchar是支持多种语言，可以避免每次从数据库读取或写入时候，进行编码转换，转换需要时间，并且很容易出错。
*/

/*
decimal是MySQL中存在的精准数据类型，语法格式“DECIMAL(M,D)”。
    -- 其中，M是数字的最大数（精度），其范围为“1～65”，默认值是10；
    -- D是小数点右侧数字的数目（标度），其范围是“0～30”，但不得超过M。

MySQL中支持浮点数的类型有FLOAT、DOUBLE和DECIMAL类型，DECIMAL 类型不同于FLOAT和DOUBLE，DECIMAL 实际是以串存放的。
    DECIMAL 可能的最大取值范围与DOUBLE 一样，但是其有效的取值范围由M 和D 的值决定。如果改变M 而固定D，则其取值范围将随M 的变大而变大
    说明：float占4个字节，double占8个字节，decimail(M,D)占M+2个字节。

    当数值在其取值范围之内，小数位多了，则直接截断小数位。
    若数值在其取值范围之外，则用最大(小)值对其填充。
*/
