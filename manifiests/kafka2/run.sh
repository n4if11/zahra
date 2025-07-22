helm repo add strimzi https://strimzi.io/charts/
helm repo update

helm install strimzi-cluster-operator strimzi/strimzi-kafka-operator \
  --namespace kafka2 --create-namespace 
