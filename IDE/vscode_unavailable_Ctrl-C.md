# 解决 VS Code 无法使用Ctrl+C等快捷键

</br>
</br>

## 背景

> VScode 安装 Vim扩展后，无法使用`Ctrl+C，Ctrl+X`和 `Ctrl+V`等热键

</br>

## 解决方案

* 方案一

  * 停用Vim 热键覆盖
  
    ```python
    # 原因： vim 扩展默认启用Vim ctrl键覆盖常见的VSCode操作，如复制、粘贴、查找等;
    # PATH：文件 --> 首选项 --> 设置 --> 扩展 --> vim --> vim.useCtrlkeys
    Ctrl+Shift+P --> user settings --> vim.useCtrlkeys  取消勾选

    或者，在用户设置的 settings.json文件中加入"vim.useCtrlKeys": false
    ```

    ![202208242039325](https://gitee.com/librarookie/picgo/raw/master/img/202208242039325.png "202208242039325")

    *Note*：停用vim热键覆盖后，Ctrl热键功能已经可以使用了，但是会有一个小问题，使用 `Ctrl+C`热键时，会自动进入vim命令模式（光标变成![202208242044786](https://gitee.com/librarookie/picgo/raw/master/img/202208242044786.png "202208242044786") ，如果不在乎此问题，则可忽略下一个配置）

  * 解决 Ctrl + C热键问题

    ```python
    # 原因： Vim扩展使用了Vim的命令覆盖VSCode的COPY命令
    进入设置 -- > vim.overrideCopy 取消勾选

    或者，在用户设置的 settings.json文件中加入"vim.overrideCopy": false
    ```

    ![202208242047997](https://gitee.com/librarookie/picgo/raw/master/img/202208242047997.png "202208242047997")

* 方案二

  * 配置 Vim热键

      ```python
      # 进入设置 --> vim.handleKeys --> 在 settings.json中编辑， 把需要禁用Vim的热解以json格式写入vim.handleKeys中即可，如：
      "vim.handleKeys": {
          "<C-a>": false,
          "<C-c>": false,
          "<C-x>": false,
          "<C-f>": false,
          "<C-h>": false,
          "<C-s>": false,
          "<C-z>": false,
          "<C-y>": false
      }
      ```

      ![202208242048064](https://gitee.com/librarookie/picgo/raw/master/img/202208242048064.png "202208242048064")

* 方案三
  * 卸载 Vim扩展

    ```python
    如果你只是因为别人推荐而安装的 Vim扩展，那你完全可以卸载不用
    ```

  * 全局禁用或工作区禁用Vim扩展

    ```python
    1. 全局禁用
       需要的时候启动vim扩展，不需要的时候禁用
       比如写文档时启动vim扩展，写代码时候禁用Vim扩展
    2. 工作区禁用
       # 可以单独配置工作区扩展
       代码工作区禁用vim扩展，文档工作区启动vim扩展
    ```

    [vscode 工作区解释](https://zhuanlan.zhihu.com/p/54770077 "点击跳转")

</br>
</br>

Ref

* <https://marketplace.visualstudio.com/items?itemName=vscodevim.vim>
* <https://www.cnblogs.com/jie828/p/11320014.html>
