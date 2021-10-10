# git 常用命令

* 基础命令

    |Key|Value|
    |----|----|
    |git init|初始化成git仓库|
    |git add [file]|加入到暂存区|
    |git add -A|将所有文件的修改加入暂存区|
    |git rm --cached [file]...|从暂存区删除|
    |git commit [-m "content"]|从暂存区提交到本地仓库（-m 附加注释）|
    |git commit -am "content"|提交修改文件并提交到本地仓库|
    |git clone|拷贝一份远程仓库，也就是下载一个项目|
    |git status|查看状态|
    |git diff|比较文件的不同，即暂存区和工作区的差异|
    |git log|查看历史提交记录|
    |git remote -v|查看远程仓库|
    |git blame file|以列表形式查看指定文件的历史修改记录|
    |git pull origin master|拉取（同步）master分支|
    |git push|推送到远程库|
    |git push -u origin master -f |第一次强行推送到远程库|

* 版本命令

    |Key|Value|
    |----|----|
    |git log]|查看提交日志|
    |git reflog [branch_name]|查看提交版本|
    |git reset [--mixed] 提交版本|文件内容不变，版本信息回退|
    |git reset [--mixed] HEAD^|回退前一个版本|
    |git reset --hard\|--merge 提交版本|回退版本|
    |git reset --hard\|--merge HEAD^|回退前一个版本|
    |git reset --hard origin/master|将本地状态回退到和远程的一样|
    |git revert|回滚远程版本|
    |git revert -m 1|回滚版本，保留主分支|

  * note:
    * 版本回退后是到上次commit的状态
    * 首次push会报错，需要强制推送（git push -f）
    * HEAD^ &nbsp;&nbsp;&nbsp;表示前 一个版本
    * HEAD^^ &nbsp;&nbsp;&nbsp;表示前 两个版本
    * HEAD~n &nbsp;&nbsp;&nbsp;表示前 n个版本

* 分支命令

    |Key|Value|
    |----|----|
    |git branch|查看本地分支|
    |git branch -r|查看远程分支|
    |git branch -a|查看全部分支|
    |git branch branch_name|创建分支|
    |git branch -d branch_name|删除本地分支|
    |git push origin -d branch_name|删除远程分支|
    |git checker branch_name|切换分支|
    |git checker -b branch_name|创建新分支并立即切换到该分支下|
    |git merge branch_name|合并回到你的主分支|

* 标签[^1]命令

    |Key|Value|
    |----|----|
    |创建标签|git tag tag_name|
    |创建带注解标签|git tag -a tag_name -m "content"|
    |查看已有标签|git tag||
    |删除标签|git tag -d tag_name|
    |查看此版本所修改的内容|git show tag_name|

[^1]:发布一个版本时，我们通常先在版本库中打一个标签（tag），这样就唯一确定了打标签时刻的版本。将来无论什么时候，取某个标签的版本，就是把那个打标签的时刻的历史版本取出来。标签也是版本库的一个快照。

Reference

* <https://blog.csdn.net/Lucky_LXG/article/details/77849212>
* <https://www.runoob.com/git/git-basic-operations.html>
* <https://blog.csdn.net/zhuqiuhui/article/details/105424776>
