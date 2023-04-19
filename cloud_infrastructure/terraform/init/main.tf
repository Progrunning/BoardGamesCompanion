# Init module to create the resource group and the storage account to store terraform's state.
# Provision this module, manually, before provisioning the environment's resources

variable "project" {
  type = object({
    name = string
  })
  nullable = false
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  nullable = false
}

variable "resource_names" {
  type = object({
    terraform_state_storage = object({
      account_name   = string
      container_name = string
    })
  })
  nullable = false
}


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
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

resource "azurerm_storage_account" "tfstate" {
  name                     = var.resource_names.terraform_state_storage.account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = false
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.resource_names.terraform_state_storage.container_name
  storage_account_name  = var.resource_names.terraform_state_storage.account_name
  container_access_type = "private"
}
