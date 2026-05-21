# Linux 系统权限介绍与使用

</br>
</br>

## 介绍

> linux中除了常见的读（r）、写（w）、执行（x）权限以外，还有其他的一些特殊或隐藏权限，熟练掌握这些权限知识的使用，可以大大提高我们运维工作的效率。

### Linux文件介绍

#### 文件基本属性

在 Linux 中我们可以使用 ll 或者 ls –l 命令来显示一个文件的属性以及文件所属的用户和组，如：

![202212051023177](https://gitee.com/librarookie/picgo/raw/master/img/202212051023177.png "202212051023177")

在 Linux 中第一个字符代表这个文件是目录、文件或链接文件等等。

- `d` : 表示目录
- `-` : 表示文件；
- `l` : 表示为链接文档(link file)；
- `b` : 表示为装置文件里面的可供储存的接口设备(可随机存取装置)；
- `c` : 表示为装置文件里面的串行端口设备，例如键盘、鼠标(一次性读取装置)。

接下来的字符中，以三个为一组，且均为 rwx 的三个参数的组合。其中， r 代表可读(read)、 w 代表可写(write)、 x 代表可执行(execute)。 要注意的是，这三个权限的位置不会改变，如果没有权限，就会出现减号 `-` ，如：

![202212051026462](https://gitee.com/librarookie/picgo/raw/master/img/202212051026462.png "202212051026462")

每个文件的属性由左边第一部分的 10 个字符来确定，从左至右用 0-9 这些数字来表示。

- 第 0 位确定文件类型，
- 第 1-3 位确定属主（该文件的所有者）拥有该文件的权限。
- 第4-6位确定属组（所有者的同组用户）拥有该文件的权限，第7-9位确定其他用户拥有该文件的权限。
- 其中，第 1、4、7 位表示读权限，如果用 r 字符表示，则有读权限，如果用 - 字符表示，则没有读权限；
- 第 2、5、8 位表示写权限，如果用 w 字符表示，则有写权限，如果用 - 字符表示没有写权限；
- 第 3、6、9 位表示可执行权限，如果用 x 字符表示，则有执行权限，如果用 - 字符表示，则没有执行权限。

在linux系统中文件（文件和目录）的权限有三种(r, w, x)，分别对应数字权限 (4, 2, 1)，而这三种权限对 `文件` 和 `目录` 的意义有所不同。

- 权限对 `文件`

    ```md
    r（read）： 可读取该文件的实际内容；
    w（write）： 可以编辑，新增或者修改该文件的内容（但不含删除该文件）；
    x（execute）： 代表该文件可以被系统执行。
    ```

    Tips: 对于文件的 r, w, x 来说，主要针对的 "文件的内容" 而言，与文件名的存在与否没有关系；

- 权限对 `目录`

    ```md
    r（read）： 表示具有读取目录结构列表的权限。不如可以用ls查看一下目录有什么；
    w（write）： 表示具有更改该目录结构列表的权限。目录可写操作包括：新建文件或目录、删除文件或目录（不论文件的权限是什么）、对文件或目录重命名、移动文件或目录等；
    x（execute）： 表示用户能否进入该目录称为工作目录。拥有此权限，就可以cd进去，否则，将不能进入目录内部。
    ```

</br>

#### 文件属主和属组

在Linux系统中，用户是按组分类的，一个用户属于一个或多个组。对于文件来说，它都有一个特定的所有者，也就是对该文件具有所有权的用户，即文件属主（所属者））。

文件所有者以外的用户又可以分为文件所属组的同组用户和其他用户。因此，Linux系统按文件所有者、文件所有者同组用户和其他用户来规定了不同的文件访问权限。

对于 root 用户来说，一般情况下，文件的权限对其不起作用。

Linux 文件的基本权限就有九个，分别是 owner/group/others(拥有者/组/其他) 三种身份各有自己的 read/write/execute 权限。

- chown (change owner) ： 修改所属用户与组。
- chmod (change mode) ： 修改用户的权限。

Linux文件属性有两种设置方法，一种是数字，一种是符号。

1. 数字类型改变文件权限

    文件的权限字符为： -rwxrwxrwx ， 这九个权限是三个三个一组的！其中，我们可以使用数字来代表各个权限，各权限的分数对照表如下：

    - r : 4
    - w : 2
    - x : 1

    每种身份(owner/group/others)各自的三个权限(r/w/x)分数是需要累加的，例如当权限为： -rwxrwx--- ，可以使用 `chmod 770 文件名` 来设定，分数则是：

    ```md
    owner  = rwx = 4+2+1 = 7
    group  = rwx = 4+2+1 = 7
    others = --- = 0+0+0 = 0
    ```

2. 符号类型改变文件权限

    还有一个改变权限的方法，从之前的介绍中我们可以发现，基本上就九个权限分别是：

    - user ： 用户，可以用 u 表示
    - group ： 组，可以用 g 表示
    - others ： 其他，可以用 o 表示

    此外， a 则代表 all，即全部的身份。读写的权限可以写成 r, w, x，也就是可以使用下表的方式来看：

    ![202212051119244](https://gitee.com/librarookie/picgo/raw/master/img/202212051119244.png "202212051119244")

    如果我们需要将文件权限设置为 -rwxr-xr-- ，可以使用 `chmod u=rwx,g=rx,o=r 文件名` 来设定。

</br>

### 权限码（umask）

> umask 是权限码，root用户默认是 0022，普通用户默认是 0002.

umask 默认权限确实由 4 个八进制数组成，但第 1 个数代表的是文件所具有的特殊权限（SetUID、SetGID、Sticky BIT）,也就是说，后 3 位数字 "022" 才是本节真正要用到的 umask 权限值，将其转变为字母形式为 `----w--w-`。

使用命令 "umask" 就能查询出来

文件默认的权限是 666，目录默认的权限是 777

- 对文件来讲，其可拥有的最大默认权限是 666，即 rw-rw-rw-。也就是说，使用文件的任何用户都没有执行（x）权限。原因很简单，执行权限是文件的最高权限，赋予时绝对要慎重，因此绝不能在新建文件的时候就默认赋予，只能通过用户手工赋予。
- 对目录来讲，其可拥有的最大默认权限是 777，即 rwxrwxrwx。

文件和目录的真正初始权限，可通过以下的计算得到：

`文件（或目录）的初始权限 = 文件（或目录）的最大默认权限 - umask权限`

- 新建文件权限: 666-022=644
- 新建目录权限: 777-022=755

</br>

### 特殊权限：SUID、SGID、SBIT

在Linux中有三种特殊权限，分别为：

- SUID(s)  =  4： 执行时设置用户ID（SetUID, set user ID upon execution）；当文件所有者权限中的 x 权限位，却出现了 s 权限时，就被称为 SetUID，简称 SUID 特殊权限。
- SGID(s)  =  2： 执行时设置组ID（SetGID, set group ID upon execution）；当 s 权限位于所属组的 x 权限位时，就被称为 SetGID，简称 SGID 特殊权限。
- SBIT(t)  =  1： 限制删除标志或粘性位（Sticky BIT, the restricted deletion flag or sticky bit）；当 t 权限位于其他者的 x 权限位时，就被称为 Sticky BIT，简称 SBIT 特殊权限。

Tips

- SetUID(s)，SetGID(s) 和SBIT(t)分别显示在 ugo 的 `x` 位置，如果本来在该位上有执行权限（x）, 则这些特殊标志显示为小写字母 (s, s, t). 否则, 显示为大写字母 (S, S, T)
- SUID、SGID、SBIT 权限都是为了实现特殊功能而设计的，其目的是弥补 ugo 权限无法实现的一些使用场景。

#### SetUID

> SUID 特殊权限仅适用于可执行文件，所具有的功能是，只要用户对设有 SUID 的文件有执行权限，那么当用户执行此文件时，会以文件所有者的身份去执行此文件，一旦文件执行结束，身份的切换也随之消失。

在 Linux 中，普通用户修改密码，就是通过SUID来实现，下面我们来了解一次此过程：

- 在 Linux 中，所有账号的密码记录在 `/etc/shadow` 这个文件中，并且只有 root 可以读写入这个文件；也就是说，普通用户对此文件没有任何操作权限。;
- 普通用户可以使用 `/usr/bin/passwd` 命令修改自己的密码;

如果另一个普通账号 tester 需要修改自己的密码，就要访问 /etc/shadow 这个文件。但是只有 root 才能访问 /etc/shadow 这个文件，这究竟是如何做到的呢？
事实上，tester 用户是可以修改 /etc/shadow 这个文件内的密码的，就是通过 passwd程序文件的 SUID 功能。让我们看看 passwd 程序文件的权限信息：

![202211231602311](https://gitee.com/librarookie/picgo/raw/master/img/202211231602311.png "202211231602311")

显示了 passwd 命令的权限配置，可以看到，此命令拥有 SUID 特殊权限，而且其他人对此文件也有执行权限，这就意味着，任何一个用户都可以用文件所有者，也就是 root 的身份去执行 passwd 命令。

上图中的权限信息可以看出，passwd 文件所属者的信息为 rws 而不是 rwx。当 s 出现在文件拥有者的 x 权限上时，就被称为 SETUID BITS 或 SETUID ，其特点如下：

- SUID 权限仅对二进制可执行文件有效
- 如果执行者对于该二进制可执行文件具有 x 的权限，执行者将具有该文件的所有者的权限
- 本权限仅在执行该二进制可执行文件的过程中有效

整理一下已知条件：

1. 修改密码是通过 passwd 程序将密码保存到 /etc/shadow 文件；
2. 普通用户对于 /usr/bin/passwd 这个程序具有执行权限；
3. passwd 程序拥有 SUID 权限；
4. passwd 程序的所有者为 root；
5. 只有 root 才能访问 /etc/shadow 文件；

下面我们来看 tester 用户是如何利用 SUID 权限完成密码修改的：

1. 普通用户 tester 执行 passwd 程序修改密码；
2. 在此过程中会通过 SUID 权限暂时获得 /usr/bin/passwd 程序的所有者权限，即 root 权限；
3. 因此 tester 用户在执行 passwd 程序的过程中暂时利用 root 身份修改 /etc/shadow 文件；
4. passwd 程序执行完成后，普通用户 tester 所具有的 root身份也随之消失；

但是如果由普通用户执行 cat 命令去读取 /etc/shadow 文件确是不行的，如：

![202211251031780](https://gitee.com/librarookie/picgo/raw/master/img/202211251031780.png "202211251031780")

从图中可以看出，cat 只比 passwd 程序缺少 SUID 权限，其他条件一致。

原因很清楚，普通用户没有读 /etc/shadow 文件的权限，同时 cat 程序也没有被设置 SUID。我们可以通过下图来理解这两种情况：

![202211251036118](https://gitee.com/librarookie/picgo/raw/master/img/202211251036118.png "202211251036118")

如果想让任意用户通过 cat 命令读取 /etc/shadow 文件的内容也是非常容易的，给它设置 SUID 权限就可以了：

```sh
$ sudo chmod 4755 /usr/bin/cat
## Or
$ sudo chmod u+s /usr/bin/cat
```

现在 cat 已经具有了 SUID 权限，试试看，是不是已经可以 cat 到 /etc/shadow 的内容了。

![202211251038955](https://gitee.com/librarookie/picgo/raw/master/img/202211251038955.png "202211251038955")

因为这样做非常不安全，所以赶快通过下面的命令把 cat 的 SUID 权限移除掉：

```sh
$ sudo chmod 755 /usr/bin/cat
## Or
$ sudo chmod u-s /usr/bin/cat
```

由此，我们可以总结出，SUID 特殊权限具有如下特点：

- 只有可执行文件才能设定 SetUID 权限，对目录设定 SUID 是无效的。
- 用户要对该文件拥有 x（执行）权限。
- 用户在执行该文件时，会以文件所有者的身份执行。
- SetUID 权限只在文件执行过程中有效，一旦执行完毕，身份的切换也随之消失。

</br>

#### SetGID

> SGID 的特点与 SUID 相同，当 s 权限位于所属组的 x 权限位时，就被称为 SetGID，简称 SGID 特殊权限；与 SUID 不同的是，SGID 既可以对文件进行配置，也可以对目录进行配置。

下面通过 /usr/bin/mlocate 程序来演示其用法：

mlocate 程序通过查询数据库文件 `/var/lib/mlocate/mlocate.db` 实现快速的文件查找。 `mlocate` 程序的权限如下图所示：

![202211251533618](https://gitee.com/librarookie/picgo/raw/master/img/202211251533618.png "202211251533618")

很明显，它被设置了 SGID 权限。下面是数据库文件 `/var/lib/mlocate/mlocate.db` 的权限信息：很明显，它被设置了 SGID 权限。下面是数据库文件 `/var/lib/mlocate/mlocate.db` 的权限信息：

![202211251533771](https://gitee.com/librarookie/picgo/raw/master/img/202211251533771.png "202211251533771")

普通用户 tester 执行 mlocate 命令时，程序的执行过程如下图所示：

![202211251535278](https://gitee.com/librarookie/picgo/raw/master/img/202211251535278.png "202211251535278")

tester 就会获得用户组 mlocate 的执行权限，又由于用户组 mlocate 对 mlocate.db 具有读权限，所以 tester 就可以读取 mlocate.db 了。

除二进制程序外，SGID 也可以用在目录上。当一个目录设置了 SGID 权限后，它具有如下功能：

- 用户若对此目录具有 r 和 x 权限，该用户能够进入该目录；
- 用户在此目录下的有效用户组将变成该目录的用户组；
- 若用户在此目录下拥有 w 权限，则用户所创建的新文件的用户组与该目录的用户组相同。

SetGID 授权与取消：

```sh
# 授权
$ sudo chmod 2755 /usr/bin/mlocate
## Or
$ sudo chmod g+s /usr/bin/mlocate

# 取消
$ sudo chmod 755 /usr/bin/mlocate
## Or
$ sudo chmod g-s /usr/bin/mlocate
```

总结一下：

1. SetGID（SGID）对文件的作用（同 SUID 类似）

   - SGID 只针对可执行文件有效，换句话说，只有可执行文件才可以被赋予 SGID 权限，普通文件赋予 SGID 没有意义。
   - 用户需要对此可执行文件有 x 权限；
   - 用户在执行具有 SGID 权限的可执行文件时，用户的群组身份会变为文件所属群组；
   - SGID 权限赋予用户改变组身份的效果，只在可执行文件运行过程中有效；

2. SetGID（SGID）对目录的作用

   - 当一个目录被赋予 SGID 权限后，进入此目录的普通用户，其有效群组会变为该目录的所属组，会就使得用户在创建文件（或目录）时，该文件（或目录）的所属组将不再是用户的所属组，而使用的是目录的所属组。
   - 也就是说，只有当普通用户对具有 SGID 权限的目录有 rwx 权限时，SGID 的功能才能完全发挥。
   - 比如说，如果用户对该目录仅有 rx 权限，则用户进入此目录后，虽然其有效群组变为此目录的所属组，但由于没有 x 权限，用户无法在目录中创建文件或目录，SGID 权限也就无法发挥它的作用。

简言之：

1. 当 SGID 作用于普通文件时，和 SUID 类似，在执行该文件时，用户将获得该文件所属组的权限。
2. 当 SGID 作用于目录时，当用户对某一目录有写（w）和执行（x）权限时，该用户就可以在该目录下建立文件，如果该目录用 SGID 修饰，则该用户在这个目录下建立的文件都是属于这个目录所属的组。

Tips:

- 与 SUID 不同的是，SGID 既可以对文件进行配置，也可以对目录进行配置。
- SGID 和 SUID 的不同之处就在于，SUID 赋予用户的是文件所有者的权限，而 SGID 赋予用户的是文件所属组的权限，就这么简单。
- 无论是 SUID，还是 SGID，它们对用户身份的转换，只有在命令执行的过程中有效，一旦命令执行完毕，身份转换也随之失效。

小知识点：

```sh
# 将一个用户添加到一个组内
$ gpasswd -a 用户名 组名
$ usermod -G 组名 用户名

# 将一个用户从组内删除
$ gpasswd -d 用户名 组名
```

</br>

#### Sticky BIT

> Sticky BIT，简称 SBIT 特殊权限，可意为粘着位、粘滞位、防删除位等。

- SBIT 权限仅对目录有效，对于⽂件⽆效;一旦目录设定了 SBIT 权限，则用户在此目录下创建的文件或目录，就只有所属者自己和 root 才有权利修改或删除该文件。
- 允许各用户在 SBIT 权限目录中任意新建、删除自己的文件或目录，但是禁止修改（删除和移动/更名）其他用户的文件或目录;
- 虽然其他用户不能对 SBIT 权限目录里的文件进行删除或者移动操作，但是如若其他用户对该文件有 w 权限，还是可以进行修改文件内容的。 (即粘滞位保护的是目录里的文件本身不被其他用户修改，即使文件对其他用户有写权限，777都不行！)
- SBIT 权限都是针对 `其他用户(Other)` 设置;

在linux系统的实际应用中，粘滞位一般用于 `/tmp` 目录，以防止普通用户删除或移动其他用户的文件。

![202211251707191](https://gitee.com/librarookie/picgo/raw/master/img/202211251707191.png "202211251707191")

Sticky BIT 授权与取消：

```sh
# 授权
$ sudo chmod 1777 /tmp
## Or
$ sudo chmod o+t /tmp

# 取消
$ sudo chmod 777 /tmp
## Or
$ sudo chmod o-t /tmp
```

</br>

### 用户身份权限（su, sudo）

#### su - 以替代用户和组的身份运行一个命令

> su 命令可以在用户之间切换，但需要知道对方密码。比如su切换到root下，需要知道root密码。这就导致很多人都知道 root 的密码；

1. su 切换时，注意有个 `-`
    - 加 `-` ，表示不仅切换到用户下，连同用户的系统环境变量也切换进来了 【切换前后执行env看下环境变量】;
    - 不加 `-` ，表示仅仅切换到用户状态下，用户的系统环境变量没有切换进来;

2. 缺点
    - 系统安全；仅仅为了一个特权操作就直接赋予普通用户控制系统的完整权限；
    - root 密码泄露；需要把 root 密码告知每个需要 root 权限的人。

3. 配置禁止 su 到root账号

    关于su的相关权限涉及到两个文件,分别为 `/etc/pam.d/su` 和 `/etc/login.defs` 两个配置文件。

    - 禁止普通用户 su 到root
    `$ sudo vim /etc/pam.d/su`

        ```sh
        auth sufficient pam_rootok.so
        # Uncomment the following line to implicitly trust users in the "wheel" group.
        #auth sufficient pam_wheel.so trust use_uid
        # Uncomment the following line to require a user to be in the "wheel" group.
        #auth required pam_wheel.so use_uid     #<-- 取消此行注释即可（保存后即生效）
        ```

        Tips：

        - 默认状态下是允许所有用户间使用 su 命令进行切换的！
        - 取消上面注释后，表示只有 root 用户和 wheel 组内的用户才可以使用su命令。

    - 只允许指定的普通用户可以 su 到 root

        在 /etc/login.defs 文件中加入 `SU_WHEEL_ONLY yes` （保存后生效），然后将指定的用户加入 wheel 组即可。（表示只有wheel组内的用户才能使用su命令，root用户也被禁用su命令）

4. 用户组管理（组内添加和删除用户）以及组权限管理设置

    将需要 su到 root 用户的用户名添加至 wheel 组中；

    `$ sudo usermod -G wheel 用户名`

    将一个用户拉入到一个组内，有下面两种方法：

    ```sh
    # 添加到组内
    usermod -G 组名 用户名
    gpasswd -a 用户名 组名

    # 从组内删除
    gpasswd -d 用户名 组名
    ```

</br>

#### sudo - 以其他用户身份执行命令

> 普通用户执行只有 root 用户才能执行的操作命令，且不需要知道root密码，只需要输入自己账号密码即可（前提是需要将相关账号设置sudo权限）

##### sudo 介绍

考虑到使用 su 命令可能对系统安装造成的隐患，最常见的解决方法是使用 sudo 命令，此命令也可以让你切换至其他用户的身份去执行命令。

1. sudo的特性：
    - sudo 能够限制用户只在某台主机上运行某些命令。
    - sudo 提供了丰富的日志，详细地记录了每个用户干了什么。它能够将日志传到中心主机或者日志服务器。
    - sudo 使用时间戳文件来执行类似的“检票”系统。当用户调用sudo并且输入它的密码时，用户获得了一张存活期为5分钟的票（这个值可以在编译的时候改变）。也就是说，我刚刚输入了 `sudo cat /etc/issue` 然后可以再次只需要输入 `cat/etc/issue` 即可，不需要再次输入sudo。
    - sudo 的配置文件是 `/etc/sudoers` 文件，它允许系统管理员集中的管理用户的使用权限和使用的主机。
    - root 执行 sudo 时不需要输入密码（sudoers文件中默认有配置 “root ALL=(ALL) ALL” 规则）；
    - 若欲切换的身份与执行者的身份相同，也不需要输入密码。
    - 可以通过手动修改 sudo 的配置文件，使其无需任何密码即可运行。

2. sudo的工作过程：

    ```md
    1. 当用户运行 sudo 命令时，系统会先通过 /etc/sudoers 文件，验证该用户是否有运行 sudo 的权限；
    2. 确定用户具有使用 sudo 命令的权限后，还要让用户输入自己的密码进行确认。出于对系统安全性的考虑，如果用户在默认时间内（默认是 5 分钟）不使用 sudo 命令，此后使用时需要再次输入密码；
    3. 密码输入成功后，才会执行 sudo 命令后接的命令。
    ```

3. sudo 的应用

    - 用法：

        `sudo [-b] [-u username] commands`

    - 常用的选项与参数：

        ```md
        -b  ：将后续的命令放到背景中让系统自行运行，不对当前的 shell 环境产生影响。
        -u  ：后面可以接欲切换的用户名（默认切换身份为 root）
        -l  ：此选项的用法为 sudo -l，用于显示当前用户可以用 sudo 执行那些命令。
        ```

</br>

##### sudo 配置

修改 /etc/sudoers，不建议直接使用 vim，而是使用 visudo。因为修改 /etc/sudoers 文件需遵循一定的语法规则，使用 visudo 的好处就在于，当修改完毕 /etc/sudoers 文件，离开修改页面时，系统会自行检验 /etc/sudoers 文件的语法。

/etc/sudoers 中模板的含义分为是：

```sh
root ALL=(ALL) ALL
#用户名 被管理主机的地址=(可使用的身份) 授权命令(绝对路径)
%wheel ALL=(ALL) ALL
#%组名 被管理主机的地址=(可使用的身份) 授权命令(绝对路径)
```

参数：

- 用户名或群组名： 表示系统中的那个用户或群组（也可以是别名），可以使用 sudo 这个命令。每个用户设置一行，多个用户设置多行，也可以将多个用户设置成一个别名后再进行设置。
- 被管理主机的地址： 用户可以管理指定 IP 地址的服务器。这里如果写 ALL，则代表用户可以管理任何主机；如果写固定 IP，则代表用户可以管理指定的服务器。如果我们在这里写本机的 IP 地址，不代表只允许本机的用户使用指定命令，而是代表指定的用户可以从任何 IP 地址来管理当前服务器。
- 可使用的身份： 就是把来源用户切换成什么身份使用，（ALL）代表可以切换成任意身份。如果要排除个别用户，可以在括号内设置，比如ALL=(ALL,!root,!ops)。也可以设置别名（这个字段可以省略，如：admin ALL=/sbin/shutdown -r now）
- 授权命令： 即使用sudo后可以执行所有的命令列表。需要注意的是，此命令必须使用绝对路径写。`NOPASSWD: ALL` 表示使用sudo的不需要输入密码。（默认值是 ALL，表示可以执行任何命令。也可以设置别名）

常用 sudo 权限的安全设置一般可以满足下面4个条件：

1. 禁止普通用户使用sudo 命令切换到root模式下
    众所周知，只要给普通用户设置了sudo权限，那么它就可以使用“sudo su root”命令切换到root用户下（sudo权限只要输入自己的密码），这是很不安全的。必须禁止这种做法。配置如下：

    ![202211301740569](https://gitee.com/librarookie/picgo/raw/master/img/202211301740569.png "202211301740569")

    如上设置，表示 wangshibo 用户在使用sudo权限后，禁止使用 `bash` 和 `su` 命令。也就是说：禁止了该用户使用sudo切换到root模式下了。
    其中：

    - `!/bin/bash` : 是禁止了sudo -s的切换
    - `!/bin/su` : 是禁止了sudo中带su的切换

    限制用户使用 root 身份

    ![202211301745197](https://gitee.com/librarookie/picgo/raw/master/img/202211301745197.png "202211301745197")

    以上设置表示：wangshibo 账号在sudo状态下享有除root之外的其他用户状态下的权限。默认是（ALL），即sudo享有所有用户状态下的权限。

2. 用户使用sudo命令，必须每次都输入密码

    在 /etc/sudoers 文件里添加内容 `Defaults timestamp_timeout=0` ， 即表示每次使用sudo命令时都要输入密码。

    ![202211301749514](https://gitee.com/librarookie/picgo/raw/master/img/202211301749514.png "202211301749514")

    当然也能设置普通用户的sudo无密码登录，配置如下：

    ```sh
    # User privilege specification
    root    ALL=(ALL:ALL) ALL
    wangshibo   ALL=(ALL) NOPASSWD: ALL
    
    # Allow members of group sudo to execute any command
    %sudo   ALL=(ALL:ALL) NOPASSWD:ALL      #这一行也要添加"NOPASSWD"，否则前面的普通用户设置的sudo无密码切换无效！
    ```

3. 用户组管理（组内添加和删除用户）以及组权限管理设置

    进行用户权限管理，设置sudo权限时，可以设置 `组` 的权限，不同的组有不同的权限，然后将用户拉到相应权限的组内。

    ![202211301752573](https://gitee.com/librarookie/picgo/raw/master/img/202211301752573.png "202211301752573")

    以上设置表示: `wheel` 组内的用户在使用sudo权限后，禁止使用bash和su命令，也就是禁止了该组内用户使用sudo切换到root模式下了。

4. 使用别名（用户名以及命令的别名）进行设置

    Alise设置别名有以下四种情况（别名一定要是大写字母）：

    - 别名定义：

        ```sh
        #1. Host_Alias ：主机的列表，可以使用IP、主机名；不过在同一个别名内不能同时混用主机名和ip地址，如：
            - Host_Alias HOST_FLAG = hostname1, hostname2, hostname3
            - Host_Alias HOST_FLAG1 = 192.168.1.12, 192.1681.13, 192.168.1.14
            - Host_Alias HOST_FLAG2 = hostname1, 192.1681.13, 192.168.1.14    # 这种设置是错误的！不能在同一个别名内混用主机名和ip

        #2. Cmnd_Alias ：允许执行的命令列表，命令前加上 "!" 表示不能执行此命令。命令一定要使用绝对路径（避免其他目录的同名命令被执行，造成安全隐患）
            - Cmnd_Alias COMMAND_FLAG = command1, command2, command3 ，!command4

        #3. User_Alias ：具有sudo权限的用户列表
            - User_Alias USER_FLAG = user1, user2, user3

        #4. Runas_Alias ：就是用户以什么身份执行（例如root）的列表
            - Runas_Alias RUNAS_FLAG = operator1, operator2, operator3
        ```

    - 别名使用：

        ```sh
        # 使用别名配置权限的格式如下：
        USER_FLAG HOST_FLAG=(RUNAS_FLAG) COMMAND_FLAG

        # 如果不需要密码验证的话，就加上 “NOPASSWD”
        USER_FLAG HOST_FLAG=(RUNAS_FLAG) NOPASSWD:COMMAND_FLAG
        ```

    - 栗子：通过设置命令的别名进行权限设置。

        即将一系列命令放在一起设置一个别名，然后对别名进行权限设置。注意：Delegating permissions 代理权限相关命令别名

        ![202211301750021](https://gitee.com/librarookie/picgo/raw/master/img/202211301750021.png "202211301750021")

        ![202211301750320](https://gitee.com/librarookie/picgo/raw/master/img/202211301750320.png "202211301750320")

        以上设置说明：wnagshibo用户在sudo权限下只能使用ls，rm，tail命令

</br>

##### sudo 日志审计

作为一个Linux系统的管理员，不仅可以让指定的用户或用户组作为root用户或其它用户来运行某些命令，还能将指定的用户所输入的命令和参数作详细的记录。而sudo的日志功能就可以用户跟踪用户输入的命令，这不仅能增进系统的安全性，还能用来进行故障检修。

```sh
1. 检查服务器系统版本
# Centos 5.x 为syslog，对应的日志配置文件为/etc/syslog.conf
# Centos 6.x 为rsyslog，对应的日志配置文件为/etc/rsyslog.conf

1. 配置日志服务
$ echo "local2.debug /var/log/sudo.log" >> /etc/rsyslog.conf
## 查看配置是否添加成功
$ tail -1 /etc/rsyslog.conf

1. 配置sudoers
$ echo "Defaults logfile=/var/log/sudo.log" >> /etc/sudoers
## 查看配置
$ tail -1 /etc/sudoers

1. 重启日志服务
$ systemctl restart rsyslog
```

</br>

## 普通权限（chmod, chown, chgrp）

### 数字权限（chmod）

> chmod 设置数字权限4,2,1，分别对应的是可读(r)，可写(w) 和可执行(x)。对目录设置权限时，可以加 -R 递归地改变文件和目录；（帮助理解：ch==change, mod==modify）</br>
> chmod 当权限数字存在四位时，第一位表示的是特殊权限，权限数字4,2,1，分别对应的是SetUID(s)，SetGID(s) 和SBIT(t)。

- Usage:

    ```sh
    chmod [OPTION]... MODE[,MODE]... FILE...
    # Or
    chmod [OPTION]... --reference=RFILE FILE...
    ```

- Options:

    ```md
    -v, --verbose          对每一个被处理的文件输出一个诊断报告
    -c, --changes          与 verbose 相似，但只在有变化时报告
    -f, --silent, --quiet         抑制大多数错误信息
        --no-preserve-root        不特别处理'/'（默认）
        --preserve-root           不能对'/'进行递归操作
        --reference=RFILE         使用 RFILE（参考文件） 的权限模式而不是 MODE 值
    -R, --recursive        递归地改变文件和目录
        --help        显示此帮助并退出
        --version     输出版本信息并退出
    ```

    Tips： 每个 MODE 的形式: `[ugoa]-+=[rwxXst]`、`[ugoa]-+=[ugo]`、`[-+=]0-7` （+ 表示给文件或目录添加属性，- 表示移除文件或目录拥有的某些属性，= 表示使文件或目录只有这些属性。）

</br>

### 字符权限（chown, chgrp）

> 字符权限设置；chown 默认表示所属者权限，chgrp 表示所属组权限。（帮助理解：ch==change, own==owner, grp==group）

- Usage:

    ```sh
    chown [OPTION]... [OWNER][:[GROUP]] FILE...
    # Or:  
    chown [OPTION]... --reference=RFILE FILE...
    ```

    ```sh
    chgrp [OPTION]... GROUP FILE...
    # Or:  
    chgrp [OPTION]... --reference=RFILE FILE...
    ```

- Options:

    ```md
    -v, --verbose           对每个被处理的文件输出诊断信息
    -c, --changes           与 verbose 相似，但只在做出改变时报告
    -f, --silent, --quiet   抑制大多数错误信息
        --no-preserve-root  不特别处理'/'（默认）。
        --preserve-root     不对'/'进行递归操作。
        --reference=RFILE   使用RFILE的所有者和组，而不是指定OWNER:GROUP值。指定OWNER:GROUP值
    -R, --recursive         对文件和目录进行递归操作
        --help          显示此帮助并退出
        --version       输出版本信息并退出

        --dereference       影响每个符号链接的引用者（这是默认情况下），而不是符号链接本身。
    -h, --no-dereference    影响符号链接而不是任何被引用的文件（只在可以改变符号链接所有权的系统上有用符号链接的所有权）。

        --from=CURRENT_OWNER:CURRENT_GROUP
                        改变每个文件的所有者和/或组，只有在它的当前所有者和/或组与这里指定的这里。两者都可以省略，在这种情况下，匹配的不需要与被省略的属性相匹配。

    下面的选项修改了当-R 选项时，下列选项修改了层次结构的遍历方式。 如果指定了一个以上的选项，只有最后的选项才会生效。

    -H          如果一个命令行参数是一个符号链接到一个目录的符号链接，则遍历它
    -L          遍历每个目录的符号链接遇到的
    -P          不遍历任何符号链接（默认值）
    ```

    Tips: OWNER 和 GROUP 可以是数字的，也可以是符号的。

- Examples:

    ```sh
    chown root /test          # 将 /test 的所有者改为 "root";
    chown root:staff /test    # 将 /test 的所有者改为 "root"，组改为 "staff";
    chown -hR root /test      # 将 /test 和子文件的所有者改为 "root";

    chown --reference=/home /test   # 将 /test 的所有者和组都改成 /home 一样;
    ```

    ```sh
    chgrp staff /test       # 将 /test 的组改为 "staff";
    chgrp -hR staff /test   # 将 /test 和子文件的组别改为 "staff";

    chgrp --reference=/home /test   # 将 /test 组改成 /home 一样;
    ```

</br>

## 隐藏权限（chattr, lsattr）

> 管理 Linux 系统中的文件和目录，除了可以设定普通权限和特殊权限外，还可以利用文件和目录具有的一些隐藏属性。（帮助理解：ls==list, ch==change, attr==attribute）</br>

1. lsattr--列出Linux第二扩展文件系统的文件属性

    - Usage:

        ```sh
        lsattr [ -RVadlpv ] [ files... ]
        ```

    - Options:

        ```md
        -R     递归地列出目录的属性和它们的内容。
        -V     显示程序版本。
        -a     列出目录中的所有文件，包括以`.'开头的文件。
        -d     像其他文件一样列出目录，而不是列出其内容。（类似ls 的 -d 参数）
        -l     使用长名称而不是单字符缩写来打印选项。
        -p     列出文件的项目编号。
        -v     列出文件的版本/代号。
        ```

2. chattr--改变Linux文件系统中的文件属性

    - Usage:

        ```sh
        chattr [ -RVf ] [ -v version ] [ -p project ] [-+=aAcCdDeijPsStTuFx] files...
        ```

    - Options:

        ```md
        -R     递归地改变目录及其内容的属性。
        -V     对chattr的输出保持粗略，并打印程序版本。
        -f     抑制大多数错误信息。。
        -v     设置文件的版本/代号。
        -p     设置文件的项目编号。
        ```

    - Attributes [aAcCdDeFijmPsStTux]:

        ```sh
        # 常用属性
        i   不能修改（Immutable）。
                如果对 "文件" 设置，那么不允许对文件进行进行任何的修改（删除、重命名，创建链接和写入数据等）；
                如果对 "目录" 设置，那么只能修改目录下文件中的数据，但不允许新建、重命名和删除文件；
                （只有超级用户或拥有 CAP_LINUX_IMMUTABLE 能力的进程可以设置或清除这个属性。）
        a   只能附加数据（Append）。
                如果对 "文件" 设置，那么只能在文件中追加数据，但不能删除和修改数据；
                如果对 "目录" 设置，那么只允许在目录中新建和修改文件，但不允许重命名和删除文件；
                （只有超级用户或拥有 CAP_LINUX_IMMUTABLE 能力的进程可以设置或清除这个属性。）
        u   文件被删除时（undeletable），设置了'u'属性的文件被删除时，其内容被保存。 这允许用户要求撤销其删除。常用来防止意外删除文件或目录
        s   安全删除（secure）。和 u 相反，删除文件或目录时，会被彻底删除（直接从硬盘上删除，然后用 0 填充所占用的区域），不可恢复。
        
        # 其他属性
        A   不修改访问时间（Atime）。不修改文件的最后访问时间。
        c   压缩文件（Compressed）。将文件或目录压缩后存放；设置了'c'属性的文件被内核自动压缩到磁盘上。 从这个文件中读出的数据是未经压缩的。 写入这个文件时，在将数据存储在磁盘上之前会对其进行压缩。
        C   不执行写入时复制（Copy） 。多个调用者获取同一个资源，这时，另一个调用者对这资源进行了修改，不生成一个副本给（对于btrfs，'C'标志应该被设置在新的或空的文件上。如果'C'标志被设置了，那么'c'标志就不能被设置。）
        d   不转储（Dump）。当dump程序执行时，该文件或目录不会被dump备份。
        D   同步目录更新（Directory）。当设置了'D'属性的目录被修改时，修改内容会同步写入磁盘；这相当于'dirsync'挂载选项应用于文件的一个子集。
        e   extent格式（一种文件系统格式）。表示该文件使用extents来映射磁盘上的块。它不能用 chattr(1)删除。
        F   设置了'F'属性的目录表示该目录内的所有路径查询都是不区分大小写的。 这个属性只能在启用了大小写功能的文件系统上的空目录中被改变。
        j   数据日志（Journaling）
                如果文件系统是用 "data=ordered "或 "data=writeback "选项挂载的，并且文件系统有一个日志，那么具有'j'属性的文件在被写入文件本身之前，其所有的数据都被写入ext3或ext4日志。
                当文件系统以 "data=journal "选项挂载时，所有的文件数据都已经有了日志，这个属性没有影响。（只有超级用户或具有 CAP_SYS_RESOURCE 能力的进程才能设置或清除这个属性。）
        m   不要压缩（compress），具有'm'属性的文件在支持每个文件压缩的文件系统中被排除在压缩之外。
        P   设置了'P'属性的目录将为项目ID强制执行一个层次结构。
        S   同步更新（synchronous），一旦应用程序对这个文件执行了写操作，使系统立刻把修改的结果写到磁盘。
        t   无尾部合并（tail-merging）。具有't'属性的文件不会在文件的末尾有部分块碎片与其他文件合并（对于那些支持尾部合并的文件系统）。 
        T   目录层次结构的顶部（Top）。带有'T'属性的目录将被认为是目录层次的顶端，以便于Orlov块分配器的使用。
        x   该属性可以设置在一个目录或文件上。 
                如果该属性被设置在一个现有的目录上，它将被随后在该目录中创建的所有文件和子目录所继承。  
                如果一个现有的目录已经包含了一些文件和子目录，在父目录上修改属性不会改变这些文件和子目录的属性。

        # 下面的属性是只读的，不能用 chattr(1) 来设置或清除，但可以被 lsattr(1) 显示。
        E   加密（encrypted），设置了'E'属性的文件、目录或符号链接是由文件系统加密的。 它
        I   索引目录（indexed），"I "属性被htree代码使用，以表示一个目录正在使用散列树进行索引。 
        N   在线数据，设置了'N'属性的文件表示该文件有内联存储的数据，在inode本身中。
        V   和真实性（verity），设置了'V'属性的文件启用了fs-verity。  它不能被写入，文件系统将自动根据涵盖整个文件内容的加密哈希值来验证从它那里读出的所有数据，例如，通过Merkle树。 这使得有效地验证文件成为可能。
        ```

3. Examples

    - lsattr:

        ```sh
        # 查看文件 属性
        $ lsattr 文件名

        # 查看目录 属性
        $ lsattr -d 目录名

        # 查看目录下全部文件的属性（本级目录）
        $ lsattr -a 目录名

        # 查看目录下所有文件的属性（本级目录及子目录）
        $ lsattr -R 目录名
        ```

    - chattr:

        ```sh
        # 赋予 a 属性
        $ chattr +a  文件名

        # 删除 a 属性
        $ chattr -a 文件名
        ```

</br>

## ACL 访问控制权限（setfac, getfacl）

> ACL，是 Access Control List（访问控制列表）的缩写，在 Linux 系统中， ACL 可实现对单一用户设定访问文件的权限。也可以这么说，设定文件的访问权限，除了用传统方式（3 种身份ugo搭配 3 种权限rwx），还可以使用 ACL 进行设定。

### ACL 使用场景

![202211161432213](https://gitee.com/librarookie/picgo/raw/master/img/202211161432213.png "202211161432213")

如图所示，根目录中有一个 `/project` 目录，这是班级的项目目录。

1. 场景一

    老师需要拥有对该目录的最高权限，本班级中的每个学员都可以访问和修改这个目录，其他班级的学员不能访问这个目录。需要怎么规划这个目录的权限呢？

    权限分配（ugo + rwx）：

    ```md
    1. 老师使用 root 用户，作为这个目录的属主，权限为 rwx；
    2. 班级所有的学员都加入 tgroup 组，使 tgroup 组作为 /project 目录的属组，权限是 rwx；
    3. 其他人的权限设定为 0（即权限为 ---）。
    ```

2. 场景二

    接场景一后，班里来了一位试听的学员 stu ，她必须能够访问 /project 目录，所以必须对这个目录拥有 r 和 x 权限；但是她又没有学习过以前的课程，怕她改错了目录中的内容，所以不能赋予她 w 权限；所以学员 stu 的权限就是 r-x 。

    可是如何分配她的身份呢？

    - 变为属主？当然不行，要不 root 该放哪里？
    - 加入 tgroup 组？也不行，因为 tgroup 组的权限是 rwx，
    - 而我们要求学员 stu 的权限是 r-x 。如果把其他人的权限改为 r-x 呢？这样一来，其他班级的所有学员都可以访问 /project 目录了。

    显然，普通权限的三种身份不够用了，无法实现对某个单独的用户设定访问权限，这种情况下，就需要使用 ACL 访问控制权限。

</br>

### ACL 权限应用

> 主要目的是提供传统的owner, group, others的read, write, execute权限之外的具体权限设置。

设定 ACl 权限，常用命令有 2 个，分别是 `setfacl` 和 `getfacl` 命令，前者用于给指定文件或目录设定 ACL 权限，后者用于查看是否配置成功。

1. getfacl--获取文件访问控制列表

    - Usage:

        ```sh
        getfacl [-aceEsRLPtpndvh] file ...
        ```

        Tips： 如果发现在权限位后面多了一个"+"，表示此目录拥有ACL权限。

    - Options:

        ```md
        -a, --access            只显示文件访问控制列表（默认，显示所有信息）
        -d, --default           只显示默认访问控制列表（只显示文件名，所属者和所属组）
        -c, --omit-header       不显示注释头（不显示文件名，所属者和所属组）
        -e, --all-effective     打印所有有效权限
        -E, --no-effective      打印没有生效的权利
        -s, --skip-base         跳过只有基本条目的文件（只显示 setfacl 授权的文件）
        -R, --recursive         递归到子目录里（递归显示目录和子目录）
        -L, --logical           跟踪符号链接
        -P, --physical          跳过所有符号链接，包括符号链接文件
        -t, --tabular           使用表格式输出
        -n, --numeric           打印数字的用户/组标识符（用户名/组名使用 数字ID 显示）
            --one-file-system   跳过不同文件系统上的文件
        -p, --absolute-names    在路径名中不去除前面的'/' （不从绝对路径名称中删除根的'/'）
        -v, --version           版本
        -h, --help              帮助
        ```

    - getfacl的输出格式如下:

        ```md
         1. # file: somedir/
         2. # owner: lisa
         3. # group: staff
         4. # flags: -s-
         5. user::rwx
         6. user:joe:rwx               #effective:r-x
         7. group::rwx                 #effective:r-x
         8. group:cool:r-x
         9. mask::r-x
        10. other::r-x
        11. default:user::rwx
        12. default:user:joe:rwx       #effective:r-x
        13. default:group::r-x
        14. default:mask::r-x
        15. default:other::---

        # 第 1-3 行表示文件名、所有者和拥有组。
        # 第 4 行表示setuid（s）、setgid（s）和sticky（t）位：代表该位的字母，否则就是破折号（-）。（如果这些位中的任何一个被设置了，这一行就会被包括进去，否则就会被省略，所以它不会被显示在大多数文件中。）
        # 第 5、7 和10 行对应于文件模式权限位的用户（u）、组（g）和其他（o）。这三条被称为基本ACL条目。
        # 第 6行和第 8行是 “命名用户” 和 “命名组” 条目。
        # 第 9 行是有效权利屏蔽。这个条目限制了授予 “所有组” 和 “命名用户” 的有效权利。（文件所有者和其他人的权限不受有效权利掩码的影响；所有其他条目都受影响。）。
        # 第 11-15 行显示与该目录相关的默认ACL。（目录可以有一个默认的ACL。普通文件没有默认的ACL。）
        
        # getfacl的默认行为是同时显示ACL和默认ACL，并且在条目的权限与有效权限不同的行中包含一个有效权限注释。
        # getfacl的输出也可以作为setfacl的输入。
        ```

2. setfacl--设置文件访问控制列表

    - Usage:

        ```sh
        setfacl [-bkndRLP] { -m|-M|-x|-X ... } file ...
        ```

    - Options:

        ```md
        -m, --modify=acl        设置文件的当前ACL（添加 ACL 权限）
        -M, --modify-file=file  从文件读取访问控制列表条目并更改
        -x, --remove=acl        从文件的ACL中删除条目（删除指定 ACL 权限）
        -X, --remove-file=file  从文件读取访问控制列表条目并删除
        -b, --remove-all        删除所有扩展ACL条目（删除全部 ACL 权限）
        -k, --remove-default    删除默认 ACL 权限（如果没有默认规则，将不提示）
            --set=acl           设置文件的 ACL，替换当前的 ACL
            --set-file=file     从文件中读设置ACL规则
            --mask              重新计算有效的权利掩码，即使ACL mask被明确指定
        -n, --no-mask           不重新计算有效的权利掩码。setfacl默认会重新计算ACL mask，除非mask被明确的制定
        -d, --default           操作适用于默认ACL（设定默认的acl权限，针对目录而言）
        -R, --recursive         递归到子目录中去（递归的对所有文件及目录进行操作）
        -L, --logical           跟踪符号链接（默认情况下只跟踪符号链接文件，跳过符号链接目录）
        -P, --physical          跳过所有符号链接，包括符号链接文件
            --restore=file      从文件恢复备份的acl规则（这些文件可由getfacl -R产生）。通过这种机制可以恢复整个目录树的acl规则。此参数不能和除--test以外的任何参数一同执行
            --test              测试模式，不会改变任何文件的acl规则，操作后的acl规格将被列出
        -v, --version           版本
        -h, --help              帮助

        --          命令行选项结束。所有剩下的参数都被解释为文件名，即使它们以破折号开始。
        -           如果文件名参数是一个破折号，setfacl会从标准输入中读取一个文件列表。
        ```

    - ACL ENTRIES(条目):

        ```sh
        # setfacl工具可以设置以下ACL条目格式（为清晰起见，插入了空白）:
        [d[efault]:] [u[ser]:]uid [:perms]
            # 一个指定的用户的权限。如果uid为空，则为文件所有者的权限。

        [d[efault]:] g[roup]:gid [:perms]
            # 一个指定的组的权限。如果gid为空，则为拥有组的权限。

        [d[efault]:] m[ask][:] [:perms]
            # 有效的权利屏蔽

        [d[efault]:] o[ther][:] [:perms]
            # 其他人的权限

        # 在修改和设置操作中使用适当的ACL条目包括权限。(选项-m、-M、-set和-set-file）。 没有perms字段的条目被用于删除条目（选项-x和-X）。
        ```

3. Examples

    - getfacl:

        ```sh
        # 查看文件
        $ getfacl 文件名

        # 只查看目录下 拥有 ACL权限的文件
        $ getfacl -s 目录名

        # 查看目录下 所有文件
        $ getfacl -R 目录名
        ```

    - setfacl:

        ```sh
        # 添加 ACL权限
        $ setfacl -m u:用户名:权限 文件名       # 通过 所属者方式
        $ setfacl -m g:组名:权限 文件名        # 通过 所属组方式

        $ setfacl -R -m u:用户名:权限 目录名    # 通过 所属者方式（如果这个目录被mount挂载或nfs挂载上了，就不支持setfacl权限操作了）
        $ setfacl -R -m g:组名:权限 目录名      # 通过 所属组方式     

        # 删除指定 ACL权限
        $ setfacl -x u:用户名 文件名            # 删除文件上的这个 用户的acl权限
        $ setfacl -x g:组名 文件名             # 删除文件上的这个 所属组的acl权限

        $ setfacl -R -x u:用户名 目录名           # 删除目录 上的这个用户的acl权限
        $ setfacl -R -x g:组名 目录名           # 删除目录 上的这个所属组的acl权限

        # 删除所有 ACL权限
        $ setfacl -b 文件名            # 删除文件 上的全部acl权限
        $ setfacl -R -b 目录名         # 删除目录 上的全部acl权限

        # 默认 ACL权限
        $ setfacl -m d:u:用户名:权限 目录名     # 添加默认acl权限
        $ setfacl -m d:g:组名:权限 目录名     # 添加默认acl权限
        $ setfacl -k 目录名                  # 删除上默认acl权限
        # 默认 ACL 权限的作用是，如果给父目录设定了默认 ACL 权限，那么父目录中所有新建的子文件都会继承父目录的 ACL 权限。需要注意的是，默认 ACL 权限只对目录生效。
        ```

    - setfacl 2:

        ```sh
        # 撤销所有组和所有指定用户的写权限（使用有效的权利屏蔽，限制了授予 “所有组” 和 “命名用户” 的有效权利（文件所有者和其他人的权限不受有效权利掩码的影响；所有其他条目都受影响））
        $ setfacl -m m::rx file

        # 将一个文件的ACL复制到另一个文件上
        $ getfacl file1 | setfacl --set-file=- file2

        # 将访问ACL复制到默认ACL中
        $ getfacl [-a] dir1 | setfacl -d -M- dir1
        ```

</br>

## 栗子

### 常用权限栗子（rwx, SetUID、SetGID 和 SBIT）

我们先了解一下文件：

`$ ls -l`

```sh
drwxrwxr-x 2 noname noname 4096 Dec  1 10:51 dir/
-rw-rw-r-- 1 noname noname    0 Nov 24 09:25 test.txt
```

从左到右分别是： 文件类型、所属者权限、所属组权限、其他者权限 所属者 所属组。。。

- 文件类型： `d` `-`分别表示目录和文件;
- 所属者权限(u)： 分表表示 读(r)、写(w)、执行(x) 和 SetUID（特殊权限）
- 所属组权限(g)： 分表表示 读(r)、写(w)、执行(x) 和 SetGID（特殊权限）
- 其他者权限(o)： 分表表示 读(r)、写(w)、执行(x) 和 Sticky BIT（特殊权限）
- 所属者、所属组： 表示该文件的拥有者、所属用户组；
- 其他者： 既不属于文件或目录的拥有者也不属于文件或目录的所属组；

SetUID(s)，SetGID(s) 和SBIT(t)分别显示在 ugo 的 `x` 位置，如果本来在该位上有执行权限（x）, 则这些特殊标志显示为小写字母 (s, s, t). 否则, 显示为大写字母 (S, S, T)

ugo中每一个rwx对应数字权限：

- 读(r) = 4
- 写(w) = 2
- 执行(x) = 1
- 无 = 0

而特殊权限是数字权限的第一位，分别对应：

- SetUID(s) = 4
- SetGID(s) = 2
- SBIT(t) = 1
- 无 = 0 或空

case 1.普通权限（rwx）: rw-rw-r--

- 数字授权

    ```sh
    $ chmod 644 test.txt
    # Or
    $ chmod 0644 test.txt
    ```

- 字符授权

    ```sh
    $ chmod a+r test.txt
    $ chmod ug+w test.txt
    # Or
    $ chmod ug=rw test.txt
    $ chmod o=r test.txt
    ```

case 2.特殊权限（sst）, rw-rw-r--

- 数字授权

    ```sh
    # 特权权限在第一位
    $ chmod 0644 test.txt       # rw-rw-r--
    $ chmod 4644 test.txt       # rwSrw-r--
    $ chmod 2644 test.txt       # rw-rwSr--
    $ chmod 1644 test.txt       # rw-rw-r-T
    $ chmod 7644 test.txt       # rwSrwSr-T
    ```

    ```sh
    $ chmod ug+s test.txt       # rwSrwSr--
    $ chmod o+t test.txt       # rw-rw-r-T
    # Or
    $ chmod ug=rw test.txt
    $ chmod 7644 test.txt 
    ```

- 字符授权

    ```sh
    $ chmod ug+s test.txt       # rwSrwSr--
    $ chmod o+t test.txt       # rw-rw-r-T
    # 取消授权，则使用 - 即可
    ```

case 3.所属者和所属组

- 授权

    ```sh
    # 如果需要连带子目录一起，则加上 ‘-R’
    $ chgrp noname test.txt     # 将 test.txt 文件的所属组改为 noname
    $ chown noname test.txt     # 将 test.txt 文件的所属者改为 noname

    # 将 test.txt 文件的所属者改为 noname ，所属组改为 noname
    $ chown noname:noname test.txt
    $ chown noname.noname test.txt
    ```

</br>

### setfacl 栗子

> ACL可以针对单一用户、单一文件或目录来进行r,w,x的权限控制，对于需要特殊权限的使用状况有一定帮助。如，某一个文件不让单一的某个用户访问等。

#### setfacl -m：给用户或群组添加 ACL 权限

回归上面的案例，解决方案如下：

- 老师使用 root 用户，并作为 /project 的所有者，对 project 目录拥有 rwx 权限；
- 新建 tgroup 群组，并作为 project 目录的所属组，包含本班所有的班级学员（假定只有 zhangsan 和 lisi），拥有对 project 的 rwx 权限；
- 将其他用户访问 project 目录的权限设定为 0（也就是 ---）。
- 对于试听学员 stu 来说，我们对其设定 ACL 权限，令该用户对 project 拥有 rx 权限

1. 准备环境

    ```sh
    # 添加需要试验的用户和用户组，省略设定密码的过程
    [root@localhost ~]# useradd zhangsan
    [root@localhost ~]# useradd lisi
    [root@localhost ~]# useradd stu
    [root@localhost ~]# groupadd tgroup

    # 建立需要分配权限的目录
    [root@localhost ~]# mkdir /project

    # 改变/project目录的所有者和所属组
    [root@localhost ~]# chown root:tgroup /project

    # 指定/project目录的权限
    [root@localhost ~]# chmod 770 /project

    [root@localhost ~]# ll -d /project
    drwxrwx---. 2 root tgroup 4096 Apr 16 12:55 /project
    ```

2. 分配权限

    这时 stu 学员来试听了，如何给她分配权限

    ```sh
    # 给用户 stu 赋予r-x权限，使用"u:用户名：权限" 格式
    [root@localhost ~]# setfacl -m u:stu:rx /project
    [root@localhost /]# cd /
    [root@localhost /]# ll -d /project
    drwxrwx---+ 2 root tgroup 4096 Apr 16 12:55 /project
    ## 如果查询时会发现，在权限位后面多了一个"+"，表示此目录拥有ACL权限
    ```

3. 查看权限

    ```sh
    # 查看/prpject目录的ACL权限
    [root@localhost /]# getfacl project
    # file:project  #<--文件名
    # owner:root  #<--文件的所有者
    # group:tgroup  #<--文件的所属组
    user::rwx  #<--用户名栏是空的，说明是所有者的权限
    user:stu:r-x  #<--用户stu的权限
    group::rwx  #<--组名栏是空的，说明是所属组的权限
    mask::rwx  #<--mask权限
    other::---  #<--其他人的权限
    ```

4. 同理分配组权限

    ```sh
    [root@localhost /]# groupadd tgroup2
    # 添加新群组
    [root@localhost /]# setfacl -m g:tgroup2:rwx project
    # 为组tgroup2纷配ACL权限
    [root@localhost /]# ll -d project
    drwxrwx---+ 2 root tgroup 4096 1月19 04:21 project
    # 属组并没有更改
    [root@localhost /]# getfacl project
    # file: project
    # owner: root
    # group: tgroup
    user::rwx
    user:stu:r-x
    group::rwx
    group:tgroup2:rwx  #<-用户组tgroup2拥有了rwx权限
    mask::rwx
    other::---
    ```

</br>

#### setfacl -m d：设定默认 ACL 权限

> 默认 ACL 权限的作用是，如果给父目录设定了默认 ACL 权限，那么父目录中所有新建的子文件都会继承父目录的 ACL 权限。需要注意的是，默认 ACL 权限只能对目录设置。

1. 准备环境

    前面已经对 project 目录设定了 ACL 权限，现在在此目录中新建一些子文件和子目录，检验这些文件是否会继承父目录的 ACL 权限，如下：

    ```sh
    [root@localhost /]# cd /project

    #在/project目录中新建了 file1.txt 文件和 dir1 目录
    [root@localhost project]# touch file1.txt
    [root@localhost project]# mkdir dir1
    [root@localhost project]# ll
    总用量4
    -rw-r--r-- 1 root root 01月19 05:20 file1.txt
    drwxr-xr-x 2 root root 4096 1月19 05:20 dir1
    ```

    可以看到，这两个新建立的文件权限位后面并没有 "+"，表示它们没有继承 ACL 权限。这说明，后建立的子文件或子目录，并不会继承父目录的 ACL 权限。

2. 分配权限--给 project 文件设定 stu 用户访问 rx 的默认 ACL 权限，如下：

    ```sh
    [root@localhost /]# setfacl -m d:u:stu:rx project
    [root@localhost project]# getfacl project
    # file: project
    # owner: root
    # group: tgroup
    user:: rwx
    user:stu:r-x
    group::rwx
    group:tgroup2:rwx
    mask::rwx
    other::---
    default:user::rwx  #<--多出了default字段
    default:user:stu:r-x
    default:group::rwx
    default:mask::rwx
    default:other::---
    ```

3. 查看权限

    新建子文件和子目录，与赋予默认权限前的子文件做比对

    ```sh
    [root@localhost /]# cd project
    [root@localhost project]# touch file2.txt
    [root@localhost project]# mkdir dir2
    [root@localhost project]# ll 总用量8
    -rw-r--r-- 1 root root 01月19 05:20 file1.txt
    -rw-rw----+ 1 root root 01月19 05:33 file2.txt
    drwxr-xr-x 2 root root 4096 1月19 05:20 dir1
    drwxrwx---+ 2 root root 4096 1月19 05:33 dir2
    ```

    新建的file2.txt和dir2已经继承了父目录的ACL权限，而原先的 file1.txt 和 dir1 还是没有 ACL 权限，因为默认 ACL 权限是针对新建立的文件生效的。

</br>

#### setfacl 删除 ACL 权限（-k, -x, -b）

1. 删除默认权限（-k）

    使用 `setfacl -k` 命令，可以删除指定文件的 ACL 默认权限，如删除前面 project 目录的 ACL 默认权限：

    ```sh
    # 需要一起移除子目录的权限，则加上 ‘-R’ 参数即可。
    [root@localhost /]# setfacl -k project
    # project 目录的默认权限以被删除
    [root@localhost /]# getfacl project
    # file: project
    # owner: root
    # group: tgroup
    user:: rwx
    user:stu:r-x
    group::rwx
    group:tgroup2:rwx
    mask::rwx
    other::---
    ```

2. 删除指定的 ACL 权限（-x）

    使用 `setfacl -x` 命令，可以删除指定的 ACL 权限，如删除前面建立的 st 用户对 project 目录的 ACL 权限：

    ```sh
    [root@localhost /]# setfacl -x u:st project
    # st用户的权限已被删除
    [root@localhost /]# getfacl project
    # file: project
    # owner: root
    # group: tgroup
    user::rwx
    group::rwx
    group:tgroup2:rwx
    mask::rwx
    other::---
    ```

3. 删除指定文件的所有 ACL 权限（-b）

    使用 `setfacl -b` 命令，可删除所有与指定文件或目录相关的 ACL 权限。如现在我们删除一切与 project 目录相关的 ACL 权限：

    ```sh
    [root@localhost /]# setfacl -b project
    # 所有ACL权限已被删除
    [root@localhost /]# getfacl project
    # file: project
    # owner: root
    # group: tgroup
    user::rwx
    group::rwx
    other::---
    ```

</br>

#### setfacl -m m：设定限制已授予的 “所有组” 和 “命名用户” 的有效权利

> 这个条目只能限制已授予 “所有组” 和 “命名用户” 的有效权利。（文件所有者和其他人的权限不受有效权利掩码的影响；所有其他条目都受影响。）

- 环境

    ```sh
    # 环境目录 project
    [root@localhost /]# getfacl project
    # file: project  #<--文件名
    # owner: root  #<--文件的属主
    # group: tgroup  #<--文件的属组
    user::rwx  #<--用户名栏是空的，说明是所有者的权限
    group::rwx  #<--组名栏是空的，说明是所属组的权限
    other::---  #<--其他人的权限

    #给用户stu设定针对project目录的rx权限
    [root@localhost /]# setfacl -m u:stu:rx /project
    [root@localhost /]# getfacl project
    # file: project 
    # owner: root
    # group: tgroup 
    user::rwx 
    user:stu:r-x  #<--用户 stu 的权限
    group::rwx
    mask::rwx  #<--mask 权限
    other::---
    ```

    对比添加 ACL 权限前后 getfacl 命令的输出信息，后者多了 2 行信息，一行是我们对 st 用户设定的 r-x 权限，另一行就是 mask 权限。

    mask 权限，指的是用户或群组能拥有的最大 ACL 权限，也就是说，给用户或群组设定的 ACL 权限不能超过 mask 规定的权限范围，超出部分做无效处理。

- 分配限制权限

    mask 权限可以使用 setfacl 命令手动更改，比如，更改 project 目录 mask 权限值为 r-x，如下：

    ```sh
    # 设定mask权限为r-x，使用"m:权限"格式
    [root@localhost ~]# setfacl -m m:rx /project
    [root@localhost ~]# getfacl /project
    # file：project
    # owner：root
    # group：tgroup
    user::rwx
    group::rwx      #effective:r-x
    mask::r-x  #<--mask权限变为r-x
    other::---
    ```

    如上所示，给 stu 用户赋予访问 project 目录的 r-x 权限，还需要和 mask 权限对比，r-x 确实是在 rwx 范围内，这时才能说 st 用户拥有 r-x 权限。（#effective:r-x 表示该项实际权限）

    不过，我们一般不更改 mask 权限，只要赋予 mask 最大权限（也就是 rwx），则给用户或群组设定的 ACL 权限本身就是有效的。

</br>

### sudo 栗子

case 1.把wangsb，wangbz，songj用户设置成别名ADMINS，都拥有sudo权限

- `# visudo`

    ```sh
    # 定义用户列表
    User_Alias ADMINS = wangsb, songj，wangbz
    # 使用用户别名
    ADMINS ALL=(ALL) ALL
    ```

case 2.把visudo、chown、chmod等命令设置成别名DELEGATING，别名ADMINS里面的用户都禁用DELEGATING里面的命令

- `# visudo`

    ```sh
    # 定义命令列表
    Cmnd_Alias DELEGATING = /usr/sbin/visudo, /bin/chown, /bin/chmod, /bin/chgrp
    # 使用命令别名
    ADMINS ALL=(ALL) ALL,!DELEGATING
    ```

case 3.同时给多个用户授予同样的权限

- `# visudo`

    ```sh
    # 定义别名列表
    User_Alias ADMINS = wangbz,zhoulw,songj,wangsb
    Cmnd_Alias DELEGATING = /usr/sbin/visudo, /bin/chown, /bin/chmod, /bin/chgrp

    # 使用别名
    root ALL=(ALL) ALL
    ADMINS ALL=(ALL) ALL,!DELEGATING,!/bin/bash,!/bin/su

    # 每次使用sudo 都需要输入密码
    Defaults timestamp_timeout = 0
    ```

case 4.同时给多个用户授予同样的权限

- `# visudo`

    ```sh
    # 此配置信息表示: sudoGroup 这个群组中的所有用户都能够使用 sudo 切换任何身份，执行任何命令。
    %sudoGroup ALL=(ALL) ALL
    ```

    这样配置的好处： 如果我们想让 tester 用户使用 sudo 命令，不用再修改 /etc/sudoers 文件，只需要将 tester 加入 sudoGroup 群组即可。

case 5.线上服务器用过的一个配置：

- `# visudo`

    ```sh
    # 表示每次sudo时都要强行输入密码
    Defaults timestamp_timeout=0

    # kevin用户在使用sudo时只能使用这几个命令，其他sudo命令全部禁止！
    kevin ALL=(ALL) /usr/bin/tail,/bin/gzip,/usr/bin/vim,/bin/chown,/bin/chmod,/Data/app/nginx/sbin/nginx

    # grace用户使用sudo时，禁止后面设置的命令，其他的都可以使用。
    grace ALL=(ALL) ALL,!/bin/bash,!/bin/su,!/bin/chown,!/bin/chmod,!/sbin/init,!/sbin/reboot,!/sbin/poweroff
    ```

</br>

### chattr 栗子

> 只读属性 `i` ： 如果对 "文件" 设置，那么不允许对文件进行进行任何的修改（删除、重命名，创建链接和写入数据等）；如果对 "目录" 设置，那么只能修改目录下文件中的数据，但不允许新建、重命名和删除文件；</br>
> 只追加属性 `a`： 如果对 "文件" 设置，那么只能在文件中追加数据，但不能删除和修改数据；如果对 "目录" 设置，那么只允许在目录中新建和修改文件，但是不允许重命名和删除文件；

#### 文件隐藏属性演示

1. 演示 `文件` 只读属性（i）

    `chattr +i test.txt`

    ![202211110920099](https://gitee.com/librarookie/picgo/raw/master/img/202211110920099.png "202211110920099")

    由上图可知，只读属性 `i` 的文件权限如下：

     - 允许查看文件内容 (cat);
     - 不能追加文件内容 (>>)，vim 和 gedit 等工具只读打开，编辑后无法保存；
     - 不能覆盖文件内容 (>)；
     - 不能重命名 (mv)；
     - 允许复制文件 (cp)，复制的新文件不具备 i 属性；
     - 不能删除文件 (rm)；

2. 演示 `文件` 只追加属性（a）

    `chattr +a test.txt`

    ![202211110938205](https://gitee.com/librarookie/picgo/raw/master/img/202211110938205.png "202211110938205")

    由上图可知，只读属性 `a` 的文件权限如下：

     - 允许查看文件内容 (cat);
     - 允许追加文件内容 (>>)，vim 和 gedit 等工具编辑后无法保存；
     - 不能覆盖文件内容 (>)；
     - 不能重命名 (mv)；
     - 允许复制文件 (cp)，复制的新文件不具备 a 属性；
     - 不能删除文件 (rm)；

3. 删除文件属性（以 i 属性为例）

    `chattr -i test.txt`

    ![202211110922898](https://gitee.com/librarookie/picgo/raw/master/img/202211110922898.png "202211110922898")

</br>

#### 目录隐藏属性演示

1. 演示 `目录` 只读属性（i）

    `chattr +i demoDir`

    ![202211111730048](https://gitee.com/librarookie/picgo/raw/master/img/202211111730048.png "202211111730048")

    由上图可知，只读属性 `i` 的目录权限如下：

     - 允许进入目录 cd demoDir
     - 目录和文件一样，不能重命名和删除，可以复制，复制的新目录不具备 i 属性；
     - 不能在目录里创建文件 touch test.txt
     - 不能操作目录里文件，如： 重命名，删除
     - 允许操作目录里文件的内容，如：覆盖，编辑，清空等

2. 演示 `目录` 只追加属性（a）

    `chattr +a testDir`

    ![202211111735811](https://gitee.com/librarookie/picgo/raw/master/img/202211111735811.png "202211111735811")

    由上图可知，只读属性 `a` 的目录权限如下：

     - 允许进入目录 cd demoDir
     - 目录和文件一样，不能重命名和删除，可以复制，复制的新目录不具备 a 属性；
     - 允许在目录里创建文件 touch test.txt
     - 不能操作目录里文件，如： 重命名，删除
     - 允许操作目录里文件的内容，如：覆盖，编辑，清空等

</br>

## Linux 小知识

在 linux 终端下

- `!!` : 表示上一个命令
- `Esc+.` : 表示上一个命令中的最后一部分
- `cd -` : 表示切换到上一个路径下
- `cd` = `cd ~` : 表示切换到当前用户家目录下
- 在vim的命令模式下，按 `:wq` 准备保存退出时，提示没有权限对该文件进行修改，可以按 `:w !sudo tee %` 来通过 root 权限保存文件了。这样就不用不保存强退，再加上 sudo 重新编辑了。
- sudo切换到root模式下有以下几种方式：
  1. sudo -s
  2. sudo su [-] [root] （`-` 表示切换到用户环境）
  3. sudo -u root su

</br>
</br>

Via

- <http://c.biancheng.net/view/3120.html>
- <https://www.cnblogs.com/kevingrace/p/5823003.html>
- <https://www.cnblogs.com/sparkdev/p/9651622.html>
