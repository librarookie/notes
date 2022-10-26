# Keytool 配置Tomcat的 HTTPS双向认证

</br>
</br>

## 创建证书

> 创建秘钥库(keystore),秘钥库是存储一个或多个密钥条目的文件，每个密钥条目应该以一个别名标识，它包含密钥和证书相关信息。

1. 生成服务器证书

    > keytool -genkey -alias server -keyalg RSA -keypass 123456 -keystore ~/ssl/tomcat.jks [-storetype JKS] -storepass 123456 -validity 3650  -dname "CN=localhost" -ext SAN=ip:127.0.0.1

2. 生成客户端证书，以便让服务器来验证它。为了能将证书顺利导入至IE和Firefox，证书格式应该是PKCS12（客户端的CN可以是任意值）

    > keytool -genkey -alias client -keyalg RSA -keypass 123456 -keystore ~/ssl/client.p12 -storetype PKCS12 -storepass 123456 -validity 3650 -dname "CN=client"

3. 参数介绍

    ```md
    -genkey     产生密钥对（genkeypair 简写）
    -alias      证书别名；和keystore关联的唯一别名，这个alias通常不区分大小写（默认`mykey`）
    -keyalg     指定加密算法，RSA：非对称加密（默认`DSA`）
    -sigalg     指定签名算法，可选;
    -keysize    指定密钥长度，可选;
    -keypass    指定别名条目口令（私钥的密码）
    -storetype  生成证书类型，可用的证书库类型为：JKS、PKCS12等。（jdk9以前，默认为JKS。自jdk9开始，默认为PKCS12）
    -keystore   指定产生的密钥库的位置；
    -storepass  指定密钥库的存取口令，推荐与keypass一致
    -validity   证书有效期天数；（默认为 90天）
    -dname      表明了密钥的发行者身份（Distinguished Names）生成证书时，其中 CN 要和服务器的 `域名` 或 `IP` 相同，本地测试则使用localhost，其他的可以不填
    -ext        X.509 扩展
    ```

Tips：

- 执行前需要手动准备文件夹 `~/ssl`。或者将文中所有 `~/ssl` 替换为已有的目录;
- 此处需要注意：MD5和SHA1的签名算法已经不安全；
- 如果Tomcat所在服务器的域名不是 “localhost” 时，浏览器会弹出警告窗口，提示用户证书与所在域不匹配。
  - 服务器证书 dname的 CN应改为对应的域名，如 “www.github.com”；在本地做开发测试时，CN应填入 “localhost”；
  - 客户端证书 dname的 CN可以是任意值，且不用使用 -ext扩展。

</br>

## 导出证书信息

> 此证书文件不包含私钥；分为自签名证书和认证证书，下面分别介绍了两中证书的生成方式

- 认证证书与导出的服务器自签名证书作用一致，使用时取其中一种证书即可。两者主要区别为是否经证书机构认证；
- 使用自签名证书则无需生成证书签名请求(CSR)，使用认证证书则无需导出服务器自签名证书；
- 大部分认证证书都是收费的；

</br>

### 导出自签名证书

> 自签名证书没有经过证书认证机构进行认证，但并不影响使用，我们可以使用相应的命令对证书进行导出;

1. 导出服务器证书

    此处为服务器的自签名证书导出， 如果需要使用认证证书，则生成证书签名请求
    > keytool -export -alias server -keystore ~/ssl/tomcat.jks -storepass 123456 -file ~/ssl/server.cer

2. 导出客户端证书

    双向认证： 服务端信任客户端，由于不能直接将PKCS12格式的证书库导入，所以必须先把客户端证书导出为一个单独的CER文件
    > keytool -export -alias client -keystore ~/ssl/client.p12 -storepass 123456 -file ~/ssl/client.cer -rfc

3. 参数介绍

    ```md
    -export     执行证书导出操作（exportcert 简写）
    -alias      密钥库中的证书条目别名（jks里可以存储多对公私钥文件，通过别名指定导出的公钥证书）
    -keystore   指定密钥库文件
    -storepass  密钥库口令
    -file       导出文件的输出路径
    -rfc        使用Base64格式输出（输出pem编码格式的证书，文本格式），不适用则导出的证书为DER编码格式
    ```

</br>

### 获取认证证书（生成证书签名请求）

> 如果想得到证书认证机构的认证，则不使用上述的自签名证书，需要使用步骤导出数字证书并签发申请（Cerificate Signing Request），经证书认证机构认证并颁发后，再将认证后的证书导入本地密钥库与信任库。

1. 生成证书签名请求(CSR)

    > keytool -certreq -alias server -keystore ~/ssl/tomcat.jks -storepass 123456 -file ~/ssl/certreq.csr

2. 查看生成的CSR证书请求

    > keytool -printcertreq -file certreq.csr

3. 参数介绍

    ```md
    -certreq    执行证书签发申请导出操作
    -alias      密钥库中的证书条目别名
    -keystore   密钥库文件名称
    -storepass  密钥库口令
    -file       输出的csr文件路径
    ```

</br>

## 导入证书库

> 双向认证： 将各自的公钥证书分别导入对方的信任库，使客户端和服务端相互信任。

1. 安装服务器证书（将服务器公钥证书导入客户端）

   安装公钥证书

    - 将服务器公钥证书 `server.cer` 发往客户端机器
      - --> 双击该证书进入“证书信息”页
        - --> 点击【安装证书】进入“证书导入向导”首页
          - --> 点击【下一步】
            - --> 选中【将所有的证书都放入下列存储】，然后单击【浏览】
              - --> 选择【受信任的根证书颁发机构】并点击【确定】
                - --> 点击【下一步】
                  - --> 点击【完成】。然后弹出提示【导入完成】。

    安装客户端证书

    - 将客户端证书 `client.p12` 发往客户端机器
      - --> 双击该证书进入“证书导入向导”首页
        - --> 点击【下一步】
          - --> 点击【下一步】
            - --> 输入证书密码（keystore密码）并点击【下一步】
              - --> 点击【下一步】（这里也可以自己指定证书储存）
                - --> 点击【完成】。然后弹出提示【导入完成】。

2. 证书导入信任库（将客户端公钥证书导入信任库）

    双向认证: 服务端信任客户端：
    > keytool -import -alias clientCert -keystore ~/ssl/truststore.jks -storepass 123456 -file ~/ssl/client.cer

    此步骤会生成信任证书 truststore.jks文件， 文件存放需要信任的公钥证书，如客户端证书（也可以将 keystore值改为服务器密钥库，即tomcat.jks。此时的tomcat.jks 就同时是服务的密钥库和信任库）

3. 参数介绍

    ```md
    -import     执行证书导入操作（importcert 简写）
    -alias      指定导入密钥库中的证书别名（指定的条目别名不能与密钥库中已存在的条目别名重复（导入签发证书除外））
    -trustcacerts    将证书导入信任库（信任来自 cacerts 的证书）
    -keystore   密钥库名称
    -storepass  密钥库口令
    -file       输入文件名
    ```

</br>

## 查看证书

1. 查看证书信息（cer | crt）

    > keytool -printcert -file ~/ssl/client.cer [-v|-rfc]

2. 查看密钥库中的证书条目

    > keytool -list -keystore ~/ssl/tomcat.jks -storepass 123456 -v

3. 查看密钥库中的证书条目（base64的内容，即PEM编码）

    > keytool -list -keystore ~/ssl/tomcat.jks -storepass 123456 -rfc

4. 查看生成的CSR证书请求

    > keytool -printcertreq -file ~/ssl/certreq.csr

5. 参数介绍

    ```md
    -alias      密钥库中的证书条目别名；
    -keystore   指定密钥库文件；
    -storepass  密钥库口令；
    -printcert  执行证书打印命令；
    -list       缺省情况下，命令打印证书的 MD5 指纹。
        而如果指定了 -v 选项，将以可读格式打印证书，
        如果指定了 -rfc 选项，将以可打印的编码格式输出证书。
    ```

</br>

## Tomcat配置

### 配置开放 HTTPS端口并使用证书

- 修改 server.xml 文件

    打开Tomcat_HOME/conf/server.xml，找到如下原注释内容，并修改如下：

    ```xml
    <Connector port="8443" protocol="HTTP/1.1" SSLEnabled="true"
        maxThreads="150" scheme="https" secure="true"
        clientAuth="true" sslProtocol="TLS"
        keystoreFile="~/ssl/tomcat.jks" keystorePass="123456"
        truststoreFile="~/ssl/truststore.jks" truststorePass="123456"
    />
    ```

- 参数介绍

    ```md
    - 其中 clientAuth 指定是否需要验证客户端证书
      - false： 表示单向SSL验证，即服务端认证;
      - true： 表示强制双向SSL验证，必须验证客户端证书;
      - want： 表示可以验证客户端证书，但如果客户端没有有效证书，也不强制验证。
    - 如果设置了 clientAuth="true"，则需要强制验证客户端证书。可通过双击 "p12" 文件将证书导入至浏览器；
    - 浏览器的HTTP缺省端口为 "80" ， HTTPS缺省端口为 "443"；
    - keystoreFile /keystorePass ： 服务器证书文件和密码；
    - truststoreFile /truststorePass ： 信任证书文件和密码；用来验证客户端的。
    ```

</br>

### 配置HTTP自动跳转到HTTPS（按需选配，也可以选择停用HTTP端口）

- 修改 server.xml 文件

    打开Tomcat_HOME/conf/web.xml，在 <welcome-file-list\> 与 <web-app\> 加入如下代码：

    ```xml
    <login-config> 
        <!-- Authorization setting for SSL --> 
        <auth-method>CLIENT-CERT</auth-method> 
        <realm-name>Client Cert Users-only Area</realm-name> 
    </login-config> 
    <security-constraint> 
        <!-- Authorization setting for SSL --> 
        <web-resource-collection> 
            <web-resource-name >SSL</web-resource-name> 
            <url-pattern>/*</url-pattern> 
        </web-resource-collection> 
        <user-data-constraint> 
            <transport-guarantee>CONFIDENTIAL</transport-guarantee> 
        </user-data-constraint> 
    </security-constraint> 
    ```

</br>

## 测试

1. 启动 Tomcat项目
2. 访问 项目地址，本地配置如： <https://localhost:8443/>
3. 如果浏览器地址栏提示“不安全” -- 客户端未安装服务器公钥证书，或者未清理浏览器缓存，可重启浏览器再试

</br>

## 常见问题

1. 浏览器访问时的提示与可能原因：

    - 此服务器无法证实它是“192.168..” - 您计算机的操作系统不信任其安全证书 。。。

        -- 客户端未导入服务器证书

    - 此服务器无法证实它就是“192.168..” - 它的安全证书没有指定主题备用名称 。。。

        -- 生成服务器证书库未使用 -ext参数

    - “192.168..”不接受您的登录证书，或者您可能没有提供登录证书。。。

        -- Tomcat配置开了双向认证，且未指定信任证书库（truststore）

2. Tomcat 启动日志报错： `alias name tomat does not  identify a key entry`

    -- 在 tomcat/conf/server.xml 的 </Connect> 标签中添加参数 `keyAlias='证书名称'`

</br>

## 扩展

- Keytool 工具的介绍与使用: <https://www.cnblogs.com/librarookie/p/16364384.html>
- Keytool 配置Tomcat的 HTTPS单向认证: <https://www.cnblogs.com/librarookie/p/16806817.html>

</br>
</br>
