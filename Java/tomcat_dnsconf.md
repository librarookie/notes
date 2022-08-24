# Tomcat配置域名访问

</br>
</br>

## 前言

> 互联网通过IP定位浏览器建立连接，但是我们不易区别IP，为了方便用户辨识IP所代表的意义，操作系统会将IP和域名进行转换，下面介绍Tomcat服务配置域名访问。

</br>

## Tomcat配置

下列配置均是修改Tomcat的配置文件server.xml文件， 文件地址为： $TOMCAT_HOME/conf/server.xml;

### 缺省端口

> 配置访问接口缺省: web服务正常访问是 <http://ip:port/project> 所以我们需要将port缺省处理，本次演示HTTP的配置。

修改server.xml问阿金，将下面 `port` 改为 `80` ，修改后内容如下：

```xml
<Connector port="80" protocol="HTTP/1.1"
            connectionTimeout="20000"
            redirectPort="8443" />
```

tips：
    - HTTP 的缺省接口: 80，即 <http://ip/project> 和 <http://ip:80/project> 等效
    - HTTPS 的缺省接口: 443，即 即 <https://ip/project> 和 <https://ip:443/project> 等效
    - 修改端口时，应注意端口是否被占用

### 缺省项目名

> 配置访问地址项目名缺省: 上一步已缺省端口，此步处理项目名： 处理后的访问地址为：  <http://ip>， 嗯，协议名HTTP浏览器会自己补上，所以此步骤后的访问地址可以是 <ip>

修改server.xml文件，在 </Host> 标签中添加 </Context> ，添加内容如下：

```xml
<Context path="" docBase="project" reloadable="false" />
```

常用参数：

- path: 匹配访问该Web应用的上下文路径，与请求的url的开头匹配; 如果path属性为””，那么这个Context是虚拟主机的默认Web应用；当请求的uri与所有的path都不匹配时，使用该默认Web应用来处理。
- docBase: 指定该Web应用使用的WAR包路径，或应用目录。
- reloadable: 属性指示tomcat是否在运行时监控在WEB-INF/classes和WEB-INF/lib目录下class文件的改动。如果值为true，那么当class文件改动时，会触发Web应用的重新加载。在开发环境中设置为true便于调试；但在生产环境中设置为true会给服务器带来性能压力，因此reloadable参数的默认值为false。（不建议在生产环境上使用true）

### 域名配置

#### 多域名配置

</br>

TODO

</br>

## 测试

浏览器访问: <http://www.letest.ipq.co>

</br>
</br>

域名申请参考: <https://www.zhujiyouxuan.com/399.html>
server.xml文件: <https://www.cnblogs.com/kismetv/p/7228274.html>
