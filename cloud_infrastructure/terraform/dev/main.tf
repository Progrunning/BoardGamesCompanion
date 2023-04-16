variable "tf_state_storage_account_name" {
  type     = string
  nullable = false
}

variable "tf_state_storage_container_name" {
  type     = string
  nullable = false
}

variable "resource_group_name" {
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
  backend "azurerm" {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.tf_state_storage_account_name
    container_name       = var.tf_state_storage_container_name
    key                  = "terraform.tfstate"
  }

  required_version = ">= 1.4.4"
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = local.location
}
