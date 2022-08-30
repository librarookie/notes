# Markdown 语法

</br>
</br>

## 基础语法

> 这些是 John Gruber 的原始设计文档中列出的元素。所有 Markdown 应用程序都支持这些元素。

| 元素 | Markdown 语法 |
| :--- | :--- |
| 标题（Heading） | # H1 </br> ## H2 </br> ### H3 |
| 粗体（Bold） | `**bold text**` |
| 斜体（Italic） | `*italicized text*` |
| 引用块（Blockquote） | > blockquote |
| 有序列表（Ordered List） | 1. First item </br> 2. Second item </br> 3. Third item |
| 无序列表（Unordered List） | - First item </br> - Second item </br> - Third item |
| 代码（Code） | \`code\` |
| 分隔线（Horizontal Rule） | --- |
| 链接（Link） | `[title](<https://www.example.com>)` |
| 图片（Image） | `![alt text](image.jpg)` |

图片支持 jpg、png、gif、svg 等图片格式，**其中 svg 文件仅可在微信公众平台中使用**

</br>

## 扩展语法

> 这些元素通过添加额外的功能扩展了基本语法。但是，并非所有 Markdown 应用程序都支持这些元素。

| 元素 | Markdown 语法 |
| :--- | :--- |
| \| 表格（Table） | \| Syntax      \| Description \| </br> \| ----------- \| ----------- \| </br> \| Header &nbsp; \| Title &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \|  </br> \| Paragraph   \| Text &nbsp;&nbsp; \| |
| 代码块（Fenced Code Block） | \``` </br> { </br> "firstName": "John", </br> "lastName": "Smith", </br> "age": 25 </br> } </br> ``` |
| 脚注（Footnote） | Here's a sentence with a footnote. [^1] </br> [^1]: This is the footnote. |
| 标题编号（Heading ID） | ### My Great Heading {#custom-id} |
| 定义列表（Definition List） | term </br> : definition |
|删除线（Strikethrough） | `~~The world is flat.~~` |
|任务列表（Task List） | - [x] Write the press release </br> - [ ] Update the website </br> - [ ] Contact the media |

代码块支持以下语言种类：

```md
bash
clojure，cpp，cs，css
dart，dockerfile, diff
erlang
go，gradle，groovy
haskell
java，javascript，json，julia
kotlin
lisp，lua
makefile，markdown，matlab
objectivec
perl，php，python
r，ruby，rust
scala，shell，sql，swift
tex，typescript
verilog，vhdl
xml
yaml
```

## 其他语法

| 元素 | Markdown 语法 |
| :--- | :--- |
| 注音符号 | {喜大普奔\|hē hē hē hē} |
| 横屏滑动幻灯片 | `<![](url),![](url)>` |

</br>
</br>

Via

* <https://markdown.com.cn/cheat-sheet.html>
* <https://markdown.com.cn/editor/>
