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
    container_registry = object({
      name = string
      sku  = string
    })
    analytics_workspace = object({
      name              = string
      retention_in_days = number
      sku               = string
    })
    container_app_environemnt = object({
      name     = string
      location = string
    })
    container_apps = object({
      search_service = object({
        name     = string
        app_name = string
      })
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
  }

  required_version = ">= 1.4.4"
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group.name
}

resource "azurerm_container_registry" "acr" {
  name                = var.resource_names.container_registry.name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  sku                 = var.resource_names.container_registry.sku
}

resource "azurerm_log_analytics_workspace" "log" {
  name                = var.resource_names.analytics_workspace.name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  sku                 = var.resource_names.analytics_workspace.sku
  retention_in_days   = var.resource_names.analytics_workspace.retention_in_days
}

resource "azurerm_container_app_environment" "cae" {
  name                       = var.resource_names.container_app_environemnt.name
  resource_group_name        = var.resource_group.name
  location                   = var.resource_names.container_app_environemnt.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
}

resource "azurerm_container_app" "search_service_ca" {
  name                         = var.resource_names.container_apps.search_service.name
  container_app_environment_id = azurerm_container_app_environment.cae.id
  resource_group_name          = var.resource_group.name
  revision_mode                = "Single"

  template {
    container {
      name   = var.resource_names.container_apps.search_service.app_name
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}
