mvn package -B -DskipTests
echo "-------------mvn package success.-------------"
mv target/eureka-server-0.0.2-SNAPSHOT.jar target/app.jar

docker build -t eureka-server  .
echo "-------------docker build success.-------------"
docker images --filter reference=eureka-server


docker tag eureka-server 351315713712.dkr.ecr.us-east-1.amazonaws.com/eureka-server

docker push 351315713712.dkr.ecr.us-east-1.amazonaws.com/eureka-server

echo "-------------docker push success.-------------"


# kubectl apply -f Deployment.yaml
