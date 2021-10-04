# Azure Location
variable "location" {
  type = string
}

# Azure Resource Group Name
variable "resource_group_name" {
  type = string
}

# Azure Resource Environment Name
variable "environment" {
  type = string  
  default = "dev"
}