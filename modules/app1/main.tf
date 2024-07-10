terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.103.1"
    }
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "test-terraform-dev-rg"
  location = "norwayeast"
}

resource "azurerm_storage_account" "storage" {
  name                      = substr(format("%s%s", replace(var.subscription_name, "-", ""), "storageapp1go"), 0, 24)
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}

resource "azurerm_storage_container" "container" {
  for_each              = toset(var.customer_names)
  name                  = each.value
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "appconf_dataowner" {
  scope                = azurerm_app_configuration.appconf.id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_app_configuration_key" "app1_config_key" {
  configuration_store_id = var.shared_app_config_id
  key                    = "app1-conf-key1"
  label                  = "somelabel"
  value                  = "a test"

  depends_on = [
    azurerm_app_configuration.shared_app_config,
    azurerm_role_assignment.appconf_dataowner
  ]
}

