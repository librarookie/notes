# Windows系统中，磁盘迁移“恢复分区“



## 方案一、将“恢复分区”迁移到“新分区”

> 将“恢复分区（例如分区 4）”迁移到新分区（分区F）中。

### 1.1 创建新分区

在磁盘 0 的最右侧分出一块新分区（分区 F），其容量需略大于当前的“恢复分区”。

### 1.2 给“恢复分区”分配盘符：
```cmd
diskpart    #进入磁盘管理

select disk 0    #选择第一个磁盘
list partition   #列出所有分区
select partition 4    #选择分区 4
assign letter=R    #分配盘符为 R
exit
```

### 1.3 生成”分区镜像“并保存：
```cmd
dism /capture-image /imagefile:D:\recovery.wim /sourceDir:R:\ /sourceDir:R:\ /name:"recovery"
```

### 1.4 在新分区（F：\）中部署镜像：
```cmd
dism /apply-image /imagefile:D:\recovery.wim /index:1 /destinationdir:F:\
```

### 1.5 更新“恢复分区”的指针

```cmd
reagentc /info    #查看分区
reagentc /disable    #停用恢复分区
reagentc /setreimage /path F:\Recovery\WindowsRE
reagentc /enable    #启用恢复分区
```

### 1.6 将新分区（分区F）属性改为“恢复分区”：

```cmd
diskpart

select disk 0
list partition
select partition 6  #根据自己的环境选择
set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
gpt attributes=0x8000000000000001
attributes volume set nodefaultdriveletter
remove    #移除分区盘符
exit
```

### 1.7 重启检查

`shift + 重启`：重启系统后检查 (此命令实际用于强制关机或重启)。

### 1.8 删除“旧恢复分区”：

```cmd
diskpart

select disk 0
select partition 4
delete partition override  #使用 override 参数强制删除
exit
```
  
tips：操作前请确保已备份重要数据。分区编号和盘符分配需根据实际磁盘布局确认。

---

## 方案二、将”恢复分区“迁移到”C盘“

### 2.1 查看“恢复分区”信息：

```cmd
reagentc /info  # 注意：原文此处拼写为“reagerc”，但正确应为“reagentc”。见第 3 条。
```

### 2.2 给“恢复分区”分配盘符（如 R）
 
```cmd
diskpart  #进入磁盘工具

list disk  #查看磁盘信息
select disk 0  #选择目标磁盘
list partition  查看分区信息
select partition 4  #选择“恢复分区”，例如“分区 4”（分区号需要根据实际情况确定）
assign letter=R  #分配盘符R
```
  
### 2.3 迁移”恢复分区“文件

**手动复制恢复文件**：将`R:/Recovery/WindowsRE`"复制到 `C:/Recovery` 目录下
tips：此操作可能会遇到权限问题，可尝试使用管理员权限，或 administrator用户操作。

### 2.4 更新“恢复分区”指针

```cmd
exit  #退出磁盘工具
reagentc /disable  #禁用“恢复分区”
#更新指针，指定 2.3 复制的目录路径（请根据手动复制的实际位置确认）。
reagentc /setreimage /path C:\Recovery\WindowsRE
reagentc /enable  #启用“恢复分区”
```

### 2.5 删除“旧恢复分区 R”

 ```cmd
 diskpart
 
 select disk 0
 select partition 4  # 确认选择的是原恢复分区
 delete partition override  # 注意：使用 override 参数强制删除
 exit
 ```

### 2.6 重启检查

`shift + 重启`：重启系统后检查 (此命令实际用于强制关机或重启)。
