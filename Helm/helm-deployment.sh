#Helm Installation
wget https://get.helm.sh/helm-v3.3.0-linux-amd64.tar.gz
tar -zxvf helm-v3.3.0-linux-amd64.tar.gz
sudo cp -a linux-amd64/helm /home/noel/k8s/helm
chmod +x /home/noel/k8s/helm

#Helm repo addition
helm repo add apache-airflow https://airflow.apache.org
helm repo add bitnami https://charts.bitnami.com/bitnami