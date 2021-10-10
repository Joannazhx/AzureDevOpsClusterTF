# Provision AKS Cluster

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${var.cluster_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.cluster_name}-${var.environment}"

    default_node_pool {
      name       = "systempool"
      node_count = 1
      vm_size    = "Standard_D2_v2"
      enable_auto_scaling  = true
      max_count            = 3
      min_count            = 1
    }

  # Identity (System Assigned or Service Principal)
  identity {
    type = "SystemAssigned"
  }

  # Network Profile
  network_profile {
    network_plugin = "kubenet"
    load_balancer_sku = "Standard"
  }

  # Add On Profiles - disable
  addon_profile {
    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = false
    }

    oms_agent {
      enabled = false
    }
  }

  tags = {
    Environment = var.environment
  }
}