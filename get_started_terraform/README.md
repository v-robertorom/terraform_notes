# Terraform notes

**AzureRM** provider is a plugin from Terraform

**AzAPI** used to access latest API features. Allows quicker integration with new services or to use workaround related to AzureRM limitations.

Both of them handle API operations behind scenes for you.

AzureRM is ideal for scenarios where you prioritize stability, want to minimize complexity, and don’t need the very latest features.

AzAPI, by contrast, provides a thinner layer, allowing for direct access to the latest Azure API versions as soon as they’re available. It’s well suited for scenarios where you need quick access to features before they are fully supported in AzureRM.

AzAPI Targeted Resource Updates: With the azapi_update_resource function, you can modify specific resource properties without upgrading the entire resource or provider.

Fine-Grained Control: AzAPI provides  resource versioning to allow for more control over the infrastructure configuration. User defined retryable errors, HTTP headers, URL control and resource replacement definitions are a few other ways AzAPI provides granular control.  

AzAPI is recommended for scenarios where early access to new Azure features is crucial, or when you need granular control over your infrastructure.

Choose AzureRM if you prioritize stability, simplicity, and automatic versioning. It’s best for teams that want to minimize the complexity of managing infrastructure and don’t need immediate access to new Azure features.

Choose AzAPI if you need cutting-edge access to the latest Azure APIs or need to customize resource configurations without waiting for AzureRM to be updated. It’s ideal for teams that require rapid innovation and fine-grained control over API versions.

Lowers the potential for human errors while deploying and managing infrastructure.
Deploys the same template multiple times to create identical development, test, and production environments.

Reduces the cost of development and test environments by creating them on-demand.

**azapi_update_resource** is used to add a feature not available at a resource created with AzureRM but want to be used with a preview feature that isn't currently supported

**preflight validation** is used to show errors in configuration AZapi.

**aztfmigrate** is a migration tool to change between providers.

Two key syntax constructs:

- **Arguments**: The context where the argument appears determines what value types are valid (for example, each resource type has a schema that defines the types of its arguments), but many arguments accept arbitrary expressions, which allow the value to either be specified literally or generated from other values programmatically. 
 ```
image_id = "abc123"
```

A block is a container for other content:

```
resource "aws_instance" "example" {
  ami = "abc123"

  network_interface {
    # ...
  }
}
```
## Get started

First we need to authenticate using for example [Azure CLI](https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure-with-microsoft-account).
```
az login
```
Then **terraform init**  is used to initialize a terraform project.

```
terraform init
```
**terraform init** command downloads the Azure modules required to create an Azure resource group.

```
terraform plan
```
**terraform plan** command creates an execution plan from the Terraform configuration files in the current directory. **Out** param is to save it in a path. Plan command is a preview of the changes you plan do.

If you run terraform plan without the -out=FILE option then it will create a speculative plan, which is a description of the effect of the plan but without any intent to actually apply it.

Example with **out** argument
```
terraform plan -out=tfplan
```

While running **terraform apply** without a plan, generates a new one in real time and it's shown to you to review it. And ask for your approval. **auto-approve** flag Skips interactive approval of the plan before applying. Terraform ignores this option when you pass a previously-saved plan file. 

Example using a plan
```
terraform apply tfplan
```

**terraform show** can be used to show the content of an existing plan.

>**Warning:** If you use -auto-approve, we recommend making sure that no one can change your infrastructure outside of your Terraform workflow. This minimizes the risk of unpredictable changes and configuration drift.

**terraform destroy** can be used to delete all resources and resource groups created by the terraform script. Also **terraform apply -destroy**.

You can also create a speculative destroy plan, to see what the effect of destroying would be, by running the following command:

```
terraform plan -destroy
```
You can use the **-target** option to destroy a particular resource and its dependencies:

More information:
<https://developer.hashicorp.com/terraform/cli/run>

# Why Terraform Resource Names Repeat

In Terraform, resource names often seem to repeat, as seen in the example below:

```
resource "azurerm_resource_group" "example" {
  name     = "example"
  location = "West Europe"
}
```

This repetition happens because of how Terraform structures and identifies resources. A Terraform `resource` block follows this general structure:

```
resource "<provider>_<type>" "<local_name>" {
  # Resource configuration
}
```

## Components

1. **`<provider>_<type>`** specifies the type of resource to create, combining:
   - **`provider`**: The cloud provider or system managing the resource (e.g., `azurerm` for Azure).
   - **`type`**: The specific resource type (e.g., `resource_group` for an Azure resource group).

   Example:

   ```
   azurerm_resource_group
   ```

2. **`<local_name>`** is a local identifier for the resource in your Terraform code. This name is arbitrary and allows you to reference the resource within your configuration.

   Example:

   ```
   "example"
   ```

3. **Resource properties** define the actual attributes of the resource, such as its `name`, `location`, and other required fields.

   Example:

   ```
   name = "example"
   ```

## Why Does the Name Repeat?

The repetition occurs because the **local name** and the **resource property** serve different purposes.

1. **Local Name (`example` in `azurerm_resource_group "example"`)**:
   This is a name used only within Terraform to reference the resource.

   Example:

   ```
   output "resource_group_name" {
     value = azurerm_resource_group.example.name
   }
   ```

2. **Resource Property (`name`)**:
   This is the actual name that will appear in the cloud provider (Azure, in this case).

   Example:

   ```
   name = "example"
   ```