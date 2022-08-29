# netfilter/iptables 介绍

</br>
</br>

## 概念

### netfilter 和 iptables

- netfilter 指整个项目，在这个项目里面，netfilter特指内核中的 netfilter框架，`iptables是指用户空间的配置工具`。官网地址: <https://www.netfilter.org/>
- netfilter 项目支持数据包过滤、网络地址 [和端口] 转换 (NA[P]T)、数据包日志记录、用户空间数据包队列和其他数据包处理。是 Linux 防火墙系统的重要组成部分，主要功能是实现对 "网络数据包" 进出设备及转发的控制。当数据包需要进入设备、从设备中流出或者由该设备转发、路由时，都可以使用 iptables 进行控制。
- netfilter 钩子是 Linux 内核中的一个框架，它允许内核模块在 Linux 网络堆栈的不同位置注册回调函数。然后，为遍历 Linux 网络堆栈中相应挂钩的每个数据包回调已注册的回调函数。

### iptables简介

iptables 是集成在 Linux 内核中的包过滤防火墙系统。使用 iptables 可以添加、删除具体的过滤规则，iptables 默认维护着 4 个表和 5 个链，所有的防火墙策略规则都被分别写入这些表与链中。

“四表”是指 iptables 的功能，默认的 iptable s规则表有 filter 表（过滤规则表）、nat 表（地址转换规则表）、mangle（修改数据标记位规则表）、raw（跟踪数据表规则表）：

filter 表：控制数据包是否允许进出及转发，可以控制的链路有 INPUT、FORWARD 和 OUTPUT。
nat 表：控制数据包中地址转换，可以控制的链路有 PREROUTING、INPUT、OUTPUT 和 POSTROUTING。
mangle：修改数据包中的原数据，可以控制的链路有 PREROUTING、INPUT、OUTPUT、FORWARD 和 POSTROUTING。
raw：控制 nat 表中连接追踪机制的启用状况，可以控制的链路有 PREROUTING、OUTPUT。
“五链”是指内核中控制网络的 NetFilter 定义的 5 个规则链。每个规则表中包含多个数据链：INPUT（入站数据过滤）、OUTPUT（出站数据过滤）、FORWARD（转发数据过滤）、PREROUTING（路由前过滤）和POSTROUTING（路由后过滤），防火墙规则需要写入到这些具体的数据链中。

## iptables语法

## 栗子

TODO iptables栗子

</br>
</br>

TAG Unreleased
