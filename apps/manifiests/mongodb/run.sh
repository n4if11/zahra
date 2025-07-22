helm repo add https://charts.bitnami.com/bitnami
helm update

 helm install -n mongodb --create-namespace my-release oci://registry-1.docker.io/bitnamicharts/mongodb -f values.yaml
