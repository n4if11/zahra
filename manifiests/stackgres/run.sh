helm repo add stackgres-charts https://stackgres.io/downloads/stackgres-k8s/stackgres/helm/
helm repo update 
helm upgrade --install --create-namespace --namespace stackgres stackgres-operator stackgres-charts/stackgres-operator --version 1.16.1 -f values.yaml
kubectl wait -n stackgres deployment -l group=stackgres.io --for=condition=Available

cat << 'EOF' | kubectl create -f -
apiVersion: stackgres.io/v1
kind: SGCluster
metadata:
  name: simple
  namespace: stackgres
spec:
  instances: 1
  postgres:
    version: 'latest'
  pods:
    persistentVolume:
      size: '1Gi'
EOF

# helm template stackgres-charts stackgres-charts/stackgres-operator --version 1.16.1  > all-manifests.yaml
# yq eval-all 'select(.kind == "Service")' all-manifests.yaml | kubectl apply -f -
# apiVersion: v1
# kind: Service
# metadata:
#   namespace: stackgres
#   name: stackgres-charts
# spec:
#   type: ClusterIP
#   selector:
#     app: stackgres-charts
#   ports:
#     - name: https
#       protocol: TCP
#       port: 443
#       targetPort: https


# helm repo add stackgres-charts https://stackgres.io/downloads/stackgres-k8s/stackgres/1.5.0/charts/
# helm repo update

# helm upgrade --install stackgres-operator stackgres-charts/stackgres-operator --namespace stackgres 