terraform {
    required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.103.1"
    }
  }
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "rg" {
    name     = "test-terraform-dev-rg"
    location = "norwayeast"
}

resource "azurerm_storage_account" "storage" {
    name                     = "testterraformdevsa"
    resource_group_name      = azurerm_resource_group.rg.name
    location                 = azurerm_resource_group.rg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
    enable_https_traffic_only = true
}

resource "azurerm_storage_container" "container" {
  name                  = "test-kommune"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "data_import" {
  name                   = "Data Import/placeholder.txt"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "./placeholder.txt"
}

resource "azurerm_storage_blob" "data_scratch" {
  name                   = "Data Scratch/placeholder.txt"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "./placeholder.txt"
}

resource "azurerm_storage_blob" "data_failed" {
  name                   = "Data Failed/placeholder.txt"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "./placeholder.txt"
}
