# 子网掩码、前缀长度、IP地址数的换算

</br>
</br>

## 子网掩码

> 子网掩码只有一个功能，就是将IP地址划分为网络地址和主机地址两部分。 如同现实生活中的通讯地址，可以看作省市部分和具体门牌号部分。相同的IP地址，但掩码不一样，则指向的网络部分和主机部分不一样。子网掩码用来判断任意两台计算机的IP地址是否在同一个子网中的根据。如果相同，说明两台计算机在同一个子网中，可以直接通讯；

1. 按照TCP/IP协议规定，IP地址用二进制来表示，每个IP地址长32bit，比特换算成字节，就是4个字节；
2. 子网掩码的长度也是32位，左边是网络位，用二进制数字“1”表示；右边是主机位，用二进制数字“0”表示；
3. 子网掩码常用两种表示形式，一种是 `点分十进制表示法`，如： 255.255.255.0；另一种是用 `前缀长度` 表示，如： 24；
4. 子网掩码不能单独存在，它必须结合IP地址一起使用；
5. 子网掩码只有一个作用，就是将某个IP地址划分成网络地址和主机地址两部分；

</br>

## 子网掩码计算

子网掩码和前缀长度的换算:

- case 1

    > 255.255.255.0 --> 11111111 11111111 11111111 00000000

    ```md
    网络号： 24
    主机号： 8
    ip个数： 256
    ```

    子网掩码“255.255.255.0”的前缀长度为： 24；
    后面一个数字可以在0~255范围内任意变化，因此可以提供256个IP地址。但是实际可用的IP地址数量是256-2，即254个，因为主机号不能全是“0”或全是“1”。

- case 2

    > 255.255.0.0 --> 11111111 11111111 00000000 00000000

    ```md
    网络号： 16
    主机号： 16
    ip个数： 256² = 65536
    ```

    子网掩码“255.255.0.0”的前缀长度为： 16；
    后面两个数字可以在0~255范围内任意变化，可以提供 256² 个IP地址。但是实际可用的IP地址数量是256²-2，即65534个。

- case 3

    > 255.255.252.0 --> 11111111 11111111 11111100 00000000

    ```md
    网络号： 22
    主机号： 10
    ip个数： 256 * 2 = 512
    ```

    子网掩码“255.255.252.0”的前缀长度为： 22；
    可以提供 512 个IP地址。但是实际可用的IP地址数量是512 -2，即510个。

...

[十进制和二进制的相互转换传送](https://www.cnblogs.com/librarookie/p/14778002.html "二进制、八进制、十进制和十六进制的相互转化（图解）")

</br>

不想计算的小伙伴可以参考下表

## 子网掩码与ip个数对照表

| 子网掩码 | 网络号/位 | IP数 |
| ---- | :--: | :--: |
| 255.255.255.255 | 32 |  1  |
| 255.255.255.254 | 31 |  2  |
| 255.255.255.252 | 30 |  4  |
| 255.255.255.248 | 29 |  8  |
| 255.255.255.240 | 28 |  16  |
| 255.255.255.224 | 27 |  32  |
| 255.255.255.192 | 26 |  64  |
| 255.255.255.128 | 25 |  128  |
| 255.255.255.0   | 24 |  256  |
| 255.255.254.0   | 23 |  512  |
| 255.255.252.0   | 22 |  1024  |
| 255.255.248.0   | 21 |  2048  |
| 255.255.240.0   | 20 |  4096  |
| 255.255.224.0   | 19 |  8192  |
| 255.255.192.0   | 18 | 16384  |
| 255.255.128.0   | 17 | 32768  |
| 255.255.0.0     | 16 | 65536  |
| 255.254.0.0     | 15 | 131072 |
| 255.252.0.0     | 14 | 262144 |
| 255.248.0.0     | 13 | 524288 |
| 255.240.0.0     | 12 | 1048576 |
| 255.224.0.0     | 11 | 2097152 |
| 255.192.0.0     | 10 | 4194304 |
| 255.128.0.0     | 9  | 8388608 |
| 255.0.0.0       | 8  | 16777216 |
| 254.0.0.0       | 7  | 33554432 |
| 252.0.0.0       | 6  | 67108864 |
| 248.0.0.0       | 5  | 134217728 |
| 240.0.0.0       | 4  | 268435456 |
| 224.0.0.0       | 3  | 536870912 |
| 192.0.0.0       | 2  | 1073741824 |
| 128.0.0.0       | 1  | 2147483648 |
| 0.0.0.0         | 0  | 4294967296 |

</br>
</br>
