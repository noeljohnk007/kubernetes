import pyodbc 

HOST='127.0.0.1'
PORT='10000'
database = 'default' 
username = 'hive' 
password = 'hive' 

cnxn = pyodbc.connect('DRIVER={Microsoft Hive ODBC Driver};Host='+HOST+';Port='+PORT+';Schema='+database+';UserName='+username+';PWD='+password+';HS2AuthMech=2;', autocommit=True)
#cnxn = pyodbc.connect('DSN=hive_local_without_auth', autocommit=True)

cursor = cnxn.cursor()

cursor.execute("SELECT * from login_events;")
rows = cursor.fetchall()
for row in rows:
    print(row)

cursor.close()