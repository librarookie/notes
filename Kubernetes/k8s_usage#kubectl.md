# Kubernetes（k8s）常用命令介绍

</br>
</br>

## 一、节点维护

### 1.1 禁用 /恢复节点（cordon /uncordon）

```sh
#1. 禁用节点（cordon）：节点会被标记为 "Ready,SchedulingDisabled"，表明节点不可调度。
kubectl cordon <node-name>

#2. 恢复节点（uncordon）：节点状态会被更新为 "Ready"，表明节点已经准备好接受新的 Pod 调度。
kubectl uncordon <node-name>
```

### 1.2 排空并删除节点（drain,delete）

> 优雅地将节点从集群中移除，常用于在计划的维护或节点重启前

```sh
#1. 排空节点（drain）：节点会被标记为 "Ready,SchedulingDisabled"，Kubelet 会停止所有非守护进程 Pod，并且 Pod 会被迁移到其他健康的节点上，新的 Pod 不会再调度到该节点。
kubectl drain <node-name> --delete-emptydir-data --ignore-daemonsets --force

#2. 删除节点（delete）：将该节点从 k8s 集群中删除。
kubectl delete <node-name>
```

Note:

- --delete-local-data：删除节点上所有绑定到该节点的本地数据，这可能包括由 StatefulSets 管理的持久化数据（包括挂载的卷）。
- --delete-emptydir-data 清空 Pod 内部使用的临时存储数据，这些数据通常不需要持久化。
- --ignore-daemonsets：忽略守护进程 Pod（DaemonSet 控制的 Pod），因为这些 Pod 通常需要在每个节点上运行。

</br>

## 二、配置文件 Yaml

### 2.1 Yaml 文件介绍

```sh
kubectl explain <type>.<fieldName>[.<fieldName>]
#如：
kubectl explain pods.spec.containers
kubectl explain deployments.spec.template.spec.containers
```

### 2.2 Yaml 文件模板

- 在线编辑或查看资源信息

`kubectl edit deployment/mydeployment -o yaml --save-config`

- 生成 Yaml 文件模板

```sh
#1. 直接生成 Yaml 文件
kubectl create deploy dep-nginx --image=nginx:latest --dry-run=client -o yaml > dep-nginx.yaml

#2. 将现有的资源生成模板并导出
kubectl get deploy dep-nginx -o yaml |sed '/status/q' > dep-nginx.yaml
kubectl get svc svc-nginx -o yaml |sed '/status/q' > svc-nginx.yaml

#3. 打根据需求编辑并更新 Yaml 文件配置
```

</br>
</br>

Via

- <https://znunwm.top/archives/k8s-xiang-xi-jiao-cheng>
- <https://znunwm.top/archives/121212>
- <http://docs.kubernetes.org.cn/683.html>
