# VScode的 Todo Tree 待办事项插件的定制和使用

</br>
</br>

## 背景

> 写代码过程中，突然发现一个Bug，但是又不想停下来手中的活，以免打断思路，怎么办？按代码编写会规范，都是建议在代码中加个TODO注释。

## Todo Tree 介绍

![202208190917895](https://gitee.com/librarookie/picgo/raw/master/img/202208190917895.png "202208190917895")

1. 概述
    - 这个扩展可以快速搜索（使用ripgrep）你的工作空间中的评论标签，如TODO和FIXME，并在活动栏中以树状视图显示它们。
    - 该视图可以从活动栏中拖出到资源管理器窗格中（或其他你希望它出现的地方）。
    - 在树状视图中点击一个TODO将打开该文件，并将光标放在包含该TODO的那一行。
    - 找到的TODO也可以在打开的文件中突出显示。
2. 安装
    - 在先安装:
        - 在vscode的扩展中心，搜索 `Todo Tree` 然后点击安装；
    - 离线安装:
        - 点击前往 [官网](https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.todo-tree) 下载插件离线包（vsix）
        - 打开vscode扩展中心，然后打开更多（扩展中心右上角的`...`），选择 `Install fron VSIX` ，最后找到下载的 vsix文件即可。

</br>
</br>

## 配置介绍

### 常用标记

- `TODO`： 待办标记，用来标记待办的地方。表示标记处有功能代码待编写，待实现的功能在说明中会简略说明。
- `HACK`： 待修改标记，用来标记可能需要更改的地方。在写代码的时候，有的地方我们并不确定他是正确的，可能未来有所更改，这时候可以使用HACK标记。
- `FIXME`： 待修复标记，用来标记一些需要修复的位置。表示标记处代码需要修正，甚至代码是错误的，不能工作，需要修复，如何修正会在说明中简略说明。
- `XXX`： 改进标记，用来标记一些草率实现的地方。在写代码的时候，有些地方需要频繁修改，代码虽然实现了功能，但是实现的方法有待商榷，希望将来能改进，要改进的地方会在说明中简略说明。
- `NOTE`： 说明标记，添加一些说明文字。
- `INFO`： 信息标记，用来表达一些信息。
- `TAG`： 标识标记，用来创建一些标记。

### 照抄配置

打开配置文件，并粘贴一下内容

快捷入口：

1. 快捷打开设置 `Crtl+Shift+p` 搜索 `settings.json`
2. 选择 TODO配置范围（怕麻烦就用 User Settings），生效范围依次递减：
    - `Open User Settings (JSON)` 用户配置
    - `Open Workspace Settings (JSON)` 工作区配置
    - `Open Folder Settings (JSON)` 文件夹配置
3. 将配置写入 json 文件的最下面即可

    ```md
    "todo-tree.regex.regex": "(//|#|<!--|;|/\\*|^|^[ \\t]*(-|\\d+.))\\s*($TAGS)",
    "todo-tree.filtering.ignoreGitSubmodules": true,
    "todo-tree.tree.showCountsInTree": true,
    "todo-tree.regex.regexCaseSensitive": false,
    "todo-tree.general.statusBar":"current file",
    "todo-tree.general.tags": [
        "BUG",
        "FIXME",
        "TODO",
        "HACK",
        "XXX",
        "TAG",
        "DONE",
        "NOTE",
        "INFO",
    ],
    "todo-tree.highlights.defaultHighlight": {
        "icon": "alert",
        "type": "line",
    },
    "todo-tree.highlights.customHighlight": {
        "BUG": {
            "icon": "bug",
            "foreground": "#F56C6C",
        },
        "FIXME": {
            "icon": "flame",
            "foreground": "#FF9800",
        },
        "TODO":{
            "icon": "checklist",
            "foreground": "#FFEB38",
        },
        "HACK":{
            "icon": "versions",
            "foreground": "#E040FB",
        },
        "XXX":{
            "icon": "unverified",
            "foreground": "#E91E63",
        },
        "TAG":{
            "icon": "tag",
            "foreground": "#409EFF",
        },
        "DONE": {
            "icon": "verified",
            "foreground": "#0dff00",
        },
        "NOTE":{
            "icon": "note",
            "foreground": "#67C23A",
        },
        "INFO":{
            "icon": "info",
            "foreground": "#909399",
        },
    },
    ```

    Tips: 如果不需要这么多的标记，可以删除 `todo-tree.general.tags` 中的标记即可

### 配置（括号中为默认值）

#### 适用范围

- `todo-tree.regex.regex ((//|#|<!--|;|/\\*|^|^[ \\t]*(-|\\d+.))\\s*($TAGS))`

    这定义了用于定位 TODO 的正则表达式。默认情况下，它会在以//、#、;开头的评论中搜索标签。、<!--或/*，以及降价待办事项列表。这应该涵盖大多数语言。但是，如果您想对其进行细化，请确保将($TAGS)保留为($TAGS)将被扩展的标记列表替换。要使某些扩展功能正常工作，($TAGS)应该出现在正则表达式中，但是，如果您需要显式扩展标签列表，基本功能应该仍然有效。

- `todo-tree.general.tags (["TODO","FIXME","BUG"])`

    这定义了被识别为 TODO 的标签。此列表会自动插入到正则表达式中。

- `todo-tree.general.tagGroups ({})`

    此设置允许将多个标签视为一个组。例子：

    ```md
    "todo-tree.general.tagGroups": {
        "FIXME": [
            "FIXME",
            "FIXIT",
            "FIX",
        ]
    },
    ```

Tips:

- 这将任何FIXME，FIXIT或FIX视为FIXME。当树按标签分组时，所有这些都会出现在FIXME节点下。这也意味着自定义突出显示应用于组，而不是每个标签类型。
- 组中的所有标签也应该出现在todo-tree.general.tags.

##### 排除文件和文件夹

> 要限制搜索的文件夹集，您可以定义 `todo-tree.filtering.includeGlobs`. 这是与搜索结果匹配的 glob 数组。如果结果与任何 glob 匹配，则将显示它们。</br>
> 默认情况下，该数组为空，它匹配所有内容要从搜索中排除文件夹/文件，您可以定义 `todo-tree.filtering.excludeGlobs`. 如果搜索结果与这些 glob 中的任何一个匹配，则结果将被忽略。</br>
> 您还可以使用上下文菜单在树中包含和排除文件夹。此文件夹过滤器单独应用于包含/排除 glob。

- `todo-tree.filtering.includeGlobs ([])`

    用于通过包含来限制搜索结果的 Glob，例如 `[\"**/unit-tests/*.js\"]`  ，仅在 unit-tests 子文件夹中显示 .js 文件。球帮助。（glob 路径是绝对的 - 与当前工作空间无关）

- `todo-tree.filtering.excludeGlobs (["**/node_modules"])`

    用于通过排除限制搜索结果的 Glob（在includeGlobs之后应用），例如 `[\"**/*.txt\"]` 忽略所有 .txt 文件。（node_modules默认排除）

- `todo-tree.filtering.ignoreGitSubmodules (false)`

    如果为真，搜索时将忽略，包含文件的任何子文件夹。.git

</br>

#### 突出显示

> 突出显示标签是可配置的。用于 `defaultHighlight` 为所有标签设置突出显示。如果您需要以不同方式配置各个标签，请使用 `customHighlight`. 如果未在 中指定设置customHighlight，则使用 from 的值defaultHighlight。

- `todo-tree.highlights.defaultHighlight ({})`

    设置默认高亮。例子：

    ```md
    {
        "foreground": "white",
        "background": "red",
        "icon": "check",
        "type": "text"
    }
    ```

- `todo-tree.highlights.customHighlight ({})`

    设置每个标签（或标签组）的亮点。例子：

    ```md
    {
        "TODO": {
            "foreground": "white",
            "type": "text"
        },
        "FIXME": {
            "icon": "beaker"
        }
    }
    ```

1. 常用参数

    - `foreground`- 用于设置编辑器中标记部分高亮和前景色。
    - `background`- 用于设置编辑器中标记部分高亮的背景颜色。
      - 前景色和背景色可以使用HTML/CSS 颜色名称（例如“Salmon”）、RGB 十六进制值（例如“#80FF00”）、RGB CSS 样式值（例如“rgb(255,128,0)”或来自当前主题，例如peekViewResult.background。十六进制和 RGB 值也可以指定 alpha，例如“#ff800080”或“rgba(255,128,0,0.5)”。
    - `opacity`- 透明度，与背景颜色一起使用的百分比值。100% 将产生不透明的背景，这将掩盖选择和其他装饰。
      - 不透明度只能在使用十六进制或 RGB 颜色时指定。
    - `icon`- 图标样式，用于在树视图中设置不同的图标。必须是有效的 [ocicons](https://occticons.github.com) 或 [codicon](https://microsoft.github.io/vscode-codicons/dist/codicon.html)
      - 如果使用 codicons，请以“$(icon)”格式指定它们。如果图标无效，则图标默认为勾号.
    - `iconColour`- 用于设置目录树区域的图标颜色。如果未指定，它将尝试使用前景色或背景色。
      - 颜色可以根据前景色和背景色指定，仅在使用 codicons 时才支持主题颜色。仅当使用 ocicons 或默认图标时才支持 Hex、RGB 和 HTML 颜色。
    - `rulerColour`- 用于设置总览标尺中标记的颜色。如果未指定，它将默认使用前景色。颜色可以根据前景色和背景色指定。
    - `type`- 用于控制在编辑器中突出显示多少。有效值为：
      - `tag`- 仅突出显示标签;
      - `text`- 突出显示标签和标签后的任何文本;
      - `tag-and-comment`- 突出显示注释字符（或匹配的开始）和标签;
      - `tag-and-subTag`- 如上所述，但允许子标签也被突出显示（在自定义突出显示中定义颜色）;
      - `text-and-comment`- 突出显示注释字符（或匹配的开始）、标记和标记后的文本;
      - `line`- 突出显示包含标签的整行;
      - `whole-line`- 将包含标签的整行高亮显示到编辑器的全宽;
      - `capture-groups:n,m...`- 突出显示来自正则表达式的捕获组，其中“n”是正则表达式的索引;
      - `none`- 禁用文档中的突出显示;

2. 样式参考

    - [vscode-icon 图标](https://microsoft.github.io/vscode-codicons/dist/codicon.html)

       ![202208221626040](https://gitee.com/librarookie/picgo/raw/master/img/202208221626040.png "202208221626040")

    - [颜色预览参考](https://www.5tu.cn/colors/yansezhongwenming.html)

       ![202208221627649](https://gitee.com/librarookie/picgo/raw/master/img/202208221627649.png "202208221627649")

</br>

#### 其他配置

- `todo-tree.general.revealBehaviour (start of todo)`

    在树中双击 todo 时更改光标行为。您可以选择：（`start of todo`将光标移动到待办事项的开头）、`end of todo`（将光标移动到待办事项的末尾）或`start of line`（将光标移动到行首）。

- `todo-tree.general.statusBar (none)`

    在状态栏中显示的内容 - 无 (none)、总计数 (total)、每个标签的计数 (tags)、前三个标签的计数 (top three) 或仅当前文件的计数 (current file)。

- `todo-tree.tree.showCountsInTree (false)`

    设置为 `true` 以显示树中 TODO 的计数。

- `todo-tree.regex.regexCaseSensitive (true)`

    设置为 `false` 以允许匹配标签而不考虑大小写。

更多参考： [Todo Tree官网](https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.todo-tree)

</br>
</br>

## 效果

标记效果如下（左标记效果，右标记实例）：

![202208191726799](https://gitee.com/librarookie/picgo/raw/master/img/202208191726799.png "202208191726799")

</br>
</br>

Ref

- <https://www.cnblogs.com/donpangpang/p/14612568.html>
- <https://blog.csdn.net/sinat_39620217/article/details/115614152>
