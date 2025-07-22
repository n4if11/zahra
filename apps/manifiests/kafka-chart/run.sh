helm repo add strimzi https://strimzi.io/charts/
helm repo update

helm install strimzi-cluster-operator2 strimzi/strimzi-kafka-operator \
  --namespace kafka --create-namespace 
