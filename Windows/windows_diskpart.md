# Windows系统中管理和迁移“恢复分区“


## 一、创建新分区并迁移“恢复分区”


1. 分区环境

- 查看“恢复分区”信息
  reagentc /info
-  启用enable/停用disable“恢复分区”
  reagentc /disable

2. 磁盘管理

diskpart    #进入磁盘
list disk    #查看磁盘信息
select disk 0    #进入”磁盘 0“
list partition    #查看分区信息
select partition 4    #进入”分区 4“


* **创建日期**：

  1. **目标**：将“恢复分区”迁移到新分区（分区F）中。
  2. **操作步骤**：

     1. **创建新分区**：在磁盘 0 的最右侧分出一块新分区（分区 F），其容量需略大于当前的“恢复分区”（例如分区 4）。
     2. **给“恢复分区”分配盘符**：

        ```diskpart
        select disk 0
        list partition
        select partition 4
        assign letter=R  # 注意：原文为 assign letter=R，此处保留。
        exit
        ```
     3. **生成分区镜像并保存**：

        ```cmd
        dism /capture-image /imagefile:D:\recovery.wim /sourceDir:R:\ /sourceDir:R:\ /name:"recovery"
        ```
     4. **在新分区（F：\）中部署镜像**：

        ```cmd
        dism /apply-image /imagefile:D:\recovery.wim /index:1 /destinationdir:F:\
        ```
     5. **更新“恢复分区”的指针（停用、设置路径、启用）**：

        ```cmd
        reagentc /disable
        reagentc /setreimage /path F:\Recovery\WindowsRE
        reagentc /enable
        ```
     6. **将新分区（分区F）属性改为“恢复分区”**：

		```diskpart
		select disk 0
		select partition 6  # 注意：原文直接跳到partition 6，需确认是否正确
		set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
		gpt attributes=0x8000000000000001
		attributes volume set nodefaultdriveletter
		remove  # 注意：原文为“remove”，原始意图似乎是“remove letter”，但此处保留操作。
		exit
		```
     7. **重启系统生效**。

        **重启后检查**：使用 `shift + 重启` (此命令实际用于强制关机或重启，检查恢复分区通常在FEDL服务中操作，此步骤描述可能略有简化或不准确，请以实际情况为准)。
     8. **删除“旧恢复分区”**：

     ```diskpart
        select disk 0
        select partition 4
        delete partition override  # 注意：使用 override 参数强制删除
        exit
        ```
  3. **注意事项**：操作前请确保已备份重要数据。分区编号和盘符分配需根据实际磁盘布局确认。

---

## 二、使用 C 盘作为目标迁移“恢复分区”

* **创建日期**：创建于 2025-09-22 09:34:11;

  1. **目标**：将“恢复分区”迁移到 C 盘中。
  2. **操作步骤**：

     1. **查看“恢复分区”信息**：
        ```cmd
        reagentc /info  # 注意：原文此处拼写为“reagerc”，但正确应为“reagentc”。见第 3 条。
        ```
     2. **进入磁盘工具**：
        ```cmd
        diskpart
        ```
     3. **查看磁盘信息**：
        ```cmd
        list disk
        ```
     4. **选择目标磁盘 (0)**：
        ```cmd
        select disk 0
        ```
     5. **查看分区信息**：
        ```cmd
        list partition
        ```
     6. **选择“恢复分区”（例如分区 4）**：
        ```cmd
        select partition 4  # 注意：分区号需要根据实际情况确定
        ```
     7. **给“恢复分区”分配盘符** (R):
        ```cmd
        assign letter=R
        ```
     8. **手动复制恢复文件**：将 `R:/Recovery/WindowsRE` 文件夹中的必要文件复制到系统驱动器的 `C:/Recovery` 目录下。注意：这可能遇到权限问题，可尝试使用管理员权限运行命令提示符进行相关操作，或手动复制时使用管理员权限。
     9. **退出磁盘工具**：
        ```cmd
        exit
        ```
     10. **禁用“恢复分区”**：
         ```cmd
         reagentc /disable
         ```
     11. **更新“恢复分区”指针** (指向新位置 C：\) 注意：若手动复制了文件，需要指定 C 盘路径。
         ```cmd
         reagentc /setreimage /path C:\Recovery\WindowsRE  # 这里指定了 C 盘路径，请根据手动复制的实际位置确认。若手动复制失败或未做，则此步需跳过或调整。
         ```
     12. **启用“恢复分区”**：
         ```cmd
         reagentc /enable
         ```
     13. **删除“旧恢复分区 R”** (override 表示强制):
         ```diskpart
         select disk 0
         select partition 4  # 确认选择的是原恢复分区
         delete partition override  # 注意：使用 override 参数强制删除
         exit
         ```
     14. **退出磁盘工具**(重复)：
         ```cmd
         exit
         ```
  3. **后续操作**：删除旧分区后，可能还需要进行 `C盘扩容`。
  4. **重启生效**。

     **重启后检查**：使用 `shift + 重启` (此步骤描述待确认)。

---

## 三、分区环境与磁盘管理基础

* **创建日期**：创建于 2025-09-22 08:42:46;

  1. **查看“恢复分区”信息**：

     ```cmd
     reagentc /info  # 注意：原文此处也拼写为“reagerc”，应为“reagentc”。见第 1 条和第 2 条。
     ```
  2. **启用/停用“恢复分区”**：

     ```cmd
     reagentc /disable    # 停用分区（修复启动后通常会自动启用）
     reagentc /enable      # 启用分区
     ```
  3. **磁盘管理基础**：

     ```cmd
     diskpart            # 进入磁盘分区管理工具
     #...
     ```
     操作 `diskpart`：

     ```
     list disk            # 查看磁盘信息
     select disk 0        # 选择磁盘 0 (需要知道磁盘号)
     list partition       # 查看磁盘分区信息
     select partition 4   # 选择分区 4 (需要知道分区号)
     ```
     等等。具体操作需根据当前情况决定。
