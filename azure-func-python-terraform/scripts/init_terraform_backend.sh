#!/usr/bin/env bash
# Helper to create a remote backend (Storage) for Terraform state.
# Usage: ./scripts/init_terraform_backend.sh <resource_group> <location> <storage_name> <container_name>
set -euo pipefail

RG=${1:-tfstate-rg}
LOCATION=${2:-westeurope}
STG=${3:-tfstate$RANDOM$RANDOM}
CONTAINER=${4:-tfstate}

az group create -n "$RG" -l "$LOCATION"
az storage account create -g "$RG" -n "$STG" -l "$LOCATION" --sku Standard_LRS --encryption-services blob
KEY=$(az storage account keys list -g "$RG" -n "$STG" --query "[0].value" -o tsv)
az storage container create --name "$CONTAINER" --account-name "$STG" --account-key "$KEY"

cat <<EOF

Add this to infra/backend.tf (replace placeholders):

terraform {
  backend "azurerm" {
    resource_group_name  = "$RG"
    storage_account_name = "$STG"
    container_name       = "$CONTAINER"
    key                  = "terraform.tfstate"
  }
}
EOF
