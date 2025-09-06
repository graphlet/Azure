terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.38"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "b81f97d2-f94e-4a23-9ae1-9a5444503212"
}
