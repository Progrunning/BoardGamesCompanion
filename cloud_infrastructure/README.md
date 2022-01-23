# Deploying bicep template

Follow the below instructions to deploy the `template.bicep` into Azure.

1. Ensure Azure CLI is installed on your machine - execute the `az version` command
2. Connect to Azure Account by executing `az login` command. Sign in using browser
3. List all the subscriptions `az account list` and copy the id of the one that you want to work with (usually a dev subscription)
4. Set the working subscription by executing `az account set --subscription <subscription_id>` command
5. Execute a *what-if* command on the bicep templat to test your changes `az deployment group what-if --resource-group bgc-test --template-file .\template.bicep --parameters .\paramteres.dev.json`

> NOTE: Replace the *what-if* comand with *create* to publish the template into Azure