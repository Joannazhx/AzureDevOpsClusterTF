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
module "ftstate-rg" {
  source                = "../module/resource_group/"
  resource_group_name   = var.resource_group_name
  location              = var.location
  environment           = var.environment
  # eg, {edapp-aks}-terraform-storage-rg
}

module "remote-storage" {
  source                 = "../module/storage_account"
  resource_group_name    = "${module.ftstate-rg.resource_group_name}"
  storage_account_name   = var.storage_account_name
  storage_container_name = var.storage_container_name
  location               = var.location
}