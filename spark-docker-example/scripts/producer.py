from time import sleep
from json import dumps
from kafka import KafkaProducer

producer = KafkaProducer(
    bootstrap_servers=['kafka:9092'],
    value_serializer=lambda x: dumps(x).encode('utf-8')
)
for j in range(9999):
    print("counter", j)
    data = {'counter': j}
    producer.send('mytopic', value=data)
    sleep(5)