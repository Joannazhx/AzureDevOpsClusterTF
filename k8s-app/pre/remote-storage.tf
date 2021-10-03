terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "tfstate" {
  name     = "terraform-storage-rg"
  location = "Central US"
}

#  backend "azurerm" {
#     resource_group_name   = "terraform-storage-rg"
#     storage_account_name  = "edappterraformstorge"
#     container_name        = "tfstate"
#     key                   = "edapp.dev.terraform.tfstate"
#   }  

resource "azurerm_storage_account" "tfstate" {
  name                     = "edappterraformstorage"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}