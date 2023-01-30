#Create a namespace
kubectl create namespace service-monitoring
kubectl get namespaces

#Add repository
helm repo add bigdata-gradiant https://gradiant.github.io/bigdata-charts/

#install charts
helm install hive bigdata-gradiant/hive -n service-monitoring

helm upgrade --install hive bigdata-gradiant/hive -n service-monitoring -f values.yaml --debug

hdfs dfs -chmod +wx /user/hive/warehouse