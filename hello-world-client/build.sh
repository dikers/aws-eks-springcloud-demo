mvn package -B -DskipTests
echo "-------------mvn package success.-------------"
mv target/hello-world-client-0.0.2-SNAPSHOT.jar target/app.jar

docker build -t hello-world-client  .
echo "-------------docker build success.-------------"
docker images --filter reference=hello-world-client


docker tag hello-world-client 351315713712.dkr.ecr.us-east-1.amazonaws.com/hello-world-client

docker push 351315713712.dkr.ecr.us-east-1.amazonaws.com/hello-world-client

echo "-------------docker push success.-------------"


kubectl apply -f Deployment.yaml
