# K8S常用资源清单

| 参数名 | 类型 | 字段说明 |
| ---- | ---- | ---- |
| apiVersion | String | K8S API 的版本，可以用 kubectl api-versions 命令查询 |
| kind | String | yaml 文件定义的资源类型和角色 |
| metadata | Object | 元数据对象，下面是它的属性 |
| metadata.name | String | 元数据对象的名字，比如 pod 的名字 |
| metadata.labels | list | 元数据对象的名字，比如 pod 的名字 |
| metadata.namespace | String | 元数据对象的命名空间 |
| spec | Object | 详细定义对象（期望值） |
| spec.containers[] | list | 定义 spec 对象的容器列表 |
| spec.containers[].name | String | 为列表中的某个容器定义名称 |
| spec.containers[].image | String | 为列表中的某个容器定义需要的镜像名称 |
| spec.containers[].imagePullPolicy | String | 定义镜像拉取策略，可选值为 Always（默认）、Never、lfNotPresent。 </br> - Always: 意思是每次都尝试重新拉取镜像 </br> - Never: 表示仅适用本地镜像 </br> - lfNotPresent: 如果本地有镜像就使用本地镜像，没有就拉取在线镜像 |
| spec.containers[].command[] | list | 指定容器启动命令，因为是数组可以指定多个，不指定则使用镜像打包时使用的启动命令 |
| spec.containers[].args[] | list | 指定容器启动命令参数，因为是数组可以指定多个 |
| spec.containers[].workingDir | String | 指定容器的工作目录 |
| spec.containers[].volumeMounts[] | list | 指定容器内部的存储卷配置 |
| spec.containers[].volumeMounts[].name | String | 指定可以被容器挂载的存储卷的名称 |
| spec.containers[].volumeMounts[].mountPath | String | 指定可以被容器挂载的存储卷的路径 |
| spec.containers[].volumeMounts[].readOnly | String | 设置存储卷路径的读写模式，ture 或者 false，默认是读写模式 |
| spec.containers[].ports[] | list | 指定容器需要用到的端口列表 |
| spec.containers[].ports[].name | String | 指定端口的名称 |
| spec.containers[].ports[].containerPort | String | 指定容器需要监听的端口号 |
| spec.containers[].ports[].hostPort | String | 指定容器所在主机需要监听的端口号，默认跟上面 containerPort 相同，注意设置了hostPort 同一台主机无法启动该容器的相同副本（因为主机的端口号不能相同，这样会冲突） |
| spec.containers[].ports[].protocol | String | 指定端口协议，支持 TCP（默认） 和 UDP |
| spec.containers[].env[] | list | 指定容器运行前需设置的环境变量列表 |
| spec.containers[].env[].name | String | 指定环境变量名称 |
| spec.containers[].env[].value | String | 指定环境变量值 |
| spec.containers[].resources | Object | 指定资源限制和资源请求的值（设置容器的资源限制） |
| spec.containers[].resources.limits | Object | 指定设置容器运行时资源的运行上限（容器资源上限） |
| spec.containers[].resources.limits.cpu | String | 指定 CPU 的限制，单位为 Core 数，将用于 docker run -cpu-shares 参数 |
| spec.containers[].resources.limits.memory | String | 指定 mem 内存的限制，单位为MiB、GiB |
| spec.containers[].resources.requests | Object | 指定容器启动和调度时的限制设置（容器资源上限） |
| spec.containers[].resources.requests.cpu | String | CPU请求，单位为 Core 数，容器启动时初始化可用数量 |
| spec.containers[].resources.requests.memory | String | 内存请求，单位为MiB、GiB，容器启动的初始化可用数量 |
| spec.restartPolicy | String | 定义 pod 的重启策略，可选值为 Always（默认）、OnFailure、Never。</br> - Always: pod一旦终止运行，则无论容器是如何终止的，kubelet服务都将重启它。 </br> - OnFailure: 只有 pod 以非零退出码终止时，kubelet才会重启该容器。如果容器正常结束(退出码为0)，则 kubectl将不会重启它。</br> - Never: Pod终止后，kubelet将退出码报告给master，不会重启该 pod |
| spec.nodeSelector | Object | 定义 Node 的 label 过滤标签，以 key: value 格式指定 |
| spec.imagePullSecrets | Object | 定义 pull 镜像时使用 secret 名称，以 name: secretkey 格式指定 |
| spec.hostNetwork | Boolean | 定义是否使用主机网络模式，默认值为 false。设置 true 表示使用宿主机网络，不使用docker 网桥，同时设置了 true将无法在同一台宿主机上启动第二个副本 |
