locals {
  name_prefix = "${var.project_name}-${var.environment}"
  tags        = merge(var.tags, { "project" = var.project_name, "env" = var.environment })
}

module "rg" {
  source      = "./modules/resource_group"
  name        = "${local.name_prefix}-rg"
  location    = var.location
  tags        = local.tags
}

module "storage" {
  source              = "./modules/storage_account"
  name_prefix         = replace(local.name_prefix, "-", "")
  resource_group_name = module.rg.name
  location            = var.location
  tags                = local.tags
}

module "log_analytics" {
  source              = "./modules/log_analytics"
  name                = "${local.name_prefix}-law"
  resource_group_name = module.rg.name
  location            = var.location
  tags                = local.tags
}

module "app_insights" {
  source              = "./modules/app_insights"
  name                = "${local.name_prefix}-appi"
  resource_group_name = module.rg.name
  location            = var.location
  workspace_id        = module.log_analytics.id
  tags                = local.tags
}

module "key_vault" {
  count               = var.enable_key_vault ? 1 : 0
  source              = "./modules/key_vault"
  name                = "${local.name_prefix}-kv"
  resource_group_name = module.rg.name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = local.tags
}

module "function_app" {
  source                      = "./modules/function_app"
  name                        = "${local.name_prefix}-fa"
  resource_group_name         = module.rg.name
  location                    = var.location
  storage_account_name        = module.storage.name
  storage_account_access_key  = module.storage.primary_access_key
  application_insights_key    = module.app_insights.instrumentation_key
  tags                        = local.tags

  # Example app settings. You can add Key Vault references like:
  # APP_SECRET = @Microsoft.KeyVault(SecretUri=https://<kvname>.vault.azure.net/secrets/<secret-name>/<version>)
  app_settings = {
    "APP_ENV"                        = var.environment
    "FUNCTIONS_WORKER_RUNTIME"       = "python"
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "1"
    "WEBSITE_RUN_FROM_PACKAGE"       = "1"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = module.app_insights.instrumentation_key
  }
}

data "azurerm_client_config" "current" {}
