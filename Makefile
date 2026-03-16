CLUSTER_NAME=zahra
NETWORK_NAME=k3d-$(CLUSTER_NAME)
CLUSTER_DOMAIN=$(CLUSTER_NAME).local
#NETWORK_SUBNET=10.4.0.0/16
K3D_CONFIG=k3d-config.yaml
CURRENT_DIR := $(shell pwd)
KUBE_CONTEXT=k3d-$(CLUSTER_NAME)
INGRESS_HOST=ingress.$(CLUSTER_DOMAIN).k3d

PROD_CLUSTER_NAME=prod
PROD_NETWORK_NAME=k3d-$(PROD_CLUSTER_NAME)
PROD_CLUSTER_DOMAIN=$(PROD_CLUSTER_NAME).local
PROD_KUBE_CONTEXT=k3d-$(PROD_CLUSTER_NAME)

create:
	@echo ">>> ${CURRENT_DIR}"
	@echo "Creating k3d cluster..."
	k3d cluster create \
		--image rancher/k3s:v1.30.6-k3s1 \
		--servers 1 \
		--agents 2 \
		--api-port 6550 \
    	--port 8081:80@loadbalancer \
    	--port 8443:443@loadbalancer \
		--volume ${CURRENT_DIR}/data:/data@server:0 \
		--k3s-arg "--disable=traefik@server:*" \
		--k3s-arg "--cluster-cidr=10.42.0.0/16@server:*" \
		--k3s-arg "--service-cidr=10.43.0.0/16@server:*" \
		--k3s-arg "--cluster-domain=${CLUSTER_DOMAIN}@server:*" \
		--k3s-arg "--tls-san=${CLUSTER_DOMAIN}@server:*" \
		--k3s-node-label "foo=bar@agent:0" \
		--k3s-node-label "tier=server@server:*" \
		--k3s-node-label "tier=worker@agent:*" \
		--k3s-node-label "worker=a@agent:*" \
		--wait \
		--kubeconfig-switch-context \
		--timeout 60s \
		${CLUSTER_NAME}

create-prod:
	@echo ">>> ${CURRENT_DIR}"
	@echo "Creating prod k3d cluster..."
	k3d cluster create \
		--image rancher/k3s:v1.30.6-k3s1 \
		--servers 1 \
		--agents 2 \
		--api-port 6551 \
		--port 8082:80@loadbalancer \
		--port 8444:443@loadbalancer \
		--volume ${CURRENT_DIR}/data:/data@server:0 \
		--k3s-arg "--disable=traefik@server:*" \
		--k3s-arg "--cluster-cidr=10.52.0.0/16@server:*" \
		--k3s-arg "--service-cidr=10.53.0.0/16@server:*" \
		--k3s-arg "--cluster-domain=${PROD_CLUSTER_DOMAIN}@server:*" \
		--k3s-arg "--tls-san=${PROD_CLUSTER_DOMAIN}@server:*" \
		--k3s-node-label "foo=bar@agent:0" \
		--k3s-node-label "tier=server@server:*" \
		--k3s-node-label "tier=worker@agent:*" \
		--k3s-node-label "worker=a@agent:*" \
		--wait \
		--kubeconfig-switch-context \
		--timeout 60s \
		${PROD_CLUSTER_NAME}

apply:
	@echo "Installing dependencies..."
	kubectl apply -k manifests/ --context=$(KUBE_CONTEXT)

uninstall:
	@echo "Uninstalling dependencies..."
	kubectl delete -k manifests/ --context=$(KUBE_CONTEXT)

reapply: uninstall apply

recreate: clean create

clean:
	@echo "Deleting k3d cluster..."
	k3d cluster delete $(CLUSTER_NAME) || true
	docker network rm $(NETWORK_NAME) || true

clean-prod:
	@echo "Deleting prod k3d cluster..."
	k3d cluster delete $(PROD_CLUSTER_NAME) || true
	docker network rm $(PROD_NETWORK_NAME) || true

recreate-prod: clean-prod create-prod