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
      version = "~> 3.54.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = var.resource_group.name
    storage_account_name = var.resource_names.terraform_state_storage.account_name
    container_name       = var.resource_names.terraform_state_storage.container_name
    key                  = "terraform.tfstate"
  }

  required_version = ">= 1.4.4"
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group.name
}
