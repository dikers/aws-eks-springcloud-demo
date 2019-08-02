mvn package -B -DskipTests
echo "-------------mvn package success.-------------"
mv target/hello-world-service-0.0.2-SNAPSHOT.jar target/app.jar

docker build -t hello-world-service  .
echo "-------------docker build success.-------------"
docker images --filter reference=hello-world-service


docker tag hello-world-service 351315713712.dkr.ecr.us-east-1.amazonaws.com/hello-world-service

docker push 351315713712.dkr.ecr.us-east-1.amazonaws.com/hello-world-service

echo "-------------docker push success.-------------"


kubectl apply -f Deployment.yaml
