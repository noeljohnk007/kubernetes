from pyspark import SparkContext
from pyspark.sql import SparkSession
from pyspark.streaming import StreamingContext
import xlsxwriter
import csv
import io
import json
#custom function to access Hive Table
def FetchHiveTable():
        fetch_sql = "select * from default.login_events"
        table_res = spark.sql(fetch_sql).collect()
        print(table_res)
        row1 = 1
        column1 = 0
        for row in table_res:
                ipAddress = row["ipaddress"]
                sessionId = row["sessionid"]
                time = row["time"]
                type = row["type"]
                userId = row["userid"]
                clientId = row["clientid"]
                details = row["details"]
                worksheet.write(row1,0,ipAddress)
                worksheet.write(row1,1,sessionId)
                worksheet.write(row1,2,time)
                worksheet.write(row1,3,type)
                worksheet.write(row1,4,userId)
                worksheet.write(row1,5,clientId)
                data_set = {"auth_method": details.auth_method, "auth_type": details.auth_type,"code_id":details.code_id,"consent":details.consent,"redirect_uri":details.redirect_uri,"username":details.username}
                json_dump = json.dumps(data_set)
                #print(json_dump)
                json_string = json.dumps(details,indent = 3,sort_keys = True, separators =(", ", " = "))
                #print(json_string)
                worksheet.write(row1,6,json_dump)
                worksheet.write(row1,7,row["realmid"])
               # print(type(details))
                row1 += 1
                print("tweets : " + ipAddress)

        workbook.close()



#Main program starts here
if __name__ == "__main__":
        appname = "Tweets"
        #Creating Spark Session
        spark = SparkSession.builder.appName("Something").config("spark.sql.warehouse.dir", "/user/hive/warehouse").config("hive.metastore.uris", "thrift://hive-metastore:9083").enableHiveSupport().getOrCreate()
        workbook = xlsxwriter.Workbook('login.xlsx')
        worksheet = workbook.add_worksheet()
        bold = workbook.add_format({'bold': True})
        worksheet.write('A1',"ipAddress",bold)
        worksheet.write('B1',"sessionId",bold)
        worksheet.write('C1',"time",bold)
        worksheet.write('D1',"type",bold)
        worksheet.write('E1',"userId",bold)
        worksheet.write('F1',"clientId",bold)
        worksheet.write('G1',"details",bold)
        worksheet.write('H1',"realmId",bold)
        FetchHiveTable()
        spark.stop()
        exit(0)

