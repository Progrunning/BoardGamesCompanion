# Provisioning infrastructure

This project infrastructure will be provisioned in Azure using Terraform scripts.

## Prerequisite

See details in [this guideline](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build#prerequisites) for what will be required to provision Azure infrastructure using terraform 

### Terraform

Install terraform on your local device by following the steps from this document https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli#install-terraform.

## Steps

### Init

When setting up the infrastructure environment for the firs time, provisioning of a resource group and a storage account to keep terraform's state is done manually by executing terraform scripts from the `cloud_infrastructure/terraform/init` directory.

The process of provisioning is the same as described in the below section but it's done from the local machine. The `terraform.tfstate` is not preserved as this initialization will be done only once.

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
3. Execute `terraform validate` to validate the code
4. Execute `terraform plan` to preview the changes that Terraform plans to make to your infrastructure
> IMPORTANT: This is the last step before making changes to the actual infrastructure in the cloud
1. Execute `terraform apply` to apply the configuration to the cloud

> NOTE: This is when terraform writes data into the `terraform.tfstate` file
> NOTE2: provide `-auto-approve` parameter to auto approve the changes
> NOTE3: to provide variables from a `tfvars` file use the `-var-file="testing.tfvars"` parameter