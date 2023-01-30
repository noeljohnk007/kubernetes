#to create a namespace
kubectl create namespace hcm-datatransfer

#to set the default namespaces
kubectl config set-context --current --namespace=hcm-datatransfer

#to list all namespaces
kubectl get namespaces

#to list all the pods
kubectl get pods -n hcm-datatransfer

#to list all the resources in a namespace
kubectl get all -n hcm-datatransfer

#to apply the resource templates
kubectl apply -f namespace.yaml
kubectl apply -f airflow-db.yaml
kubectl apply -f airflow.yaml

#to change any resource yaml file
kubectl -n hcm-datatransfer edit service/airflow-webserver

#to delete the pods with completed status
kubectl delete pod --field-selector=status.phase==Succeeded

#to delete the pods with evicted status
kubectl delete pod --field-selector=status.phase==Failed

#to check the storage of a volume
kubectl -n hcm-datatransfer exec <pod-name> df

#to get the password of airflow
#user is user
$(kubectl get secret --namespace "hcm-datatransfer" airflow-airflow -o jsonpath="{.data.airflow-password}" | base64 --decode)

#to login to postgres
psql -w -U postgres -d postgres -c SELECT 1
