# Git本地仓库关联远程GitHub仓库

</br>
</br>

## 环境

1. 工具准备

   - [GitHub账号注册](https://github.com "https://github.com")
   - [git客户端工具下载](https://git-scm.com/downloads "https://git-scm.com/downloads")

2. Git 配置

    ```md
    git config --global user.name "your_name"
    git config --global user.email "your_email@example.com"
    ```

</br>

## 方案一、关联仓库

### 创建远程仓库

在 GitHub中 创建一个仓库（远程库）

- `Repository name`: 仓库名称

- `Description`(可选): 仓库描述介绍

- `Public`, `Private`: 仓库权限（公开共享，私有或指定合作者，私有仓库收费）

- `README`(可选): 添加一个自述文件 README.md

- `gitignore`(可选): 维护不需要进行版本管理的文件类型，生成文件 .gitignore

- `license`(可选): 证书类型，生成文件 LICENSE

</br>

### 关联本地仓库

1. 新建本地仓库

    ```md
    # 创建本地目录并进入
    mkdir init-repository
    cd init-repository

    # 初始化本地库
    git init

    # 创建测试文件
    touch README.md

    # 加入到暂存区
    git add README.md

    # 创建分支master（可选，GitHub的默认主分支是“main”）
    git branch -M master

    # 提交到本地库
    git commit -m "first commit"

    # 关联远程库(HTTPS/SSH, SSH需要添加公钥)
    git remote add origin https://github.com/librarookie/first-repository.git

    # 上传到远程库
    git push -u origin master
    ```

    [Git 命令参考](https://www.cnblogs.com/librarookie/p/15390196.html "Git 命令大全")

2. 已有本地仓库?

    ```md
    # 进入本地库目录
    cd existing_git_repo

    # 关联远程库（HTTPS / SSH）
    git remote add origin https://github.com/librarookie/first-repository.git

    # 上传到远程库
    git push -u origin master
    ```

</br>

## 方案二、克隆项目

- 从 GitHub 上克隆项目到本地

    > git clone [url]

- 栗子

    ```md
    # 克隆first-repository 项目
    git clone https://github.com/librarookie/first-repository.git

    # 或者（和上边的一样，唯一的差别就是，现在新建的目录成了 my-repository。）
    git clone https://github.com/librarookie/first-repository.git my-repository
    ```

</br>

## 扩展

- [生成和添加 SSH 公钥](https://www.cnblogs.com/librarookie/p/15390170.html "生成和添加 SSH 公钥")
