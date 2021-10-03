# Provision AKS Cluster

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${azurerm_resource_group.aks_rg.name}-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "${azurerm_resource_group.aks_rg.name}-cluster"
  node_resource_group = "${azurerm_resource_group.aks_rg.name}-nrg"

    default_node_pool {
      name       = "systempool"
      node_count = 1
      vm_size    = "Standard_D2_v2"
    }

# Identity (System Assigned or Service Principal)
  identity {
    type = "SystemAssigned"
  }


# Network Profile
  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "Standard"
  }

  tags = {
    Environment = "dev"
  }
}