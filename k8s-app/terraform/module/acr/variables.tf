# Define Input Variables
# 1. Azure Location (CentralUS)
# 2. Azure Resource Group Name 

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

