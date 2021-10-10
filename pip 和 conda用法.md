# Python 包管理工具 pip 与 conda

## 简介

> 1. pip是接触 python 后最早认识的包管理工具。通过使用 pip 能够自动下载和解决不同 python 模块的依赖问题，使 python 的配置过程变得简单。
> 2. 与 pip 类似，conda 也是一个开源软件的包管理系统和环境管理系统。conda 可分为 anaconda 和 miniconda，anaconda 包含一些科学计算常用的 python 包，miniconda 为精简版。

## 区别

* 不同

    | 类别 | pip | conda |
    |----|:--:|:--:|
    | 管理 | wheel 或源码 | 二进制 |
    | 需要编译器 | yes | no |
    | 语言 | Python | any |
    | 虚拟环境 | virtualenv \| venv | 支持 |
    | 依赖性检查 | 用户选择 | yes |
    | 包来源 | PyPi | Anaconda repo和cloud |

## 用法

* pip 和 conda 常用命令

    | 操作 | pip | conda |
    |----|:---|:---|
    | 版本 | pip --version | conda --version  |
    | 安装 | pip install pkg_name | conda install pkg_name  |
    | 卸载 | pip uninstall pkg_name | conda remove pgk_name |
    | 查看 | pip list | conda list |
    | 升级 | pip install pkg_name --upgrade | conda update pkg_name |
    | 查询 | pip search pkg_name | conda search pkg_name |

* conda 环境命令

    | 操作 | 命令 |
    | ---- | :--- |
    | 激活环境 | conda activate [env_name] |
    | 退出环境 | conde deactivate |
    | 查看环境 | conda env list </br> conda info --envs </br> conda info -e |
    | 新建环境 | conda create -n env_name [python=3.8] -y |
    | 指定环境目录 | conda create -p /path/env_name [python=3.8] -y |
    | 删除环境 </br> (指定目录环境用 p) | conda env remove -n env_name </br> conda remove -n env_name --all -y |
    | 克隆环境 | conda create -n env_new --clone env_name -y |
    | 导出环境 | conda env export > environment.yaml |
    | 导入环境 | conda env create -f environment.yaml |

</br></br>

reference

* <https://www.cnblogs.com/li12242/p/13180397.html>
* <https://www.cnblogs.com/jessepeng/p/11685170.html>
