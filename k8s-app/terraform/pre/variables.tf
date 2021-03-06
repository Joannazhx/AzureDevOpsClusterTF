# Azure Location
variable "location" {
  type = string
  default = "Central US"
}

# Azure Resource Group Name
variable "resource_group_name" {
  type = string
}

# Azure Storage Account Name
variable "storage_account_name" {
  type = string
  default = "ftstateaccount"
}

# Azure Storage Account Container Name
variable "storage_container_name" {
  type = string
  default = "tfstate"
}

variable "environment" {
  type = string
  default = "dev"
}

