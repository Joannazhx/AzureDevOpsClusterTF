# Define Input Variables
# 1. Azure Location (CentralUS)
# 2. Azure Resource Group Name 
# 3. Azure AKS Environment Name (Dev, QA, Prod)

# Azure Location
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
  default = "Central US"
}

variable "acr_name" {
  type        = string
  description = "ACR name"
}

variable "aks_principal_id" {
  type        = string
}
