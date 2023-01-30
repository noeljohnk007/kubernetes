#Service principle generation
az ad sp create-for-rbac -n "AKS-Dev-Env" --role Contributor
#The following service principle will be generated:
:'
{
  "appId": "8ab80a97-b77d-4599-8519-855e10f9e7c7",
  "displayName": "AKS-Dev-Env",
  "password": "MFstqKbSXG_fK~BbNdd4y3y7agw1_3bch7",
  "tenant": "1aaaea9d-df3e-4ce7-a55d-43de56e79442"
}

Verify the same in App registrations
'

#Kubernetes CLuster Creation
terraform init
terraform plan
az login
az account set --subscription 10678f35-4026-4469-a303-099cd9eca4c9
terraform apply