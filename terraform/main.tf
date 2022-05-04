terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "csgo" {
  name     = "csgo-vm"
  location = var.location
}

resource "azurerm_storage_account" "csgo" {
  name                = "csgosa"
  resource_group_name = azurerm_resource_group.csgo.name

  location                 = azurerm_resource_group.csgo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
      index_document = "index.html"
  }
}

resource "azurerm_storage_table" "csgo" {
  name                 = "csgostatus"
  storage_account_name = azurerm_storage_account.csgo.name
}

resource "azurerm_storage_table_entity" "csgo" {
  storage_account_name = azurerm_storage_account.csgo.name
  table_name           = azurerm_storage_table.csgo.name

  partition_key = "server"
  row_key       = "1"

  entity = {
    status = "idle"
  }
}

# resource "azurerm_service_plan" "csgo" {
#   name                = "csgo-app-service-plan"
#   resource_group_name = azurerm_resource_group.csgo.name
#   location            = azurerm_resource_group.csgo.location
#   os_type             = "Linux"
#   sku_name            = "Y1"
# }

# resource "azurerm_linux_function_app" "csgo" {
#   name                = "csgo-linux-function-app"
#   resource_group_name = azurerm_resource_group.csgo.name
#   location            = azurerm_resource_group.csgo.location

#   storage_account_name = azurerm_storage_account.csgo.name
#   service_plan_id      = azurerm_service_plan.csgo.id

#   site_config {}
# }