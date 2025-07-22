helm repo add giantswarm https://giantswarm.github.io/giantswarm-catalog
# helm repo update
helm upgrade --install --namespace <trivy operator namespace> --create-namespace giantswarm/starboard-exporter --target-labels=all
helm upgrade --install --namespace trivy --create-namespace giantswarm/starboard-exporter --target-labels=all
--target-labels=all


   helm repo add aqua https://aquasecurity.github.io/helm-charts/
   helm repo update

      helm install trivy-operator aqua/trivy-operator \
     --namespace trivy-system \
     --create-namespace \
     --version 0.28.1

     helm upgrade -i starboard-exporter --namespace trivy-system giantswarm/starboard-exporter

helm upgrade --install trivy-operator aquasecurity/starboard-operator \
  --namespace trivy-system \
  --create-namespace \
  --set targetNamespaces=default \
  --set trivy.ignoreUnfixed=true