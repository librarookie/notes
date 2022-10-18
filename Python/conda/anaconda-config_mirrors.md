# Anaconda-conda 镜像配置

</br>
</br>

## 镜像源

* 清华大学: <https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/>
* 北京外国语大学: <https://mirrors.bfsu.edu.cn/help/anaconda/>
* 南京邮电大学: <https://mirrors.njupt.edu.cn/>
* 南京大学: <http://mirrors.nju.edu.cn/>
* 重庆邮电大学: <http://mirror.cqupt.edu.cn/>
* 上海交通大学: <https://mirror.sjtu.edu.cn/>
* 哈尔滨工业大学: <http://mirrors.hit.edu.cn/>

</br>

## 配置

* 配置命令
    |命令|作用|
    | ---- | ---- |
    |conda config --set show_channel_urls yes|显示安装的频道|
    |conda config --set auto_activate_base false|关闭默认激活 Conda基础环境|
    |conda clean -i|清除索引缓存|

* 频道（channels）命令
    |命令|作用|
    | ---- | ---- |
    |conda config --add channels channels_url|添加频道|
    |conda config --remove-key KEY|删除频道|
    |conda config --set KEY VALUE|设置频道|
    |conda config --show KEY|查看频道|
    |conda config --show-source|查看频道配置|

</br>

## 栗子（清华源）

1. 配置 ~/.condarc 文件

    可先执行 `conda config --set show_channel_urls yes` 生成该文件之后再修改

2. 修改后内容如下：

    ```sh
    channels:
      - defaults
    show_channel_urls: true
    default_channels:
      - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
      - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
      - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
    custom_channels:
      conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
      msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
      bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
      menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
      pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
      pytorch-lts: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
      simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    ```

3. 清除索引缓存

    `conda clean -i`

Tips:

* 由于更新过快难以同步，我们不同步pytorch-nightly, pytorch-nightly-cpu, ignite-nightly这三个包。
* Miniconda 是一个 Anaconda 的轻量级替代，默认只包含了 python 和 conda，但是可以通过 pip 和 conda 来安装所需要的包。

</br>
</br>

Via

* <https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/>
* <https://www.jianshu.com/p/edaa744ea47d>
