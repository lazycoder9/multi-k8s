CLIENT_SHA = $(shell tar -cf - ./client | sha1sum | awk '{print $$1}')
SERVER_SHA = $(shell tar -cf - ./server | sha1sum | awk '{print $$1}')
WORKER_SHA = $(shell tar -cf - ./worker | sha1sum | awk '{print $$1}')

build_and_deploy_client:
	docker build -t lazycoder/multi-client:latest -t lazycoder/multi-client:$(CLIENT_SHA) -f ./client/Dockerfile ./client
	docker push lazycoder/multi-client:latest
	docker push lazycoder/multi-client:$(CLIENT_SHA)
	kubectl apply -f k8s
	kubectl set image deployments/client-deployment client=lazycoder/multi-client:$(CLIENT_SHA)

build_and_deploy_server:
	docker build -t lazycoder/multi-server:latest -t lazycoder/multi-server:$(SERVER_SHA) -f ./server/Dockerfile ./server
	docker push lazycoder/multi-server:latest
	docker push lazycoder/multi-server:$(SERVER_SHA)
	kubectl apply -f k8s
	kubectl set image deployments/server-deployment server=lazycoder/multi-server:$(SERVER_SHA)

build_and_deploy_worker:
	docker build -t lazycoder/multi-worker:latest -t lazycoder/multi-worker:$(WORKER_SHA) -f ./worker/Dockerfile ./worker
	docker push lazycoder/multi-worker:latest
	docker push lazycoder/multi-worker:$(WORKER_SHA)
	kubectl apply -f k8s
	kubectl set image deployments/worker-deployment worker=lazycoder/multi-worker:$(WORKER_SHA)

