terraform {
  # 1. Required Version Terraform
  required_version = ">= 0.13"
  # 2. Required Terraform Providers  
  required_providers {
    // azurerm latest version has bug on resource zurerm_kubernetes_cluster https://github.com/hashicorp/terraform-provider-azurerm/issues/11396
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.78.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

# Terraform State Storage to Azure Storage Container
  backend "azurerm" {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "edappterraformstorage"
    container_name        = "tfstate"
    key                   = "edapp.dev.terraform.tfstate"
  }  
}



# 2. Terraform Provider Block for AzureRM
provider "azurerm" {
  features {

  }
}

# 3. Terraform Resource Block: Define a Random Pet Resource
resource "random_pet" "aksrandom" {

}
