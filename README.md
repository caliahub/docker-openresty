1、基于caliahub/alpine:3.11.5镜像制作

2、openresty版本1.15.8.3

3、openresty工作路径/usr/local/openresty

4、通过nginx-vts-exporter请求http://127.0.0.1:80/status/format/json可以获取nginx监控参数，并输入prometheus标准

#### docker启动示例：
```
docker run -d -p 80:80 -p 443:443 --restart=always caliahub/openresty:1.15.8.3
```

#### docker-compose启动示例：
```
version: '3'
services:
  redis:
    image: caliahub/openresty:1.15.8.3
    restart: always
    ports:
      - 80:80
      - 443:443
```

#### k8s application/deployment.yaml启动示例：
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: openresty
spec:
  selector:
    matchLabels:
      app: openresty
  replicas: 1
  template:
    metadata:
      labels:
        app: openresty
    spec:
      containers:
      - name: openresty
        image: caliahub/openresty:1.15.8.3
        ports:
        - containerPort: 80
        - containerPort: 443
```

