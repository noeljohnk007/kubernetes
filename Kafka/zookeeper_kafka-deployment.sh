#bitnami repo addition
helm repo add bitnami https://charts.bitnami.com/bitnami

#Zookeeper installation
helm show values bitnami/zookeeper  > values-zookeeper.yaml
helm upgrade --install zookeeper bitnami/zookeeper -n hcm-datatransfer -f values-zookeeper.yaml --debug

#Kafka installation
helm show values bitnami/kafka  > values-kafka.yaml
helm upgrade --install kafka bitnami/kafka -n hcm-datatransfer -f values-kafka.yaml --debug

#Kafka Topic Creation
#kubectl --namespace hcm-datatransfer exec -it $POD_NAME -- kafka-topics.sh --create --zookeeper ZOOKEEPER-SERVICE-NAME:2181 --replication-factor 1 --partitions 1 --topic mytopic
kubectl --namespace hcm-datatransfer exec -it kafka-0 -- kafka-topics.sh --create --bootstrap-server kafka.hcm-datatransfer.svc.cluster.local:9092 --replication-factor 1 --partitions 1 --topic mytopic

#Kafka Topic Deletion
kubectl --namespace hcm-datatransfer exec -it kafka-0 -- kafka-topics.sh --bootstrap-server kafka.hcm-datatransfer.svc.cluster.local:9092 --delete --topic hcm-datatransfer

#Kafka Consumer
#kubectl --namespace hcm-datatransfer exec -it $POD_NAME -- kafka-console-consumer.sh --bootstrap-server KAFKA-SERVICE-NAME:9092 --topic mytopic --consumer.config /opt/bitnami/kafka/conf/consumer.properties &
kubectl --namespace hcm-datatransfer exec -it kafka-0 -- kafka-console-consumer.sh --bootstrap-server kafka.hcm-datatransfer.svc.cluster.local:9092 --topic mytopic --consumer.config /opt/bitnami/kafka/config/consumer.properties

#Kafka Producer
#kubectl --namespace hcm-datatransfer exec -it $POD_NAME -- kafka-console-producer.sh --broker-list KAFKA-SERVICE-NAME:9092 --topic mytopic --producer.config /opt/bitnami/kafka/conf/producer.properties
kubectl --namespace hcm-datatransfer exec -it kafka-0 -- kafka-console-producer.sh --broker-list kafka.hcm-datatransfer.svc.cluster.local:9092 --topic mytopic --producer.config /opt/bitnami/kafka/config/producer.properties

#List Topics
kubectl --namespace hcm-datatransfer exec -it kafka-0 -- kafka-topics.sh --bootstrap-server kafka.hcm-datatransfer.svc.cluster.local:9092 --list

#Delete Topics
kubectl --namespace hcm-datatransfer exec -it kafka-0 -- kafka-topics.sh --bootstrap-server kafka.hcm-datatransfer.svc.cluster.local:9092 --delete --topic mytopic
