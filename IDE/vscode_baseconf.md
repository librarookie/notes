# VS Code 配置和使用

</br>
</br>

## 背景

> Visual Studio Code（简称VS Code）是一款由微软开发且跨平台的免费源代码编辑器。该软件支持语法高亮、代码自动补全（又称IntelliSense）、代码重构、查看定义功能，并且内置了命令行工具和Git版本控制系统。</br>
> 用户可以更改主题和键盘快捷方式实现个性化设置，也可以通过内置的扩展程序商店安装扩展以拓展软件功能。  -WikipediaVisual

</br>

## 下载

Visual Studio Code 支持支持 Windows、Linux、Mac；

* 官网地址： <https://code.visualstudio.com/>
* 插件地址： <https://marketplace.visualstudio.com/>

</br>

## 使用

* 布局

  ![vscode-index](https://img2020.cnblogs.com/blog/1957451/202108/1957451-20210817163055542-74357445.png)

  上面是 vscode 的布局，和大多数编辑器一样，分为：
  * `Editor`      &nbsp;&nbsp;&nbsp;&nbsp; 用来编辑文件的主体区域。（可以并排打开三个编辑器）
  * `Side Bar`    &nbsp;&nbsp;&nbsp;&nbsp; 包含不同的像浏览器一样的视图来协助来完成工程。
  * `Status Bar`  &nbsp;&nbsp;&nbsp;&nbsp; 展示当前打开的工程和正在编辑的文件的信息。
  * `View Bar`    &nbsp;&nbsp;&nbsp;&nbsp; 在最左手边，帮助切换视图以及提供额外的上下文相关的提示，比如激活了Git的情况下，需要提交的变化的数目。
  
* 快捷键
  * [VScode 快捷键入口](https://www.cnblogs.com/librarookie/p/15138212.html '传送')

* 扩展

  * 必装扩展
    * [Chinese (Simplified) Language Pack for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=MS-CEINTL.vscode-language-pack-zh-hans) &nbsp;&nbsp;&nbsp;&nbsp;中文扩展
    * [vscode-icons](https://marketplace.visualstudio.com/items?itemName=vscode-icons-team.vscode-icons) &nbsp;&nbsp;&nbsp;&nbsp; 文件图标样式
    * [Bracket Pair Colorizer 2](https://marketplace.visualstudio.com/items?itemName=CoenraadS.bracket-pair-colorizer-2) &nbsp;&nbsp;&nbsp;&nbsp; 彩色括号
  * 推荐扩展
    * [One Dark Pro](https://marketplace.visualstudio.com/items?itemName=zhuangtongfa.Material-theme) &nbsp;&nbsp;&nbsp;&nbsp; 热门黑色主题
    * [markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint) &nbsp;&nbsp;&nbsp;&nbsp; Markdown 样式（快捷键 `Ctrl + Shift + V`预览，或 `Ctrl + K V`侧边预览）
    * [Vim](https://marketplace.visualstudio.com/items?itemName=vscodevim.vim) &nbsp;&nbsp;&nbsp;&nbsp; Vim 编辑器
    * [SonarLint](https://marketplace.visualstudio.com/items?itemName=SonarSource.sonarlint-vscode) &nbsp;&nbsp;&nbsp;&nbsp; 代码检查（支持JavaScript、TypeScript、Python、Java、HTML和PHP代码的分析）

* 配置

  * [工作区讲解与使用](https://zhuanlan.zhihu.com/p/54770077)
  * 自动保存

    ```python
    打开设置 --> file.autoSave --> 改为afterDelay
            --> file.autoSaveDelay --> 5000 配置自动保存时间(毫秒)
    ```

</br>
</br>

Ref

* <https://zhuanlan.zhihu.com/p/54770077>
* <https://zhuanlan.zhihu.com/p/35176928>
