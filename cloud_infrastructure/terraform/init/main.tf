# Init module to create the resource group and the storage account to store terraform's state.
# Manually provision this module, before provisioning the rest of the environment's resources

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  nullable = false
}

variable "resource_names" {
  type = object({
    storage_account = object({
      name                     = string
      terraform_container_name = string
    })
  })
  nullable = false
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
  name     = var.resource_group.name
  location = var.resource_group.location
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.resource_names.storage_account.name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storage_container" {
  name                  = var.resource_names.storage_account.terraform_container_name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}
