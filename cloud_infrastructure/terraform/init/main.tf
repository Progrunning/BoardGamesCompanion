# Init module to create the resource group and the storage account to store terraform's state.
# Manually provision this module, before provisioning the rest of the environment's resources

variable "shared_resources" {
  type = object({
    resource_group = object({
      name     = string
      location = string
    })
    storage_account = object({
      name                     = string
      terraform_container_name = string
    })
    container_registry = object({
      name = string
      sku  = string
    })
    apim = object({
      name = string
      sku  = string
    })
  })
}


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.54.0"
    }
  }

  required_version = ">= 1.4.4"
}

provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "rg" {
  name     = var.shared_resources.resource_group.name
  location = var.shared_resources.resource_group.location
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.shared_resources.storage_account.name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storage_container" {
  name                  = var.shared_resources.storage_account.terraform_container_name_dev
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "storage_container" {
  name                  = var.shared_resources.storage_account.terraform_container_name_prod
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_container_registry" "acr" {
  name                = var.shared_resources.container_registry.name
  resource_group_name = var.shared_resources.resource_group.name
  location            = var.shared_resources.resource_group.location
  sku                 = var.shared_resources.container_registry.sku
}

resource "azurerm_container_registry" "acr" {
  name                = var.shared_resources.container_registry.name
  resource_group_name = var.shared_resources.resource_group.name
  location            = var.shared_resources.resource_group.location
  sku                 = var.shared_resources.container_registry.sku
}

resource "azurerm_api_management" "apim" {
  name                = var.shared_resources.apim.name
  resource_group_name = var.shared_resources.resource_group.name
  location            = var.shared_resources.resource_group.location
  publisher_name      = "Progrunning"
  publisher_email     = "info@progrunning.net"

  sku_name = var.shared_resources.apim.sku
}
