#docker-compose.yml
zookeeper and kafka image

#to build and spinup the zookeeper and kafka image
docker compose up -d  

#to check the ZooKeeper and kafka logs is working and healthy.
docker compose logs zookeeper | Select-String -Pattern binding
docker compose logs kafka | Select-String -Pattern started  

#to get an interactive prompt
docker compose exec kafka bash  
docker compose exec zookeeper bash

#to shutdown docker compose
docker compose down 

#goto the dir where kafka-topics.sh is present
cd /opt/kafka/bin

#to create topic
./kafka-topics.sh --create  --topic mytopic  --bootstrap-server kafka:9092  

#to list all the topics
./kafka-topics.sh --list --bootstrap-server kafka:9092  

#to delete the topics
./kafka-topics.sh --delete --topic mytopic --bootstrap-server kafka:9092  

#producer command line
./kafka-console-producer.sh --broker-list kafka:9092 --topic mytopic

#consumer command line
./kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic mytopic --from-beginning

#to list all the active containers
docker ps

#to list all the images
docker image ls

#to copy the consumer file from local machine to docker container
docker cp consumer.py 53ff5522cf45:/home/KafkaUser/spark_final

#to build a docker image
docker build -f Dockerfile -t spark-docker-image .

#to tag a docker image from local
docker tag spark-docker-image noeljohnk/kmd-newgeneration:spark-docker-image

#to push the tagged docker image from local to the remote repository
docker push noeljohnk/kmd-newgeneration:spark-docker-image

#to run a docker image
docker run -i -t spark-docker-image /bin/bash 

#to login to the container terminal
docker exec -it 0bd98bc5b021 /bin/bash

#to create a docker network
docker network create kafka_container_network

#to run the zookeeper in container network
sudo docker run --network=kafka_container_network --rm --detach --name zookeeper -e ZOOKEEPER_CLIENT_PORT=2181 confluentinc/cp-zookeeper

#to run the kafka in container network
sudo docker run --network=kafka_container_network --rm --detach --name broker \
           -p 9092:9092 \
           -e KAFKA_BROKER_ID=1 \
           -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
           -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://localhost:9092 \
           -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
           confluentinc/cp-kafka
		   
#to run the container image in the container network
sudo docker run --network=kafka_container_network --rm --name spark-docker-image --tty spark-docker-image

#to stop the kafka in container network
sudo docker stop broker

#to restart the kafka in container network
sudo docker run --network=kafka_container_network --rm --detach --name broker \
           -p 9092:9092 \
           -e KAFKA_BROKER_ID=1 \
           -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
           -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://broker:9092 \
           -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
           confluentinc/cp-kafka

#to list the running services   
ps -ef

#to list detailed information about the docker network
docker network inspect kafka_container_network

spark-submit --packages org.apache.spark:spark-sql-kafka-0-10_2.11:2.4.3 kafka_submit.py
spark-submit --packages org.apache.spark:spark-streaming-kafka-0-8-assembly_2.11:2.4.3 hive_submit.py

spark-submit --jars spark-streaming-kafka-0-8-assembly_2.11-2.4.3.jar hive_submit.py


CREATE TABLE tweets (text STRING, words INT, length INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\\|' STORED AS TEXTFILE;

VM-20.67.35.234

KafkaUser
Kafka@User@12345

POCs
----
1. kafka-python done
2. kafka continuing where it stopped done
3. spark python code improvisation done
4. rewrite the data to another topic done
5. setting services in different network
6. kubernetes sample program


spark-submit --packages org.apache.spark:spark-sql-kafka-0-10_2.11:2.4.3,org.apache.spark:spark-avro_2.11:2.4.3  hdfs_submit.py

------------------------------------------
pyspark --packages org.apache.spark:spark-sql-kafka-0-10_2.11:2.4.3,org.apache.spark:spark-avro_2.11:2.4.3
spark.read.format("com.databricks.spark.avro").load("hdfs://namenode:8020/user/hive/warehouse/tweets").show()

------------------------------------------
ALTER TABLE tweets SET TBLPROPERTIES ('external.table.purge'='false');
DROP TABLE tweets;

----------------------------------------------------------

CREATE EXTERNAL TABLE tweets
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
LOCATION '/user/hive/warehouse/tweets'
TBLPROPERTIES ('avro.schema.url'='hdfs://namenode:8020/user/hive/warehouse/schemas/tweets.avsc');
 
------------------------------------------------------------------

CREATE EXTERNAL TABLE login_events
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
LOCATION '/user/hive/warehouse/login_events'
TBLPROPERTIES ('avro.schema.url'='hdfs://namenode:8020/user/hive/warehouse/schemas/login_events.avsc');


--------------------
set hive.cli.print.header=true;



------------------------------

curl -d "client_id=hiveclient" -d "client_secret=yWRaZGMkYoc9DjMn0uwXWLQmeDkx7J8D" -d "username=myuser" -d "password=password" -d "grant_type=password" "http://127.0.0.1:8080/auth/realms/myrealm/protocol/openid-connect/token"


----------
docker run -p 8180:8180 --rm -ti farberg/apache-knox-docker:$KNOX_VERSION

------------

curl -i -L "http://127.0.0.1:50070/webhdfs/v1/user/hive/warehouse/test/sample.csv?op=OPEN"

curl -i -k -u guest:guest-password -X GET http://127.0.0.1:50070/webhdfs/v1/user/hive/warehouse/test/sample.csv?op=OPEN


http://127.0.0.1:10000/templeton/v1/ddl/database/default/table/test

http://localhost:50111/templeton/v1/ddl/database/default/table/my_table

w55M2qtAqOXtIW4tzVPixSVLKxblw0zK
\
netstat -aof | findstr :2379



hdfs dfsadmin -safemode get
hdfs dfsadmin -safemode enter
hdfs dfsadmin -safemode leave