# Init module to create the resource group and the storage account to store terraform's state.
# Manually provision this module, before provisioning the rest of the environment's resources

variable "shared_resources" {
  type = object({
    resource_group = object({
      name     = string
      location = string
    })
    storage_account = object({
      name                          = string
      terraform_container_name_dev  = string
      terraform_container_name_prod = string
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
    application_insights = object({
      apim = object({
        name          = string
        insights_name = string
      })
      search_api_health_test = object({
        name = string
      })
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

  backend "local" {
    path = "./terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    api_management {
      recover_soft_deleted = true
    }
  }
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

resource "azurerm_storage_container" "storage_container_dev" {
  name                  = var.shared_resources.storage_account.terraform_container_name_dev
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "storage_container_prod" {
  name                  = var.shared_resources.storage_account.terraform_container_name_prod
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_container_registry" "acr" {
  name                = var.shared_resources.container_registry.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.shared_resources.container_registry.sku

  # MK Required for the deployment pipeline to push the image from shared ACR to container app
  admin_enabled = true
}

resource "azurerm_log_analytics_workspace" "log" {
  name                = var.shared_resources.analytics_workspace.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.shared_resources.analytics_workspace.sku
  retention_in_days   = var.shared_resources.analytics_workspace.retention_in_days
}

resource "azurerm_application_insights" "apim_appi" {
  name                = var.shared_resources.application_insights.apim.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  workspace_id        = azurerm_log_analytics_workspace.log.id
  application_type    = "other"
}

resource "azurerm_api_management" "apim" {
  name                = var.shared_resources.apim.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  publisher_name      = "Progrunning"
  publisher_email     = "info@progrunning.net"

  sku_name = var.shared_resources.apim.sku
}

resource "azurerm_api_management_logger" "apim-insights" {
  name                = var.shared_resources.application_insights.apim.insights_name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.rg.name
  resource_id         = azurerm_application_insights.apim_appi.id

  application_insights {
    instrumentation_key = azurerm_application_insights.apim_appi.instrumentation_key
  }
}
