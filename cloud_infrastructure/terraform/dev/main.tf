variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  nullable = false
}

variable "resources" {
  type = object({
    storage_account = object({
      name = string
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
    cache_service_bus = object({
      namespace = object({
        name = string
        sku  = string
      })
      queue = object({
        name = string
      })
    })
    cache_function = object({
      name     = string
      app_name = string
      service_plan = object({
        name = string
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

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.resources.storage_account.name
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_log_analytics_workspace" "log" {
  name                = var.resources.analytics_workspace.name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  sku                 = var.resources.analytics_workspace.sku
  retention_in_days   = var.resources.analytics_workspace.retention_in_days
}

resource "azurerm_container_app_environment" "cae" {
  name                       = var.resources.container_app_environemnt.name
  resource_group_name        = var.resource_group.name
  location                   = var.resources.container_app_environemnt.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
}

resource "azurerm_container_app" "search_service_ca" {
  name                         = var.resources.container_apps.search_service.name
  container_app_environment_id = azurerm_container_app_environment.cae.id
  resource_group_name          = var.resource_group.name
  revision_mode                = "Single"

  template {
    container {
      name   = var.resources.container_apps.search_service.app_name
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80
    traffic_weight {
      percentage = 100
    }
  }
}


resource "azurerm_servicebus_namespace" "sbns" {
  name                = var.resources.cache_service_bus.namespace.name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  sku                 = var.resources.cache_service_bus.namespace.sku
}

resource "azurerm_servicebus_queue" "sbq" {
  name         = var.resources.cache_service_bus.queue.name
  namespace_id = azurerm_servicebus_namespace.sbns.id
}

resource "azurerm_service_plan" "asp" {
  name                = var.resources.cache_function.service_plan.name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "func" {
  name                = var.resources.cache_function.name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  storage_account_name       = data.azurerm_storage_account.sa.name
  storage_account_access_key = data.azurerm_storage_account.sa.primary_access_key
  service_plan_id            = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      dotnet_version              = "7.0"
      use_dotnet_isolated_runtime = true
    }
  }
}

