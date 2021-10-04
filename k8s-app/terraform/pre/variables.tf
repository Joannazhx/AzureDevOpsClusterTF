# Azure Location
variable "location" {
  default = "Central US"
}

# Azure Resource Group Name
variable "resource_group_name" {
  default = "edapp-aks-terraform-storage-rg"
}

# Azure Storage Account Name
variable "storage_account_name" {
  default = "ftstateaccount"
}

# Azure Storage Account Container Name
variable "storage_container_name" {
  default = "tfstate"
}

