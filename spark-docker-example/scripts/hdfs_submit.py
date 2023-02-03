from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import StringType, StructType, StructField
import json

master="local"
appname="kafka-spark-streaming"

#spark = SparkSession.builder.master(master).appName(appname).config("spark.sql.warehouse.dir", "/user/hive/warehouse").config("hive.metastore.uris", "thrift://hive-metastore:9083").enableHiveSupport().getOrCreate()
spark = SparkSession.builder.master(master).appName(appname).getOrCreate()

spark.sparkContext.setLogLevel("ERROR")

df = spark.readStream.format("kafka").option("kafka.bootstrap.servers", "kafka:9092").option("subscribe", "service-monitoring").option("startingOffsets", "latest").load()

df=df.selectExpr("CAST(value AS STRING)")

loginSchema = StructType.fromJson(json.load(open("/home/spark_kafka/login_schema.json")))
print(loginSchema)
df=df.withColumn("jsonData",from_json(col("value"), loginSchema)).select("jsonData.*")

print("######################################hdfs#######################################")
df.writeStream.format("com.databricks.spark.avro").option("mode","append").option("path","hdfs://namenode:8020/user/hive/warehouse/login_events").option("checkpointLocation", "/home/spark_kafka/checkpoint-hive/login_events").start()

#print("######################################hive#######################################")
#spark.sql("select * from default.login_events").show()

#print("######################################kafka#######################################")
#df.writeStream.format("kafka").option("kafka.bootstrap.servers", "kafka:9092").option("topic", "yourtopic").option("checkpointLocation", "/home/spark_kafka/checkpoint-kafka").start()

print("######################################console#######################################")
df.writeStream.outputMode("append").option('truncate','false').format("console").start().awaitTermination()