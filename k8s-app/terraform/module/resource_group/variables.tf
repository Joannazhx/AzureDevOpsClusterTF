# Azure Location
variable "location" {
  type = string
  default = "Central US"
}

# Azure Resource Group Name
variable "resource_group_name" {
  type = string
}

# Azure AKS Environment Name
variable "environment" {
  type = string  
  default = "dev"
}