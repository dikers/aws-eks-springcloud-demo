# 基于EKS部署springcloud




### 安装 eksctl

```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

sudo mv /tmp/eksctl /usr/local/bin

eksctl version

```

### 安装 kubectl

```
```



### 准备EKS集群


```
eksctl create cluster \
--name prod \
--version 1.13 \
--nodegroup-name standard-workers \
--node-type t3.medium \
--nodes 3 \
--nodes-min 1 \
--nodes-max 4 \
--node-ami auto


#查看帮助文档
eksctl create cluster --help

```


###  集群创建成功后， 查看k8s service 信息
```
kubectl get svc

# 输出信息如下
NAME             TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
svc/kubernetes   ClusterIP   10.100.0.1   <none>        443/TCP   1m

```

### 创建远程docker 仓库
```
# 下面的命令会提供一个12小时可以访问的登录口令， 复制口令并且执行。 
aws ecr get-login --no-include-email --region region


# aws ecr create-repository --repository-name hello-repository --region region

aws ecr eureka-server --repository-name eureka-server --region us-east-1
aws ecr gateway --repository-name gateway --region us-east-1
aws ecr hello-world-client --repository-name hello-world-client --region us-east-1
aws ecr hello-world-service --repository-name hello-world-service --region us-east-1



```




### 部署服务发现
```
cd eureka-server
chmod +x ./build.sh
./build.sh


```

### build.sh 介绍
```
# 编译
mvn package -B -DskipTests

# 改变jar包名称
mv target/eureka-server-0.0.2-SNAPSHOT.jar target/app.jar

# docker 编译image。
docker build -t eureka-server  .

docker images --filter reference=eureka-server

# 给image 打tag
docker tag eureka-server 351315713712.dkr.ecr.us-east-1.amazonaws.com/eureka-server
# 讲image 推送到远程仓库
docker push 351315713712.dkr.ecr.us-east-1.amazonaws.com/eureka-server


kubectl apply -f Deployment.yaml
```


### 更新其余模块的服务发现地址
```
kubectl get svc


#找出LB 的DNS


# 修改其他模块中  Deployment.yaml  中环境变量

        env:
        - name: eureka_host
          value: "abde092e8b48b11e9994f169df7597a1-1726433688.us-east-1.elb.amazonaws.com"
        - name: eureka_port
          value: "8761"


```



### 部署剩余模块
```
cd ../gateway
./build.sh

cd ../hello-world-client
./build.sh

cd ../hello-world-service
./build.sh


# 等部署成功后验证 
kubectl get pods
kubectl get svc


```


### 在浏览器中验证
```
#http://a3f6221acb48d11e9994f169df7597a1-713525331.us-east-1.elb.amazonaws.com/api/hello?name=zhangliang

# gateway/src/main/resources/application.yml  文件中查看路由
      routes:
        - id: route_hello
          uri: lb://hello-world-client
          predicates:
            - Path=/api/**
          filters:
            - StripPrefix=1



# gateway  将 /api/ 的路由转发给了 hello-world-client， 
# hello-world-client 自己的请求地址  /hello
# 拼接到一起， 就是 gateway_url/api/hello




```





