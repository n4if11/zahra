# helm repo update

helm upgrade --install my-strimzi-cluster-operator oci://quay.io/strimzi-helm/strimzi-kafka-operator -f values.yaml --version 0.45.0 -n kafka --create-namespace