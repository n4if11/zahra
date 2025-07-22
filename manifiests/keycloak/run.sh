helm repo add bitnami https://charts.bitnami.com/bitnami
helm install -n keycloak --create-namespace my-keycloak bitnami/keycloak --version 24.6.1 -f values.yaml