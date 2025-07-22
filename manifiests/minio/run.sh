# Add the MinIO Helm repo (if not already added)
helm repo add minio https://charts.min.io
helm repo update

# Install MinIO in the `minio` namespace with a custom values.yaml
helm install --namespace minio --create-namespace minio minio/minio -f values.yaml --generate-name

# helm install --set resources.requests.memory=512Mi  --set persistence.enabled=false --set mode=standalone --generate-name minio/minio -f values.yaml


# helm repo add minio https://charts.min.io/
# helm install --namespace minio  --generate-name minio/minio -f values.yaml
# helm install my-release minio/minio
# helm upgrade --install --namespace minio  --generate-name minio/minio -f values.yaml
# helm upgrade --install minio \
#   --namespace minio \
#   -f values.yaml \
#   minio/minio
: