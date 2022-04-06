# sql problem

</br>
</br>

## 面试题

</br>

### 简单查询

#### 如何查找重复数据？

- 查找学生表中所有重复的学生名

    ```py
    SELECT s_name,COUNT(s_name) AS 计数 sum FROM Student
    GROUP BY s_name
    HAVING sum >1;
    ```

Ideas:

- 看到 “找重复” 的关键字眼，首先要用分组函数（`group by`），再用聚合函数中的计数函数 `count()` 给姓名列计数。
- 分组汇总后，从该表里选出计数 `大于 1` 的姓名，就是重复的姓名。
- 拓展：找出重复出现 `n 次`的数据。只需要改变 `having` 语句中的条件即可
- SQL 子句的运行顺序：`FROM > WHERE > GROUP_BY > HAVING > SELECT > ORDER_BY > LIMIT`
- SQL 子句的书写顺序如下：

  ```py
    (8) SELECT (9)DISTINCT<Select_list>
    (1) FROM <left_table> (3) <join_type>JOIN<right_table>
    (2) ON<join_condition>
    (4) WHERE<where_condition>
    (5) GROUP BY<group_by_list>
    (6) WITH {CUBE|ROLLUP}
    (7) HAVING<having_condtion>
    (10) ORDER BY<order_by_list>
    (11) LIMIT<limit_number>
  ```

Tips:

- 如果添加一个 `s_sex` 字段，就如出现如下错误：
  - > `1055 - Expression #3 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'testdb.Student.s_sex' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by`
  - 原因：问题字段既不在分组中也不在 `Aggregate 函数` 中，那么在相同的分组中，这个字段的值可能是不同的，系统不知道要如何选择；
  - 解决方案：
    1. 优化代码，剔除 select 语句中的多余字段，也就是不要触发 only_full_group_by（推荐）
    2. 使用 `any_value()` 函数来包装值。告诉系统，你可以随意返回值（如果你必须要出现这个字段，那么这是推荐的方式）
    3. 关闭 `sql_mode=ONLY_FULL_GROUP_BY`（不推荐）

</br>

### 复杂查询

#### 如何查找第 N 高的数据？

</br>

### 多表查询

#### 多表如何查询?

#### 如何查找不在表里的数据？

#### 你有多久没涨过工资了？

#### 如何比较日期数据？

#### 如何交换数据？

#### 【滴滴】如何找出最小的 N 个数?

#### 行列互换问题，怎么办？

#### 找出连续出现 N 次的内容？

#### 【链家】如何分析留存率？

</br>

### 查询

#### 【拼多多】如何查找前 20% 的数据？

#### 如何查找工资前三高的员工？

#### 如何查找第 N 高的数据?

#### 双 11 用户如何分析？

#### 如何分析游戏？

</br>

### 查询实战

#### 滴滴 2020 求职真题

#### 【滴滴】打车业务问题如何分析？

#### 【电商】如何分析复杂业务？

#### 如何分析用户满意度？

#### 如何分析红包领取情况?

#### 如何分析中位数？

#### 【小红书】如何分析用户行为？

#### 【教育行业】学员续费如何分析？

#### 【字节跳动】你的平均薪水是多少？
