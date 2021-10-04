
resource "azurerm_storage_account" "tfstate" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true

  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_container" "tfstate_container" {
  depends_on = [
    azurerm_storage_account.tfstate
  ]
  name                  = var.storage_container_name
  storage_account_name  = resource.azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}