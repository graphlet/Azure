# Configure a remote backend for state (recommended).
# Run scripts/init_terraform_backend.sh to create a storage account/container,
# then update these values and run `terraform init -reconfigure`.
#
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "tfstate-rg"
#     storage_account_name = "mystate123"
#     container_name       = "tfstate"
#     key                  = "terraform.tfstate"
#   }
# }
