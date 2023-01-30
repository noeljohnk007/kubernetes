terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.48.0"
    }
  }
}

provider "azurerm" {
  features {}
}

 

resource "azurerm_resource_group" "rg" {
  name = "AKS_DEV_RG"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "AKS-DEV-Cluster" {
  name                = "AKS-DEV-Cluster"
  location            = var.location
  resource_group_name = "AKS_DEV_RG"
  dns_prefix          = "AKS-DEV-Cluster"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

service_principal {
    client_id     = "8ab80a97-b77d-4599-8519-855e10f9e7c7"
    client_secret = "MFstqKbSXG_fK~BbNdd4y3y7agw1_3bch7"
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.AKS-DEV-Cluster.kube_config.0.client_certificate
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.AKS-DEV-Cluster.kube_config_raw
  sensitive = true
}