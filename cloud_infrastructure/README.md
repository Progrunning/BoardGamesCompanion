# Provisioning infrastructure

This project infrastructure will be provisioned in Azure using Terraform scripts.

## Prerequisite

See details in [this guideline](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build#prerequisites) for what will be required to provision Azure infrastructure using terraform 

### Terraform

Install terraform on your local device by following the steps from this document https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli#install-terraform.

## Steps

### Init

When setting up the infrastructure environment for the firs time, provisioning of a resource group and a storage account to keep terraform's state is done manually by executing terraform scripts from the `cloud_infrastructure/terraform/shared` directory.

The process of provisioning is the same as described in the below section but it's done from the local machine. The `terraform.tfstate` is not preserved as this initialization will be done only once.

In case of an update to the cloud resources it could be that the `terraform.tfstate` will not be present on the local machine, which will require updating the state from the cloud. This can be done by executing `import` commands. For example, to import `bgc-shared-rg` to the local state one would need to execute the following command:

`terraform import azurerm_resource_group.rg /subscriptions/2b318413-397e-40dc-b433-7aeee9e6f546/resourceGroups/bgc-shared-rg`

> NOTE: The ID part of the command can be found in the error messages from the `terraform apply` command

### Authenticate using the Azure CLI

https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build#authenticate-using-the-azure-cli

1. Connect to Azure Account by executing `az login` command. Sign in using browser
2. List all the subscriptions `az account list` and copy the id of the one that you want to work with (usually a dev subscription)
3. Set the working subscription by executing `az account set --subscription <subscription_id>` command
4. <TODO>


### Provisioninig

More details on the below commands can be found here https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build#write-configuration

1. Exceute `terraform fmt` to keep the files consistently formatter
2. Exceute `terraform init` to initialize terraform and start working with your code as infrastructure

> NOTE: When testing locally, ensure that you're connected to the Azure (using Azure CLI), have selected the correct subscription, your command line tool is set to the directory with the terraform file and then add execute the following `terraform init -backend-config=".\backend.conf"`.

3. Execute `terraform validate` to validate the code
4. Execute `terraform plan` to preview the changes that Terraform plans to make to your infrastructure
> IMPORTANT: This is the last step before making changes to the actual infrastructure in the cloud
5. Execute `terraform apply` to apply the configuration to the cloud

> NOTE: This is when terraform writes data into the `terraform.tfstate` file
> NOTE2: provide `-auto-approve` parameter to auto approve the changes
> NOTE3: to provide variables from a `tfvars` file use the `-var-file="testing.tfvars"` parameter

# Azure Resources

## Application Insights

### Purging data

Application insights were provisioned initially with sampling rate percentage of 100%, which caused high increase in stored data and resulted in increased costs. In order to reduce these costs retention period and sampling rate has been drastically reduced. However the existing collected data is causing the cost of the service to be higher than expected.

In order to reduce the cost there is a REST API to purge Application Insights ([docs](https://learn.microsoft.com/en-us/rest/api/application-insights/components/purge?tabs=HTTP)). The below are examples of POST requests executed on the 24/09/2023

`curl -X POST https://management.azure.com/subscriptions/637f5988-c385-408a-9b44-61b1c72f6b36/resourceGroups/bgc-prod-rg/providers/Microsoft.OperationalInsights/workspaces/bgc-prod-log/purge?api-version=2020-08-01 -H "Content-Type: application/json" -H "Authorization: Bearer <access_token>" -d '{ "table": "AppTraces", "filters": [ { "column": "TimeGenerated", "operator": ">", "value": "2023-07-10T00:00:00" } ] }'`

```json
{
  "table": "AppTraces", 
  "filters": [
    {
      "column": "TimeGenerated",
      "operator": ">",
      "value": "2023-07-10T00:00:00"
    }
  ]
}
```

> NOTE: In order to retrieve the accessToken for the header please execute `az account get-access`
> NOTE: The above was repeated additionally for `AppPerformanceCounters`, `AppExceptions`,  `AppDependencies` and `AppMetrics` tables.

If you want to verify the status of the operation make sure to make a note of the operation id returned from the above and use the blow request

`curl -X GET https://management.azure.com/subscriptions/637f5988-c385-408a-9b44-61b1c72f6b36/resourceGroups/bgc-prod-rg/providers/Microsoft.OperationalInsights/workspaces/bgc-prod-log/operations/purge-61a60a0d-3054-40a7-9319-3f78b8834522?api-version=2022-10-01 -H "Authorization: Bearer <access_token>"`

More details about executing these operations can be found in this [SO thread](https://stackoverflow.com/a/51218865/510627)