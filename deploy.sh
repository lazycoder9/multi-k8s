docker build -t lazycoder/multi-client:latest -t lazycoder/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t lazycoder/multi-server:latest -t lazycoder/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t lazycoder/multi-worker:latest -t lazycoder/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push lazycoder/multi-client:latest
docker push lazycoder/multi-server:latest
docker push lazycoder/multi-worker:latest

docker push lazycoder/multi-client:$SHA
docker push lazycoder/multi-server:$SHA
docker push lazycoder/multi-worker:$SHA

kubectl apply -f k8s

kubectl set image deployments/client-deployment client=lazycoder/multi-client:$SHA
kubectl set image deployments/server-deployment server=lazycoder/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=lazycoder/multi-worker:$SHA
