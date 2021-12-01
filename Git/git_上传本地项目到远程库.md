# Git 使用，本地项目上传到GitHub远程库

## 环境

* GitHub账号
    [点此进入github官网](https://github.com)

* git客户端工具
    [点此进入git下载页](https://git-scm.com/downloads)

## 本地项目上传到 GitHub

1. 在GitHub中创建一个仓库（远程库）

    * Repository name: 仓库名称

    * Description(可选): 仓库描述介绍

    * Public, Private: 仓库权限（公开共享，私有或指定合作者，私有仓库收费）

    * README(可选): 添加一个自述文件 README.md

    * gitignore(可选): 维护不需要进行版本管理的文件类型，生成文件 .gitignore

    * license(可选): 证书类型，生成文件 LICENSE

2. Git 全局设置:

    ```python
    git config --global user.name "your_name"
    git config --global user.email "your_email@example.com"
    ```

3. 创建 git 仓库:

    ```python
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

4. 已有仓库?

    ```python
    # 进入本地库目录
    cd existing_git_repo

    # 关联远程库(HTTPS/SSH)
    git remote add origin https://github.com/librarookie/first-repository.git
    
    # 上传到远程库
    git push -u origin master
    ```

5. 生成/添加 SSH公钥

    * [点此进入SSH公钥](https://www.cnblogs.com/cure/p/15390170.html "生成&添加 SSH公钥")
