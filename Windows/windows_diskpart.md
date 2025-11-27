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
dism /capture-image /imagefile:D:\recovery.wim /captureDir:R:\ /name:"recovery"
```

 **参数解释**：
  - `/capture-image`： 指定操作是“捕获镜像”。
  - `/imagefile:D:\recovery.wim`： 指定生成的镜像文件存放路径和名称。这里是在D盘根目录下创建名为`recovery.wim`的文件。
  - `/captureDir:R:\`： **指定要备份的源目录（旧参数sourceDir）**。这里指定了`R:\`盘。
  - `/name:"recovery"`： 为这个镜像提供一个名称。当同一个WIM文件中存储多个镜像时，这个名字用于区分它们。

 **总结**： 此命令是将`R:\`盘的内容备份到`D:\recovery.wim`，并给这个备份命名为“recovery”。
 
### 1.4 在新分区（F：\）中部署镜像：

```cmd
dism /apply-image /imagefile:D:\recovery.wim /index:1 /applyDir:F:\
```

**参数解释**：
  - `/apply-image`： 指定操作是“应用镜像”（即解包还原）。
  - `/imagefile:D:\recovery.wim`： 指定要使用的镜像文件路径。
  - `/index:1`： 指定要应用哪个镜像。WIM文件可以包含多个镜像（例如，一个“纯净系统”，一个“带软件的系统”），它们通过索引号（1, 2, 3...）来区分。这里应用的是第一个镜像。
  - `/applyDir:F:\`： **指定还原的目标路径（旧参数destinationdir）**。这里是要还原到`F:\`盘的根目录。

**总结**： 此条命令将`recovery.wim`文件中的第一个镜像（也就是我们上一步备份的那个）还原到`F:\`盘。

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
