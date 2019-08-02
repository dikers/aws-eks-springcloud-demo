mvn package -B -DskipTests
echo "-------------mvn package success.-------------"
mv target/gateway-0.0.1-SNAPSHOT.jar target/app.jar

docker build -t gateway  .
echo "-------------docker build success.-------------"
docker images --filter reference=gateway


docker tag gateway 351315713712.dkr.ecr.us-east-1.amazonaws.com/gateway

docker push 351315713712.dkr.ecr.us-east-1.amazonaws.com/gateway

echo "-------------docker push success.-------------"


# kubectl apply -f Deployment.yaml
