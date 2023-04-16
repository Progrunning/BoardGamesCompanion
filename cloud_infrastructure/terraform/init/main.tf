# Init module to create the resource group and the storage account to store terraform's state.
# Provision this module, manually, before provisioning the environment's resources

variable "project_name" {
  type     = string
  nullable = false
}

variable "resource_group_name" {
  type     = string
  nullable = false
}

variable "tf_state_storage_account_name" {
  type     = string
  nullable = false
}

variable "tf_state_storage_container_name" {
  type     = string
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
  name     = "${var.project_name}_rg"
  location = var.location
}

resource "azurerm_storage_account" "tfstate" {
  name                     = var.tf_state_storage_account_name
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = false
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.tf_state_storage_container_name
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}
