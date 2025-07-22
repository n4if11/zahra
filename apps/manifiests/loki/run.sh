helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

  
 helm upgrade --install loki grafana/loki \
  --namespace loki -f values.yaml 

   helm upgrade --install loki-1 grafana/promtail --namespace loki  -f promtail.yaml

