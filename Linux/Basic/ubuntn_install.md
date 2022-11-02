# Ubuntu下安装和卸载软件

## apt-get

| 操作 | 命令 |
| ---- | ---- |
| 更新源 | sudo apt-get update |
| 安装 | sudo apt-get install <pkg_name> |
| 卸载 | sudo apt-get purge <pkg_name> |
| 修复依赖 | sudo apt-get -f install |
| 卸载依赖 | sudo apt-get autoremove |

## dpkg

| 操作 | 命令 |
| ---- | ---- |
| 安装 | sudo dpkg -i <pkg_name> |
| 卸载 | dpkg -P <pkg_name> |
| 查找 | sudo dpkg-query -W "*chrome*" |
| 修复依赖 | sudo apt-get -f install |
| 卸载依赖 | sudo apt-get autoremove |

## yum

TODO yum

## rpm

TODO rpm

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

- http://c.biancheng.net/view/2952.html
- https://rqsir.github.io/2019/04/13/linux-make-install%E7%9A%84%E5%AE%89%E8%A3%85%E4%B8%8E%E5%8D%B8%E8%BD%BD/
- https://blog.csdn.net/wangkai_123456/article/details/109071813
- https://blog.csdn.net/liudsl/article/details/79200134

TAG Unreleased
