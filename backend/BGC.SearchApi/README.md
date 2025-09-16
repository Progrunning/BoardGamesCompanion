# Overview

The Search API is a RESTful service that provides endpoints for searching and retrieving board game data. It is built using ASP.NET Core and leverages Azure services for data storage and search capabilities.

# Local debugging

Use `Search API` configuration profil to run the API locally.

## Key Vault

By default Azure Key Vault is not used when running the API locally. Instead, the secrets are read from the `appsettings.Development.json` file or user secrets (i.e. `dotnet user secrets`).


# Investigating issues in production

Look through the Azure Application Insights logs for the Search API instance. The logs by default are set to Warning level but can be changed to Information or Debug for more detailed logs by updating `Serilog__MinimumLevel__Default` variable in the Environments Variables in the Containers section in Azure [dev instance](https://portal.azure.com/#@boardgamescompanion.onmicrosoft.com/resource/subscriptions/0b0b0e44-f48a-4f5b-9ee0-6bf6c571e58a/resourceGroups/bgc-dev-rg/providers/Microsoft.App/containerApps/bgc-search-service-dev-ca/containers).

Additionally viewing logs of the currently running revision can be very helpful.

## Reproducing issues in dev

The dev instance of the Search API is running in Azure Container Apps. The easiest way to reproduce issues is to deploy a new revision of the dev instance with the latest code changes and test against that.