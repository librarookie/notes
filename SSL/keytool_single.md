# Keytool 配置Tomcat的 HTTPS单向认证

</br>
</br>

## 创建证书

- 生成服务器证书

  > keytool -genkey -alias tomcat -keyalg RSA -keypass 123456 -keystore ~/ssl/tomcat.jks [-storetype JKS |PKCS12] -storepass 123456 -validity 3650  -dname "CN=localhost" -ext SAN=ip:127.0.0.1

- 参数介绍

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

Tips: 执行前需要手动准备文件夹 `~/ssl`。或者将文中所有 `~/ssl` 替换为已有的目录

</br>

## 导出公钥证书

> 此处为服务器的自签名证书导出， 如果需要使用认证证书，则生成证书签名请求

- 导出服务器证书

  > keytool -export -alias tomcat -keystore ~/ssl/tomcat.jks -storepass 123456 -file ~/ssl/server.cer

- 参数介绍

  ```md
  -export     执行证书导出操作（exportcert 简写）
  -alias      密钥库中的证书条目别名（jks里可以存储多对公私钥文件，通过别名指定导出的公钥证书）
  -keystore   指定密钥库文件（jdk8 环境导出PKCS12格式时，需要此参数指定格式类型，同理jdk9导出JKS）
  -storepass  密钥库口令
  -file       导出文件的输出路径
  -rfc        使用Base64格式输出（输出pem编码格式的证书，文本格式），不适用则导出的证书为DER编码格式
  ```

</br>

## 安装证书

> 先上传公钥证书到客户端机器上，再双击安装公钥证书，步骤如下：

- 将服务器公钥证书（cer | crt等格式文件）发往客户端机器
  - --> 双击该证书进入“证书信息”页
    - --> 点击【安装证书】进入“证书导入向导”首页
      - --> 点击【下一步】
        - --> 选中【将所有的证书都放入下列存储】，然后单击【浏览】
          - --> 选择【受信任的根证书颁发机构】并点击【确定】
            - --> 点击【下一步】
              - --> 点击【完成】。然后弹出提示【导入完成】。

</br>

## Tomcat配置

### 配置开放 HTTPS端口并使用证书

- 修改 server.xml 文件

  打开Tomcat_HOME/conf/server.xml，找到如下原注释内容，并修改如下：

  ```xml
  <Connector port="8443" protocol="HTTP/1.1" SSLEnabled="true"
    maxThreads="150" scheme="https" secure="true"
    clientAuth="false" sslProtocol="TLS"
    keystoreFile="~/ssl/tomcat.jks" keystorePass="123456"
  />
  ```

- 参数介绍

  ```md
  clientAuth： 指定是否需要验证客户端证书（false单向认证，true双向认证）
  keyAlias： 证书名称（默认tomcat）
  keystoreFile： 服务器证书文件路径
  keystorePass： 服务器证书密码
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

## 测试与问题

1. 启动 Tomcat项目
2. 访问 项目地址，本地配置如： <https://localhost:8443/>
3. 如果浏览器地址栏提示“不安全” -- 客户端未安装服务器公钥证书，或者未清理浏览器缓存，可重启浏览器再试

</br>

## 扩展

- Keytool 工具的介绍与使用: <https://www.cnblogs.com/librarookie/p/16364384.html>
- Keytool 配置Tomcat的 HTTPS双向认证: <https://www.cnblogs.com/librarookie/p/16807218.html>

</br>
</br>
