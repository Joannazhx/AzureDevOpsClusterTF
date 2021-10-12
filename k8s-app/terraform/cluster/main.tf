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
    resource_group_name   = "servain-aks-storage-rg-dev"
    storage_account_name  = "ftstateaccount"
    container_name        = "tfstate"
    key                   = "servain.dev.terraform.tfstate"
  }  
}

# 2. Terraform Provider Block for AzureRM
provider "azurerm" {
  features {

  }
}

module "cluster-rg" {
  source                = "../module/resource_group/"
  resource_group_name   = var.resource_group_name
  location              = var.location
}

module "aks-cluster" {
  source                = "../module/aks"
  resource_group_name   = "${module.cluster-rg.resource_group_name}"
  location              = var.location
  cluster_name          = var.cluster_name
  environment           = var.environment
  acr_id                = "${module.acr.acr_id}"
}

module "acr" {
  source                = "../module/acr/"
  resource_group_name   = "${module.cluster-rg.resource_group_name}"
  acr_name              = var.acr_name 
}