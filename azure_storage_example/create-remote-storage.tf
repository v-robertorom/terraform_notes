terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~>3.0"
    }
  }
}

provider "azurerm" {
    features {}
}

# random_string (Resource)
# Generates a random permutation of alphanumeric characters and optionally special characters.

# Schema
# ---------------------
# Required parameters
# length The length of the string desired. 

# Optional parameters
# special (Boolean) Include special characters in the result. These are !@#$%&*()-_=+[]{}<>:?. Default value is true.
# upper (Boolean) Include uppercase alphabet characters in the result. Default value is true.
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string

# Read only (used when calling the resource)
# id (String) The generated random string.
# result (String) The generated random string.

resource "random_string" "resource_code" {
    length = 5
    special = false
    upper = false
}

# azurerm_resource_group

# Arguments reference
# ---------------------
# The following arguments are supported:

# location - (Required) The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created.

# name - (Required) The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created.

resource "azurerm_resource_group" "tfstate" {
    name = "tfstate"
    location = "East US"
}


# result is the read only property for random_string resource after generating the random string
resource "azurerm_storage_account" "tfstate" {
    name = "tfstate${random_string.resource_code.result}"
    resource_group_name = azurerm_resource_group.tfstate.name
    location = azurerm_resource_group.tfstate.location
    account_tier = "Standard"
    account_replication_type = "LRS"
    allow_nested_items_to_be_public = false

    tags = { 
        environment = "staging"
    }
}

resource "azurerm_storage_container" "tfstate" {
    name = "tfstate"
    storage_account_name = azurerm_storage_account.tfstate.name
    container_access_type = "private"
}