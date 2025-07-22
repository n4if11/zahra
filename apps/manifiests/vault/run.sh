helm repo add hashicorp https://helm.releases.hashicorp.com
helm install vault hashicorp/vault --namespace vault

 helm install vault hashicorp/vault \
    --namespace vault \
    -f values.yaml
#helm upgrade --install -f values.yaml vault hashicorp/vault -n vault