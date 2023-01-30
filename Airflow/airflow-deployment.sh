Create acr - hcmnewgenerationreportingdev.azurecr.io
push docker image to hcmnewgenerationreportingdev.azurecr.io

enable admin login

kubectl -n hcm-datatransfer create secret docker-registry acr-hcmnewgenerationreportingdev \
    --docker-server=hcmnewgenerationreportingdev.azurecr.io \
    --docker-username=hcmnewgenerationreportingdev \
    --docker-password=8c8UtXRVUDkXVZJyqz=4OvErsWB3d4T3

-----------------
Create a storage account - hcmnewgenreportingdev
Create a file share - airflow-dags
Create a file share - airflow-logs

Create Storage Secret - storage-secret-hcmnewgenreportingdev
  $accountName = "hcmnewgenreportingdev"
  $accountNameBytes = [System.Text.Encoding]::UTF8.GetBytes($accountName)
  $accountNameBase64 = [Convert]::ToBase64String($accountNameBytes)
  Write-Host "Account Name Base 64: " $accountNameBase64

  $accountKey = "STbcnmUcVIRevJyybUaNaGep0y60s7hKnHHiFB8K3rIWuyzqJwCMJu6nMWSovdL6e6xkDXhRy43L+AStGwRmcQ=="
  $accountKeyBytes = [System.Text.Encoding]::UTF8.GetBytes($accountKey)
  $accountKeyBase64 = [Convert]::ToBase64String($accountKeyBytes)
  Write-Host "Account Name Key 64: " $accountKeyBase64

  add the name and key to storage-secret.yaml
  deploy storage-secret.yaml -  "kubectl create -f secret-sauce.yaml"

deploy pv-airflow-dags.yaml -  "kubectl create -f pv-airflow-dags.yaml"
deploy pvc-airflow-dags.yaml -  "kubectl create -f pvc-airflow-dags.yaml"
deploy pv-airflow-logs.yaml -  "kubectl create -f pv-airflow-logs.yaml"
deploy pv-airflow-logs.yaml -  "kubectl create -f pv-airflow-logs.yaml"

#airflow helm repo addition
helm repo add apache-airflow https://airflow.apache.org

#airflow helm chart download
helm show values apache-airflow/airflow > helm-airflow-values.yaml

make modifications to helm-airflow-values.yaml
install helm-airflow-values.yaml

helm upgrade --install airflow apache-airflow/airflow -n hcm-datatransfer -f helm-airflow-values.yaml --debug

--------------
kubectl create secret docker-registry testquay \
    --docker-server=quay.io \
    --docker-username=<Profile name> \
    --docker-password=<password>