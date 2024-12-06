# Azure Storage

Notes made by using this [Azure documentation ](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=terraform#2-configure-remote-state-storage-account).


## First steps
In order to use it first a storage account needs to be [created](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=terraform#2-configure-remote-state-storage-account). 

Here is the [code sample](create-remote-storage.tf)

To run this file

```
az login
```

Then init a new terraform project

```
terraform init
```

Then use command **terraform plan** to view all the steps that will be applied or **terraform apply** directly to create a new resource group with a storage account and a blob container with your Terraform script. More explanation regarding this commands [here](../get_started_terraform/README.md).

Once this is done, the next is to configure the backend stage for that we need one of the following approaches:

### 1. Azure CLI
```azurecli-interactive
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
export ARM_ACCESS_KEY=$ACCOUNT_KEY
```

### 2. PowerShell

```azurepowershell
$ACCOUNT_KEY=(Get-AzStorageAccountKey -ResourceGroupName $RESOURCE_GROUP_NAME -Name $STORAGE_ACCOUNT_NAME)[0].value
$env:ARM_ACCESS_KEY=$ACCOUNT_KEY
```

Key points:

To further protect the Azure Storage account access key, store it in Azure Key Vault. For more information on Azure Key Vault, see the Azure Key Vault documentation.

For this example (Powershell locally) used this command:

```
$ACCOUNT_KEY = (az storage account keys list `
    --resource-group $RESOURCE-GROUP `
    --account-name $RESOURCE-NAME `
    --query "[0].value" `
    -o tsv)
```
To validate the change: 
```
Write-Output $ACCOUNT_KEY
```

To save it as an env variable
```
$env:ARM_ACCESS_KEY = $ACCOUNT_KEY
```
> **Note**: <mark>ARM_ACCESS_KEY</mark> is 

The next step is to create a **[backend configuration block](backend/backend.tf)**. 

While runing **terraform init** if you get this error:

```
│ Error: Failed to get existing workspaces: containers.Client#ListBlobs: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="KeyBasedAuthenticationNotPermitted" Message="Key based authentication is not permitted on this storage account.
```

Try this enabling it using this Azure CLI script
```
az storage account update \
    --name <storage-account> \
    --resource-group <resource-group> \
    --allow-shared-key-access true
```
Azure Storage blobs are automatically locked before any operation that writes state. This pattern prevents concurrent state operations, which can cause corruption.