from pyspark.sql import SparkSession

master="local"
appname="schema-generator"

spark = SparkSession.builder.master(master).appName(appname).getOrCreate()

df = spark.read.json("/home/spark_kafka/temp/delta.json")
df.printSchema()
print(df.schema.json())