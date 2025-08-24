resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

resource "azurerm_storage_account" "this" {
  name                     = substr(lower(replace("${var.name_prefix}${random_integer.rand.result}", "-", "")), 0, 24)
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled = true
  }

  tags = var.tags
}
