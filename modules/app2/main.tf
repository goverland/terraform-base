terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 3.103.1"
    }
  }
}

resource "azurerm_resource_group" "rg" {
    name     = "test-terraform-dev-rg"
    location = "norwayeast"
}

resource "azurerm_storage_account" "storage" {
        name = substr(format("%s%s", replace(var.subscription_group_name, "-", ""), "storageapp2go"), 0, 24)
    resource_group_name      = azurerm_resource_group.rg.name
    location                 = azurerm_resource_group.rg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
    enable_https_traffic_only = true
}

resource "azurerm_storage_container" "container" {
  for_each = toset(var.customer_names)
  name                  = each.value
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}
