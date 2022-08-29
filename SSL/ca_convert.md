# CA证书介绍与格式转换

</br>
</br>

## 概念

PKCS 公钥加密标准（Public Key Cryptography Standards, PKCS），此一标准的设计与发布皆由RSA资讯安全公司（英语：RSA Security）所制定，PKCS 目前共发布过 15 个标准。[更多公钥加密标准](https://zh.m.wikipedia.org/zh-hans/%E5%85%AC%E9%92%A5%E5%AF%86%E7%A0%81%E5%AD%A6%E6%A0%87%E5%87%86 "公钥密码学标准")

X.509 是密码学里公钥证书的格式标准。

> X.509是常见通用的证书格式。是ITU-T标准化部门基于他们之前的ASN.1定义的一套证书标准。</br>
> X.509附带了证书吊销列表和用于从最终对证书进行签名的证书签发机构直到最终可信点为止的证书合法性验证算法。</br>
> X.509证书已应用在包括TLS/SSL在内的众多网络协议里，同时它也用在很多非在线应用场景里。

应用场景如电子签名服务。X.509证书里含有公钥、身份信息（比如网络主机名，组织的名称或个体名称等）和签名信息（可以是证书签发机构CA的签名，也可以是自签名）。

1. 常用加密标准：
    - PKCS #7： 密码讯息语法标准（Cryptographic Message Syntax Standard），规范了以公开金钥基础设施（PKI）所产生之签章/密文之格式。其目的一样是为了拓展数位证书的应用。
    - PKCS #10： 证书申请标准（Certification Request Standard），英语：PKCS_10，规范了向证书中心申请证书之CSR（certificate signing request）的格式。
    - PKCS #12： 个人讯息交换标准（Personal Information Exchange Syntax Standard），定义了包含私钥与公钥证书（public key certificate）的文件格式。私钥采密码(password)保护。常见的PFX就履行了PKCS#12。

2. 常用扩展名：
    - JKS格式： .jks .keystore .truststore
    - PKCS#7格式： .p7b .p7c .spc
    - PKCS#12格式： .p12 .pfx
    - `.jks` 或 `.keystore` 文件是Java是存储密钥（公钥、私钥）的容器；
    - `.truststore` 文件是存储自己信任对象公钥的容器；
    - `.pem` ： 隐私增强型电子邮件（Privacy-enhanced Electronic Mail, pem），通常是Base64格式的文本格式；
      - `.pem` 文件可以存放证书或私钥，或者两者都包含。如果只包含私钥，一般用 `.key` 文件代替。
    - `.cer` `.crt` `.der` ： 通常是DER（X.690#DER_encoding）二进制格式的。
      - `.der` 或 `.cer` 文件是二进制格式，只含有证书信息，不包含私钥。
      - `.crt` 文件是二进制格式或文本格式，一般为文本格式，功能与 `.der` 及 `.cer` 证书文件相同。
    - `.pfx` 或 `.p12` 文件是二进制格式，同时包含证书和私钥，且一般有密码保护。
      - `.pfx` – PFX，PKCS#12之前的格式（通常用PKCS#12格式，比如由互联网资讯服务产生的PFX文件）;
      - `.p12` – PKCS#12格式，包含证书的同时可能还包含私钥;
    - `.csr` ： 数字证书签名请求文件（Cerificate Signing Request）
    - `.p7r` ： 是CA对证书请求的回复，只用于导入。
    - `.p7b` ： 以树状展示证书链(certificate chain)，同时也支持单个证书，不含私钥。

Tips： 区别证书的不是后缀名，而是证书文件的格式与内容。

### 术语介绍

1. 密钥对： 在非对称加密技术中，有两种密钥，分为私钥和公钥。
2. 公钥： 公钥用来给数据加密，用公钥加密的数据只能使用私钥解密，公钥是密钥对持有者公布给他人的。
3. 私钥： 用来解密公钥加密的数据，私钥是密钥对所有者持有，不可公布。
4. 摘要： 对需要传输的文本，做一个HASH计算，一般采用SHA1，SHA2来获得。
5. 签名： 使用私钥对需要传输的文本的摘要进行加密，得到的密文即被称为该次传输过程的签名。
6. 签名验证： 数据接收端，拿到传输文本，但是需要确认该文本是否就是发送发出的内容，中途是否曾经被篡改。因此拿自己持有的公钥对签名进行解密（密钥对中的一种密钥加密的数据必定能使用另一种密钥解密。），得到了文本的摘要，然后使用与发送方同样的HASH算法计算摘要值，再与解密得到的摘要做对比，发现二者完全一致，则说明文本没有被篡改过。
7. 密钥分为两种： `对称密钥`与`非对称密钥`
   1. 对称密钥加密： 又称私钥加密或会话密钥加密算法，指的就是加、解密使用的同是一串密钥，所以被称做对称加密。它的最大优势是加/解密速度快，适合于对大数据量进行加密，但密钥管理困难。
   2. 非对称密钥加密： 又称公钥密钥加密。指的是加、解密使用不同的密钥，一把作为公开的公钥，另一把作为私钥保存。公钥机制灵活，但加密和解密速度却比对称密钥加密慢得多。

Tips：

- 密钥指的是私钥或者公钥 —> 密钥 = 私钥/公钥；
- 密钥对指的是公钥加上私钥 —> 密钥对 = 私钥+公钥；
- 非对称加密：
  - 公钥和私钥是成对的，公钥和私钥唯一对应，它们互相解密。
  - 公钥一般用来加密和验证签名，私钥用来签名和解密。
  - 加密（加解密）： 公钥加密，私钥解密；加密的目的是保证信息的保密传输，使只有具备资格的一方才能解密。
  - 认证（加验签）： 私钥数字签名，公钥验证签名；加签的目的是让收到消息的一方确认该消息是由特定方发送的。
- 在实际的应用中，通常将两者结合在一起使用，例如，对称密钥加密系统用于存储大量数据信息，而公开密钥加密系统则用于加密密钥。

原文链接：<https://blog.csdn.net/qq_41586280/article/details/82669840>

### PEM 格式

1. PEM格式是证书颁发机构颁发证书的最常见格式.PEM证书通常具有扩展名，例如.pem，.crt，.cer和.key。
2. 它们是以二进制文件的Base64编码的保存，包含“----- BEGIN CERTIFICATE -----”和“----- END CERTIFICATE -----”语句。
3. 服务器证书，中间证书和私钥都可以放入PEM格式。
4. 相较于PEM的Base64编码格式以文本文件的形式存在，`CERT格式`的文件为PEM的二进制格式，文件扩展名.cert /.cer /.crt。
5. `KEY格式`通常用来存放公钥或者私钥，并非X.509证书，编码可能是PEM也有可能是DER，扩展名为 .key。

Apache和其他类似服务器使用PEM格式证书。几个PEM证书，甚至私钥，可以包含在一个文件中，一个在另一个文件之下，但是大多数平台（例如Apache）希望证书和私钥位于单独的文件中。

### DER 格式

1. DER格式只是证书的二进制形式，不含私钥。
2. 文件扩展名通常是.cer，有时会有.der的文件扩展名。
3. 判断DER .cer文件和PEM .cer文件方法是在文本编辑器中打开它，并查找BEGIN / END语句。
4. 所有类型的证书和私钥都可以用DER格式编码。
5. DER通常与Java平台一起使用。
6. SSL转换器只能将证书转换为DER格式。

### PKCS＃7 / P7B 格式

1. PKCS#7是签名或加密数据的格式标准，官方称之为容器。由于证书是可验真的签名数据，所以可以用SignedData结构表述。
2. PKCS#7或P7B格式通常以Base64 ASCII格式存储，文件扩展名为.p7b或.p7c。
3. P7B证书包含“----- BEGIN PKCS7 -----”和“----- END PKCS7 -----”语句。
4. P7B文件仅包含证书和链证书，而不包含私钥。
5. 多个平台支持P7B文件，包括Microsoft Windows和Java Tomcat。

### PKCS＃12 / PFX 格式

1. PKCS#12 是公钥加密标准，通用格式（rsa公司标准）。规定了可包含所有私钥、公钥和证书。文件格式是加密过的。
2. PKCS#12 或 PFX 格式是其以二进制格式存储，也称为 PFX 文件，在windows中可以直接导入到密钥区。也可用于导入和导出证书和私钥。
3. PKCS#12 由 PFX 进化而来的，用于`交换公共的和私有的对象`的标准格式。
4. 文件通常具有扩展名，例如.pkcs12 .pfx .p12。
5. 密钥库和私钥用相同密码进行保护

### JKS 格式

1. JKS是java用来存储密钥的容器。可以同时容纳n个公钥或私钥，后缀一般是.jks或者.keystore或.truststore等。
2. 在Java 8之前，这些文件的默认格式为JKS(android .keystore 也是jsk格式的证书)。
3. 从Java 9开始，默认的密钥库格式为PKCS12。
4. Android签名keystore文件也是jks格式，且1.8之后要求转换到p12格式。
5. JKS是二进制格式，同时包含证书和私钥，一般有密码保护，只能存储非对称密钥对（私钥 + x509公钥证书）。
6. 当应用程序需要通过SSL / TLS进行通信时，在大多数情况下将使用java keystore和java truststore。
7. 密钥库和私钥用不同的密码进行保护

**JKS和PKCS12之间的最大区别是JKS是Java专用的格式，而PKCS12是存储加密的私钥和证书的标准化且与语言无关的方式。**

</br>

## 格式转换

> OpenSSL是一个非常有用的开源命令行工具包，可用于 X.509 证书，证书签名请求（CSRs）和加密密钥。

### 查看证书

- 查看 PEM证书

    > openssl x509 -text -noout -in CERTIFICATE.pem

- 查看 DER证书

    > openssl x509 -inder der -text -noout -in CERTIFICATE.der

- 查看 CSR证书

    > openssl req -text -noout -in mysite.csr

- 查看 P7B证书

    > openssl pkcs7 -inform der -in CERTIFICATE.p7b  -print_certs -text

- 查看 JKS证书

    > keytool -list -rfc -keystore server.jks -storepass XXXXXX

### 转换证书

#### 转换 PEM证书（.pem /.crt /.cer）

- PEM to DER

    > openssl x509 -outform der -in CERTIFICATE.pem -out CERTIFICATE.der

- PEM to P7B

    > openssl crl2pkcs7 -nocrl -certfile CERTIFICATE.cer -certfile CACert.cer -out CERTIFICATE.p7b

- PEM to PFX

    > openssl pkcs12 -export -out CERTIFICATE.pfx -inkey PRIVATEKEY.key -in CERTIFICATE.cer [-certfile CACert.cer] </br>
    > openssl pkcs12 -export -out server.p12 -inkey server.key -in server.pem

#### 转换 DER证书（.der /.crt /.cer）

- DER to PEM

    > openssl x509 -inform der -in CERTIFICATE.cer -out CERTIFICATE.pem

#### 转换 P7B证书（.p7b /.p7c）

- P7B to PEM

    > openssl pkcs7 -print_certs -in CERTIFICATE.p7b -out CERTIFICATE.cer

- P7B to PFX

    > openssl pkcs7 -print_certs -in CERTIFICATE.p7b -out CERTIFICATE.cer

#### 转换 PFX证书（.pfx /.p12）

- PFX to PEM

    > openssl pkcs12 -in CERTIFICATE.pfx -out CERTIFICATE.cer -nodes konwersja poprze OpenSSL </br>
    > openssl pkcs12 -nocerts -nodes -in cert.p12 -out private.pem </br>
    > openssl pkcs12 -clcerts -nokeys -in cert.p12 -out cert.pem

（PFX to PEM后CERTIFICATE.cer文件包含认证证书和私钥，需要把它们分开存储才能使用。）

#### JKS 和 PKCS＃12 格式互转

- JKS to P12

    > keytool -importkeystore -srcstoretype JKS -deststoretype PKCS12 -srckeystore server.jks -destkeystore server.p12

- P12 to JKS

    > keytool -importkeystore -srcstoretype PKCS12 -deststoretype JKS -srckeystore server.p12 -destkeystore server.jks

### 常用选项

```md
 -inform PEM|DER    输入格式 - DER或PEM（x509默认为PEM）
 -in infile         输入文件（x509默认为stdin）
 -outform PEM|DER   输出格式 - DER或PEM（x509默认为PEM）
 -out outfile       输出文件（x509默认为stdout）
 -keyform PEM|DER|ENGINE 私钥格式 - 默认PEM
 -passin val        私钥密码/口令来源
 -modulus           打印RSA密钥模数
 -pubkey            输出公钥
 -fingerprint       打印证书的指纹
 -alias             输出证书别名
 -noout             没有输出，只有状态
 -nocert            无证书输出
 -trustout          输出一个受信任的证书
 -setalias val      设置证书别名
 -days int          签署的证书到期前的时间 - 默认 30 天
 -signkey val       用参数自行签署证书
 -x509toreq         输出一个认证请求对象
 -req               输入是一个证书请求，签署并输出
 -CA infile         设置CA证书，必须是PEM格式
 -CAkey val         设置 CA 密钥，必须是 PEM 格式；如果不在 CAfile 中
 -text              打印文本形式的证书
 -ext val           打印各种X509V3扩展文件
 -extfile infile    要添加X509V3扩展的文件
 -writerand outfile 将随机数据写到指定文件中
 -extensions val    要使用的配置文件中的部分
 -nameopt val       各种证书名称选项
 -certopt val       各种证书文本选项
 -checkhost val     检查证书是否与主机匹配
 -checkemail val    检查证书是否与电子邮件匹配
 -checkip val       检查证书是否与ipaddr匹配
 -CAform PEM|DER    CA格式--默认PEM
 -CAkeyform PEM|DER|ENGINE      CA密钥格式--默认为PEM

 -export        输出PKCS12文件
 -nodes         不要加密私钥
 -nokeys        不输出私钥
 -keysig        设置 MS 密钥签名类型
 -nocerts       不输出证书
 -clcerts       只输出客户证书
 -cacerts       只输出CA证书
 -info          打印有关PKCS#12结构的信息
 -chain         添加证书链
 -certpbe val   证书PBE算法(默认为RC2-40)
 -inkey val     如果不是infile，则为私钥
 -certfile infile   从文件中加载证书
 -CApath dir    PEM格式的CA的目录
 -CAfile infile     PEM格式的CA的文件
 -no-CAfile     不加载默认的证书文件
 -no-CApath     不从默认的证书目录中加载证书
```

</br>
</br>

Via

- <https://csr.chinassl.net/convert-ssl-commands.html>
- <https://www.jianshu.com/p/87e3753c222b>
- <http://mjpclab.site/linux/openssl-self-signed-certificate>
- <https://anymarvel.github.io/AndroidSummary/book/androidan-quan/Difference_keystores.html>
