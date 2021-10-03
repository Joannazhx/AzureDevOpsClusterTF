# Define Input Variables
# 1. Azure Location (CentralUS)
# 2. Azure Resource Group Name 
# 3. Azure AKS Environment Name (Dev, QA, Prod)

# Azure Location
variable "location" {
  type = string
  default = "Central US"
}

# Azure Resource Group Name
variable "resource_group_name" {
  type = string
  default = "edapp-terraform-aks"
}

# Azure AKS Environment Name
variable "environment" {
  type = string  
  default = "dev"
}


