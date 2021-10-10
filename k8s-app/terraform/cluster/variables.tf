# Define Input Variables
# 1. Azure Location (CentralUS)
# 2. Azure Resource Group Name 
# 3. Azure AKS Environment Name (Dev, QA, Prod)
# 4. Azure ACR Name

# Azure Location
variable "location" {
  type = string
  description = "Azure Resources Location"
  # default = "Central US"
}

# Azure Resource Group Name
variable "resource_group_name" {
  type = string
  description = "Resource Group Name"
  # default = "servain-aks-rg"
}

# Azure AKS Environment Name
variable "cluster_name" {
  description = "Azure Kuberneter Cluster Name"
  # default = "servain-aks"
}

variable "environment" {
  type = string  
  default = "dev"
}

variable "acr_name" {
  type        = string
  description = "Azure Container Reginstry Name"
  # default = "servainacr"
}




