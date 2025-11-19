# wifi notfind

### 1. 确认网卡型号

```bash
$ lspci | grep -i network

02:00.0 Network controller: Broadcom Inc. and subsidiaries BCM43228 802.11a/b/g/n
```


### 2. 具体针对 BCM43228 的解决方案

根据 Debian Wiki，BCM43228 应该使用 **`b43` 驱动**而不是 `wl` 驱动。请按以下步骤操作：

1. **完全清理之前的尝试**：
   
   ```bash
   sudo apt remove --purge broadcom-sta-dkms
   sudo modprobe -r wl b43 bcma ssb
   ```
2. **删除之前的黑名单**：
   
   ```bash
   sudo rm -f /etc/modprobe.d/blacklist-b43.conf
   ```
3. **安装正确的固件**：
   
   ```bash
   sudo apt update
   sudo apt install firmware-b43-installer
   ```
4. **加载驱动**：
   
   ```bash
   sudo modprobe b43
   ```
5. **检查是否生效**：
   
   ```bash
   ip link
   ```
6. **排错**

	```bash
	dmesg | grep -i b43 | tail -20
	```

