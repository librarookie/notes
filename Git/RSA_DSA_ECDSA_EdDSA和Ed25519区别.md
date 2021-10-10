# RSA，DSA，ECDSA，EdDSA和Ed25519的区别

> 用过ssh的朋友都知道，ssh key的类型有很多种，比如dsa、rsa、 ecdsa、ed25519等，那这么多种类型，我们要如何选择呢？

## 说明

1. RSA，DSA，ECDSA，EdDSA和Ed25519都用于数字签名，但只有RSA也可以用于加密。

    * RSA（Rivest–Shamir–Adleman）是最早的公钥密码系统之一，被广泛用于安全数据传输。它的安全性取决于整数分解，因此永远不需要安全的RNG（随机数生成器）。与DSA相比，RSA的签名验证速度更快，但生成速度较慢。

    * DSA（数字签名算法）是用于数字签名的联邦信息处理标准。它的安全性取决于离散的对数问题。与RSA相比，DSA的签名生成速度更快，但验证速度较慢。如果使用错误的数字生成器，可能会破坏安全性。

    * ECDSA（椭圆曲线数字签名算法）是DSA（数字签名算法）的椭圆曲线实现。椭圆曲线密码术能够以较小的密钥提供与RSA相对相同的安全级别。它还具有DSA对不良RNG敏感的缺点。

    * EdDSA（爱德华兹曲线数字签名算法）是一种使用基于扭曲爱德华兹曲线的Schnorr签名变体的数字签名方案。签名创建在EdDSA中是确定性的，其安全性是基于某些离散对数问题的难处理性，因此它比DSA和ECDSA更安全，后者要求每个签名都具有高质量的随机性。

    * Ed25519是EdDSA签名方案，但使用SHA-512 / 256和Curve25519；它是一条安全的椭圆形曲线，比DSA，ECDSA和EdDSA 提供更好的安全性，并且具有更好的性能（人为注意）。

2. 其他说明
    * RSA密钥使用最广泛，因此似乎得到最好的支持。

    * ECDSA（在OpenSSH v5.7中引入）在计算上比DSA轻，但是除非您有一台处理能力非常低的机器，否则差异并不明显。

    * 从OpenSSH 7.0开始，默认情况下SSH不再支持DSA密钥（ssh-dss）。根据SSH标准（RFC 4251及更高版本），DSA密钥可用于任何地方。

    * Ed25519在openSSH 6.5中引入。

    * 相关文章

        ```python
        OpenSSH supports several signing algorithms (for authentication keys) which can be divided in two groups depending on the mathematical properties they exploit:

        DSA and RSA, which rely on the practical difficulty of factoring the product of two large prime numbers,
        ECDSA and Ed25519, which rely on the elliptic curve discrete logarithm problem. (example)
        Elliptic curve cryptography (ECC) algorithms are a more recent addition to public key cryptosystems. One of their main advantages is their ability to provide the same level of security with smaller keys, which makes for less computationally intensive operations (i.e. faster key creation, encryption and decryption) and reduced storage and transmission requirements.

        OpenSSH 7.0 deprecated and disabled support for DSA keys due to discovered vulnerabilities, therefore the choice of cryptosystem lies within RSA or one of the two types of ECC.

        #RSA keys will give you the greatest portability, while #Ed25519 will give you the best security but requires recent versions of client & server[2]. #ECDSA is likely more compatible than Ed25519 (though still less than RSA), but suspicions exist about its security (see below).
        ```

## 结论

1. ssh key的类型有四种，分别是dsa、rsa、 ecdsa、ed25519。

2. 根据数学特性，这四种类型又可以分为两大类，dsa/rsa是一类，ecdsa/ed25519是一类，后者算法更先进。

3. dsa因为安全问题，已不再使用了。

4. ecdsa因为政治原因和技术原因，也不推荐使用。

5. rsa是目前兼容性最好的，应用最广泛的key类型，在用ssh-keygen工具生成key的时候，默认使用的也是这种类型。不过在生成key时，如果指定的key size太小的话，也是有安全问题的，推荐key size是3072或更大。

6. ed25519是目前最安全、加解密速度最快的key类型，由于其数学特性，它的key的长度比rsa小很多，优先推荐使用。它目前唯一的问题就是兼容性，即在旧版本的ssh工具集中可能无法使用。不过据我目前测试，还没有发现此类问题。

## 总结

```python
    优先选择ed25519，否则选择rsa 
```

</br></br>

Reference

* <https://qastack.cn/ubuntu/363207/what-is-the-difference-between-the-rsa-dsa-and-ecdsa-keys-that-ssh-uses>
* <https://segmentfault.com/a/1190000020166520>
