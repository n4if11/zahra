helm repo add external-secrets https://charts.external-secrets.io
helm repo update
helm install external-secrets --namespace externalsecrets --create-namespace external-secrets/external-secrets -f values.yaml




