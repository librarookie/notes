# Linux软件管理

## apt/apt-get

| 操作 | 命令 |
| ---- | ---- |
| 更新源 | sudo apt/apt-get update |
| 安装包 | sudo apt/apt-get install <pkg_name>[=<version\>] |
| 升级包 | sudo apt/apt-get upgrade <pkg_name> |
| 卸载包 | sudo apt/apt-get remove/purge <pkg_name> |
| 查找包 | apt search <pkg_name> --names-only |
| 已安装 | apt list [<pkg_name>] -i/--installed |
| 修复依赖 | sudo apt-get -f install |
| 卸载依赖 | sudo apt-get autoremove |
| 历史版本 | apt-cache policy <pkg_name> |
| 可用版本 | apt list <pkg_name> -a/--all-versions </br> apt-cache madison <pkg_name> |
| 锁定版本 | sudo apt-mark hold <pkg_name> |
| 解锁锁定 | sudo apt-mark unhold <pkg_name> |
| 查看锁定 | apt-mark showhold |

## dpkg

| 操作 | 命令 |
| ---- | ---- |
| 安装 | sudo dpkg -i <deb_name> [--force-depends] |
| 卸载 | sudo dpkg -P <pkg_name> |
| 查找 | dpkg -l <pkg_name> </br> sudo dpkg-query -W "*chrome*" |
| 状态 | dpkg -s <pkg_name> |

## yum

TODO yum

| 操作 | 命令 |
| ---- | ---- |
| 更新源 | sudo yum clean all && sudo yum makecache |
| 安装包 | sudo yum install <pkg_name>[-<version\>] |
| 卸载包 | sudo yum remove <pkg_name> |
| 升级包 | sudo yum upgrade <pkg_name> </br> 升级所有： sudo yum update |
| 降级包 | sudo yum downgrade <pkg_name>-<version\> |
| 查找包 | yum search <pkg_name> |
| 已安装 | yum list installed [<pkg_name>] |
| 可用版本 | yum list <pkg_name> --showduplicates |
| 查看锁定 | yum versionlock list |
| 锁定版本 | sudo yum versionlock add <pkg_name>[-version] |
| 解锁锁定 | sudo yum versionlock delete <pkg_name> |
| 清空锁定 | sudo yum versionlock clear |

tip: 锁定版本需要自己安装 sudo yum install yum-plugin-versionlock


## rpm

TODO rpm

| 操作 | 命令 |
| ---- | ---- |
| 安装 | sudo rpm -i <rpm_name> |
| 卸载 | sudo rpm -e <rpm_name> |
| 升级 | sudo rpm -U <rpm_name> |
| 查找 | rpm -qa <rpm_name> |


## 源码编译安装

1. 检查环境
2. 

3. 安装（3步曲）
./configure
make
make install
2. 卸载
make uninstall（卸载时的源码目录所在路径与安装时的源码目录所在路径不同，不影响最终结果）

- 方便性角度。从方便性角度来看，“apt-get机制”最优，“dpkg机制”次之，“从源码编译安装机制”最末。“apt-get机制”已经预先解决依赖问题，“从源码编译安装机制”需要我们自己解决依赖问题
- 可定制性角度。从可定制性角度来看，“从源码编译安装机制”最优，“dpkg机制”次之，“apt-get机制”最末。“从源码编译安装机制”允许我们自定义安装参数，“apt-get机制”几乎完全采用默认的安装参数
- 安装用户所需权限角度。从安装用户所需权限角度来看，“从源码编译安装机制”所需权限可以是最小，“dpkg机制”次之，“apt-get机制”所需权限最大。在我们不拥有较高权限（比如root权限）的情况下，只能采用“从源码编译安装机制”

由于源码安排可以指定安装位置，所以在我们不拥有较高权限（比如root权限）的情况下，只能采用“从源码编译安装机制”
如果安装到目标目录需要是”root”权限才能操作，那么以上4个命令中，分别加上”sudo”

TODO 编译安装

</br>
</br>

Via

- <http://c.biancheng.net/view/2952.html>
- <https://rqsir.github.io/2019/04/13/linux-make-install%E7%9A%84%E5%AE%89%E8%A3%85%E4%B8%8E%E5%8D%B8%E8%BD%BD/>
- <https://blog.csdn.net/wangkai_123456/article/details/109071813>
- <https://blog.csdn.net/liudsl/article/details/79200134>

TAG Unreleased
