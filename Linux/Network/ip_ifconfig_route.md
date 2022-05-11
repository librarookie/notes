# ip、ifconfig 和 route命令

</br>
</br>

> linux的ip命令和ifconfig类似，但前者功能更强大，并旨在取代后者。使用ip命令，只需一个命令，你就能很轻松地执行一些网络管理任务。ifconfig是net-tools中已被废弃使用的一个命令，许多年前就已经没有维护了。iproute2套件里提供了许多增强功能的命令，ip命令即是其中之一。

</br>

## 常用网络配置

| 功能 | ifconfig 命令 | ip 命令 | route 命令 |
| :--: | :--- | :--- | :--- |
| 查看网络 | `ifconfig [-a] [<interface>]` | `ip addr [show <interface>]` | ---- |
| 添加网络 | `ifconfig <interface> add <address>[/<prefixlen>] [up\|down]` </br>  `ifconfig <interface> <address> netmask <mask> [up\|down]` | `ip addr add <address>[/<prefixlen>] dev <interface>` | ---- |
| 删除网络 | `ifconfig <interface> del <address>[/<prefixlen>]` | `ip addr del <address>[/<prefixlen>] dev <interface>` | ---- |
| 启动 \|关闭 | `ifconfig <interface> up\|down` | `ip link set <interface> up\|down` | ---- |
| 查看路由 | ---- | `ip route [show <interface>/<prefixlen>]` | `route [-n]` |
| 添加路由 | ---- | `ip route add <address>[/<prefixlen>] via <gateway> dev <interface>` | `route add [-net\|-host] <address> [netmask <mask>] [gw default-ip] [dev <interface>]` |
| 删除路由 | ---- | `ip route del <address>[/<prefixlen>]` | `route del [-net\|-host] <address> [netmask <mask>] [gw default-ip] [dev <interface>]` |
| 配置默认路由 | ---- | `ip route add default via <gateway>` | `route [add\|del] default [gw nexthop]` |
| 配置MAC地址 | `ifconfig <interface> hw ether <mac-address>` | `ip link set dev <interface> address <mac-address>` | ---- |

Tips:

- 使用ip route命令来设定路由时，其网段必须严格匹配。如：ip route add 3.3.3.3/24 via 1.1.1.1这样配置就是不正确的，必须将3.3.3.3/24改为3.3.3.0/24才是正确的。
- 使用ip route设定路由时，其下一跳使用via关键字来指定。使用route命令设定ip时，其下一跳使用gw关键字来指定。
- 使用ip route设定网段或主机路由时，直接在该网段后面加上掩码即可。如：10.1.1.0/24；而使用route命令设定主机路由时，需要使用-host关键字来指定，且后面不需要加掩码，指定网段路由时，需要使用-net关键字来指定，并且还需要netmask关键字来指定该路由的掩码。
- route –n:显示路由表，且以ip或port的形式显示而不是使用主机名来显示;其中U表示路由是启动的,G表示是默认路由;

</br>

## 栗子

### ipv4 网络配置

1. IP 命令

    - ip addr show wlan0
    - ip addr add 192.168.0.193/24 dev wlan0
    - ip addr del 192.168.0.193/24 dev wlan0
    - ip route show
    - ip route add 4.4.4.0/24
    - ip route add default via 192.168.0.196

2. ifconfig 命令

    - ifconfig eth0 192.168.0.120/24 up
    - ifconfig 192.168.0.110 netmask 255.255.255.0 up

3. route 命令

    - route del -net 6.6.6.0 netmask 255.255.255.0
    - route add -host 6.6.6.6 gw 3.3.3.3 dev eth1

### ipv6 网络配置

1. 添加IPV6地址
   - ip -6 addr add <ipv6address\>/<prefixlength\> dev <interface\>
     - ip -6 addr add 2001:0db8:0:f101::1/64 dev eth0
   - ifconfig <interface\> inet6 add <ipv6address\>/<prefixlength\>
     - ifconfig eth0 inet6 add 2001:0db8:0:f101::1/64

2. 添加默认路由
   - ip -6 route add <ipv6network\>/<prefixlength\> via <ipv6address\>
     - ip -6 route add default via 2001:0db8:0:f101::1
   - route -A inet6 add <ipv6network\>/<prefixlength\> gw <gateway\>
     - route -A inet6 add default gw 2001:0db8:0:f101::1

3. 查看路由
   - ip -6 route show
   - route -A 'inet6'
   - route print （windows查看路由表）

4. 查看邻居缓存
   - ip -6 neighbor show
   - netsh interface ipv6 show neighbors （windows查看邻居缓存）

</br>
</br>

Reference

- <https://www.cnblogs.com/fatt/p/8038749.html>
- <https://linux.cn/article-3144-1.html>
