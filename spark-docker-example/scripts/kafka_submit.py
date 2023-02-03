from pyspark.sql import SparkSession
from pyspark.sql.functions import *

master="local"
appname="kafka-spark-kafka"

#spark = SparkSession.builder.master(master).appName(appname).config("spark.sql.warehouse.dir", "/user/hive/warehouse").config("hive.metastore.uris", "thrift://hive-metastore:9083").enableHiveSupport().getOrCreate()
spark = SparkSession.builder.master(master).appName(appname).getOrCreate()

spark.sparkContext.setLogLevel("ERROR")

df = spark.readStream.format("kafka").option("kafka.bootstrap.servers", "kafka:9092").option("subscribe", "mytopic").option("startingOffsets", "latest").load()

df=df.selectExpr("CAST(value AS STRING)")

print("######################################kafka#######################################")
df.writeStream.format("kafka").option("kafka.bootstrap.servers", "kafka:9092").option("topic", "yourtopic").option("checkpointLocation", "/home/spark_kafka/checkpoint-kafka").start()

print("######################################console#######################################")
df.writeStream.outputMode("append").option('truncate','false').format("console").start().awaitTermination()