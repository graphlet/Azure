resource "azurerm_service_plan" "this" {
  name                = "${var.name}-plan"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "Y1"   # Consumption (Dynamic)
}

resource "azurerm_linux_function_app" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this.id

  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      python_version = "3.11"
    }
    app_command_line = ""
    ftps_state       = "Disabled"
    use_32_bit_worker = false
    minimum_tls_version = "1.2"
  }

  app_settings = merge({
    "FUNCTIONS_WORKER_RUNTIME"       = "python",
    "WEBSITE_RUN_FROM_PACKAGE"       = "1",
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "1",
    "APPINSIGHTS_INSTRUMENTATIONKEY" = var.application_insights_key
  }, var.app_settings)

  tags = var.tags

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
    ]
  }
}
