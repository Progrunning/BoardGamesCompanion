# Overview

The Search API is a RESTful service that provides endpoints for searching and retrieving board game data. It is built using ASP.NET Core and leverages Azure services for data storage and search capabilities.

# Local debugging

Use `Search API` configuration profil to run the API locally.

## Key Vault

By default Azure Key Vault is not used when running the API locally. Instead, the secrets are read from the `appsettings.Development.json` file or user secrets (i.e. `dotnet user secrets`).
