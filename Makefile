CLUSTER_NAME ?= zahra
CURRENT_DIR  := $(shell pwd)

create:
	k3d cluster create $(CLUSTER_NAME) \
		--image rancher/k3s:v1.30.6-k3s1 \
		--servers 1 \
		--agents 2 \
		--api-port 6550 \
		--port 8080:80@loadbalancer \
		--port 8443:443@loadbalancer \
		--volume $(CURRENT_DIR)/data:/data@server:0 \
		--k3s-arg "--disable=traefik@server:*" \
		--wait \
		--kubeconfig-switch-context \
		--timeout 60s

bootstrap:
	kubectl apply -f bootstrap.yaml

clean:
	k3d cluster delete $(CLUSTER_NAME) || true

recreate: clean create
