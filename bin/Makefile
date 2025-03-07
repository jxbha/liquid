# Workstation Environment
.PHONY: run
run:
	./k3d.sh

.PHONY: git-init
git-init:
	mv mana/{.got/,.git/}

.PHONY: git-mobilize
mobilize:
	mv mana/{.git/,.got/}
	git add --all

.PHONY: deployment
deployment:

.PHONY : registry-init
registry-init:
	k3d registry create jx-registry --default-network jx-env --proxy-password admin --proxy-username admin --port 33335

INTERFACE = $(shell ip addr show | awk '/inet.*brd/{print $$NF; exit}')
ADDRESS = $(shell ip -o -4 addr show $(INTERFACE) | awk -F '[/ ]' '{ print $$7 }')
.PHONY: cluster-init
cluster-init:
	k3d cluster create -v /opt/k8s/vol/2:/opt/k8s/vol/2 -v /opt/k8s/vol/3:/opt/k8s/vol/3 -p 30000-30100:30000-30100@server:0 --api-port 8888 --registry-use jx-registry --network jx-env --k3s-arg '--tls-san=$(ADDRESS)@server:0' --k3s-arg '--kubelet-arg=feature-gates=KubeletInUserNamespace=true@server:0' jx

.PHONY: clean
clean:
	k3d cluster delete jx
	k3d registry delete jx-registry

PORT = $(shell docker ps -f name=jx-registry --format '{{.Ports}}' | head -c 13 | tail -c 5)
.PHONY: helper
helper:
	docker tag helper:latest k3d-jx-registry.localhost:$(PORT)/helper:latest
	docker push k3d-jx-registry.localhost:$(PORT)/helper:latest

.PHONY: mana
mana:
	docker tag localhost/mana:latest k3d-jx-registry.localhost:$(PORT)/mana:latest
	docker push k3d-jx-registry.localhost:$(PORT)/mana:latest

.PHONY: kubectl
kubectl:
	docker tag bitnami/kubectl:latest k3d-jx-registry.localhost:$(PORT)/kubectl:latest
	docker push k3d-jx-registry.localhost:$(PORT)/kubectl:latest

.PHONY: golang
golang:
	docker tag golang:1.20 k3d-jx-registry.localhost:$(PORT)/golang:1.20
	docker push k3d-jx-registry.localhost:$(PORT)/golang:1.20

.PHONY: mongo
mongo:
	docker tag mongo k3d-jx-registry.localhost:$(PORT)/mongo
	docker push k3d-jx-registry.localhost:$(PORT)/mongo

.PHONY: strap-registry
strap-registry: helper mana kubectl golang mongo

.PHONY: kubeconfig
kubeconfig:
	#@k3d kubeconfig get jx > tmpfile | 
	k3d kubeconfig get jx > tmpfile
	sed -i s/'0.0.0.0'/"$(ADDRESS)"/ tmpfile

.PHONY: help
help:
	@echo "你好! What we doing?"
	@less Makefile

.DEFAULT_GOAL := help
