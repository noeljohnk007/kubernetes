from keycloak import KeycloakAdmin
from kafka import KafkaProducer
from json import dumps

keycloak_admin = KeycloakAdmin(server_url="http://keycloak:8080/auth/",
                               username='admin',
                               password='password',
                               realm_name='myrealm',
                               user_realm_name='master',
                               verify=True)

#count_users = keycloak_admin.users_count()
#users = keycloak_admin.get_users({})

events=keycloak_admin.get_events({'type':'LOGIN'})

#print(count_users)
#print(users)
#print(events)

producer = KafkaProducer(
    bootstrap_servers=['kafka:9092'],
    value_serializer=lambda x: dumps(x).encode('utf-8')
)

for index, event in enumerate(events):
    print('Event #{} = {}'.format(index, event))
    result=producer.send('mytopic', value=event)
    result.get()
  
