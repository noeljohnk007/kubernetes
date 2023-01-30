# Adding the helm repo
helm repo add hashicorp https://helm.releases.hashicorp.com

# Updating the helm repo
helm repo update

# Downloading the consul helm chart
helm show values hashicorp/consul > helm-consul-values.yaml

# Installing the downloaded consul helm chart
helm install consul hashicorp/consul --values helm-consul-values.yaml -n hcm-datatransfer

############################################################################################
# Downloading the vault helm chart
helm show values hashicorp/vault > helm-vault-values.yaml

# Installing the downloaded vault helm chart
helm install vault hashicorp/vault --values helm-vault-values.yaml -n hcm-datatransfer

# Initialize Vault with one key share and one key threshold.
kubectl -n hcm-datatransfer exec vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster-keys.json

# Create a variable named VAULT_UNSEAL_KEY to capture the Vault unseal key
VAULT_UNSEAL_KEY=$(cat cluster-keys.json | jq -r ".unseal_keys_b64[]")

# Unseal Vault running on the vault-0, vault-1 and vault-2 pod
kubectl -n hcm-datatransfer exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY
kubectl -n hcm-datatransfer exec vault-1 -- vault operator unseal $VAULT_UNSEAL_KEY
kubectl -n hcm-datatransfer exec vault-2 -- vault operator unseal $VAULT_UNSEAL_KEY

cat cluster-keys.json | jq -r ".root_token"