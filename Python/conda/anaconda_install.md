# Anaconda 安装与卸载

</br>
</br>

## 安装

> Anaconda是一个免费开源的Python和R语言的发行版本，用于计算科学（数据科学、机器学习、大数据处理和预测分析），Anaconda致力于简化软件包管理系统和部署。Anaconda的包使用软件包管理系统Conda进行管理。超过1200万人使用Anaconda发行版本，并且Anaconda拥有超过1400个适用于Windows、Linux和MacOS的数据科学软件包。     -wikipedia

* 下载
  * Anaconda 官网下载：<https://www.anaconda.com/products/individual#Downloads>
  * 清华大学开源软件镜像站：<https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/>

  Tips: Anaconda官网是外国网站，速度非常慢，建议去清华大学开源软件镜像站下载

* 安装（Linux）
  * 授权并执行

    ```sh
    # 给下载的sh文件执行权限
    chmod a+x Anaconda3-2021.05-Linux-x86_64.sh

    # 执行安装文件
    ./Anaconda3-2021.05-Linux-x86_64.sh
    ```
  
  * 安装输出日志

    ```sh
    Welcome to Anaconda3 2021.05

    In order to continue the installation process, please review the license
    agreement.
    Please, press ENTER to continue
    >>>     按回车键（ENTER）继续
    ===================================
    End User License Agreement - Anaconda Individual Edition
    ===================================

    Copyright 2015-2021, Anaconda, Inc.

    All rights reserved under the 3-clause BSD License:
    ...
    ... license日志
    ...


    The following packages listed on https://www.anaconda.com/cryptography are inclu
    ded in the repository accessible through Anaconda Individual Edition that relate
    to cryptography.

    Last updated April 5, 2021

    Do you accept the license terms? [yes|no]
    [no] >>>   yes （yes接受继续，no拒绝退出安装）

    Anaconda3 will now be installed into this location:
    /home/noname/anaconda3

    - Press ENTER to confirm the location
    - Press CTRL-C to abort the installation
    - Or specify a different location below

    [/home/noname/anaconda3] >>> /usr/sdk/anaconda3  （此处可自定义安装路径，不填则为默认路径，一般在用户根目录）
    PREFIX=/usr/sdk/anaconda3
    Unpacking payload ...
    Collecting package metadata (current_repodata.json): done                       
    Solving environment: done

    ## Package Plan ##

    environment location: /usr/sdk/anaconda3

    added / updated specs:
        - _ipyw_jlab_nb_ext_conf==0.1.0=py38_0
        - _libgcc_mutex==0.1=main
        - alabaster==0.7.12=pyhd3eb1b0_0
    ...
    ... anaconda基础环境包安装日志
    ...


    Preparing transaction: done
    Executing transaction: done
    installation finished.
    Do you wish the installer to initialize Anaconda3
    by running conda init? [yes|no]
    [no] >>> yes （是否初始化）
    no change     /usr/sdk/anaconda3/condabin/conda
    no change     /usr/sdk/anaconda3/bin/conda
    no change     /usr/sdk/anaconda3/bin/conda-env
    no change     /usr/sdk/anaconda3/bin/activate
    no change     /usr/sdk/anaconda3/bin/deactivate
    no change     /usr/sdk/anaconda3/etc/profile.d/conda.sh
    no change     /usr/sdk/anaconda3/etc/fish/conf.d/conda.fish
    no change     /usr/sdk/anaconda3/shell/condabin/Conda.psm1
    no change     /usr/sdk/anaconda3/shell/condabin/conda-hook.ps1
    no change     /usr/sdk/anaconda3/lib/python3.8/site-packages/xontrib/conda.xsh
    no change     /usr/sdk/anaconda3/etc/profile.d/conda.csh
    modified      /home/noname/.bashrc

    ==> For changes to take effect, close and re-open your current shell. <==

    If you'd prefer that conda's base environment not be activated on startup, 
    set the auto_activate_base parameter to false: 

    conda config --set auto_activate_base false

    Thank you for installing Anaconda3!

    ===========================================================================

    Working with Python and Jupyter notebooks is a breeze with PyCharm Pro,
    designed to be used with Anaconda. Download now and have the best data
    tools at your fingertips.

    PyCharm Pro for Anaconda is available at: https://www.anaconda.com/pycharm

    ```

</br>

## 配置

> 如果如果anaconda安装初始化时，选择的no，那现在应该还用不了conda命令

* 初始化[^1] Anaconda（安装时初始化了则跳过）

  [^1]: [Linux安装anaconda3是否初始化的区别](https://blog.csdn.net/qq_41126685/article/details/105525408)

  ```sh
  # 执行 source $ANACONDA_HOME/bin/activate, 如：
  source /usr/sdk/anaconda3/bin/activate
  # 初始化
  conda init
  ```

* 关闭启动时激活 Conda基础环境（可选）

  ```sh
  # 如果您不希望在启动时激活 Conda基础环境，将 AUTO_ACTIVATE_BASE 参数设置为 FALSE：
  conda config --set auto_activate_base false
  ```
  
  关闭前效果（默认）
  ![202210191005796](https://gitee.com/librarookie/picgo/raw/master/img/202210191005796.png "202210191005796")

  关闭后效果（false）
  ![202210191008946](https://gitee.com/librarookie/picgo/raw/master/img/202210191008946.png "202210191008946")

* Anaconda 镜像配置
  * <https://www.cnblogs.com/librarookie/p/15376578.html>

* 配置 环境和 包存放目录

  ```sh
  # 查看所有配置
  conda config --show

  # 查看环境(envs_dirs) 或包(pkgs_dirs) 配置
  conda config --show envs_dirs
  conda config --show pkgs_dirs

  # 配置目录(第一次用 --add，后面修改使用 --set)
  conda config --add envs_dirs /path/to/envs_dir
  conda config --add pkgs_dirs /path/to/pkgs_dir

  # 查看 conda 配置
  conda config --show-source
  ```

  ![202210191021743](https://gitee.com/librarookie/picgo/raw/master/img/202210191021743.png "202210191021743")

  Tips: 上述的操作就是在 conda 的配置文件 `~/.condarc` 中添加 envs_dirs 和 pkgs_dirs 配置，故直接编辑 `~/.condarc` 效果一样;

</br>

## 卸载

* 删除Anaconda 文件夹

  ```sh
  # rm -rf $ANACONDA_HOME，如：
  rm -rf /usr/sdk/anaconda3
  ```

* 删除Anaconda 配置

  ```sh
  # 打开配置文件
  vim ~/.bashrc
  
  # 删除下面这段配置

  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$('/usr/sdk/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "/usr/sdk/anaconda3/etc/profile.d/conda.sh" ]; then
          . "/usr/sdk/anaconda3/etc/profile.d/conda.sh"
      else
          export PATH="/usr/sdk/anaconda3/bin:$PATH"
      fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<
  ```

* 更新配置文件

  ```sh
  source ~/.bashrc
  # 或者 
  source /etc/profile
  ```

</br>
</br>

Via

* <https://blog.csdn.net/qq_43529415/article/details/100847887>
