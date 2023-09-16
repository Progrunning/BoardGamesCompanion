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
    application_insights = object({
      search_service = object({
        name = string
      })
    })
    cache_service_bus = object({
      namespace = object({
        name = string
        sku  = string
      })
      queue = object({
        name               = string
        send_policy_name   = string
        listen_policy_name = string
      })
    })
    function = object({
      name = string
      service_plan = object({
        name = string
      })
    })
    key_vault = object({
      name = string
      sku  = string
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

  backend "azurerm" {}

  required_version = ">= 1.4.4"
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
}

###
### Storage
###

resource "azurerm_storage_account" "sa" {
  name                     = var.resources.storage_account.name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

###
### Logs
###

resource "azurerm_log_analytics_workspace" "log" {
  name                = var.resources.analytics_workspace.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.resources.analytics_workspace.sku
  retention_in_days   = var.resources.analytics_workspace.retention_in_days
}

resource "azurerm_application_insights" "search_service_appi" {
  name                = var.resources.application_insights.search_service.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  workspace_id        = azurerm_log_analytics_workspace.log.id
  application_type    = "web"
}

###
### Container Apps
###

resource "azurerm_container_app_environment" "cae" {
  name                       = var.resources.container_app_environemnt.name
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = var.resources.container_app_environemnt.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
}

resource "azurerm_container_app" "search_service_ca" {
  name                         = var.resources.container_apps.search_service.name
  container_app_environment_id = azurerm_container_app_environment.cae.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = var.resources.container_apps.search_service.app_name
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  ingress {
    external_enabled = true
    target_port      = 80
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  secret {
    name  = "appi-con-string"
    value = azurerm_application_insights.search_service_appi.connection_string
  }

  lifecycle {
    ignore_changes = [
      template[0].container[0].image,
      template[0].container[0].env,
      ingress,
      secret,
      registry,
    ]
  }
}

###
### Service Bus
###

resource "azurerm_servicebus_namespace" "sbns" {
  name                = var.resources.cache_service_bus.namespace.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.resources.cache_service_bus.namespace.sku
}

resource "azurerm_servicebus_queue" "sbq" {
  name         = var.resources.cache_service_bus.queue.name
  namespace_id = azurerm_servicebus_namespace.sbns.id
}

resource "azurerm_servicebus_queue_authorization_rule" "sbq_send_policy" {
  name     = var.resources.cache_service_bus.queue.send_policy_name
  queue_id = azurerm_servicebus_queue.sbq.id

  listen = false
  send   = true
  manage = false
}

resource "azurerm_servicebus_queue_authorization_rule" "sbq_listen_policy" {
  name     = var.resources.cache_service_bus.queue.listen_policy_name
  queue_id = azurerm_servicebus_queue.sbq.id

  listen = true
  send   = false
  manage = false
}

###
### Functions
###

resource "azurerm_service_plan" "asp" {
  name                = var.resources.function.service_plan.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "func" {
  name                = var.resources.function.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  service_plan_id            = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      dotnet_version              = "7.0"
      use_dotnet_isolated_runtime = true
    }
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.search_service_appi.instrumentation_key
    "CacheQueueName"                 = var.resources.cache_service_bus.queue.name
    "CacheQueueConnectionString"     = azurerm_servicebus_queue_authorization_rule.sbq_listen_policy.primary_connection_string
  }
}

###
### Key Vault
###

resource "azurerm_key_vault" "kv" {
  name                       = var.resources.key_vault.name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  enable_rbac_authorization  = false


  sku_name = var.resources.key_vault.sku

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Set",
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_container_app.search_service_ca.identity.0.principal_id

    secret_permissions = [
      "Get",
      "List",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Set",
    ]
  }
}

resource "azurerm_key_vault_secret" "kv_queue_send_connection_string" {
  name         = "AppSettings--CacheSettings--SendConnectionString"
  value        = azurerm_servicebus_queue_authorization_rule.sbq_send_policy.primary_connection_string
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "kv_queue_send_name" {
  name         = "AppSettings--CacheSettings--QueueName"
  value        = var.resources.cache_service_bus.queue.name
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "kv_application_insights_connection_string" {
  name         = "ApplicationInsights--ConnectionString"
  value        = azurerm_application_insights.search_service_appi.connection_string
  key_vault_id = azurerm_key_vault.kv.id
}

