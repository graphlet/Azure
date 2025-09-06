locals {
  name_prefix = "${var.project_name}-${var.environment}"
  tags        = merge(var.tags, { "project" = var.project_name, "env" = var.environment })
  workload_profile_name = "Consumption"
  workload_profile_type = "Consumption"
}

module "rg" {
  source      = "./modules/resource_group"
  name        = "${local.name_prefix}-rg"
  location    = var.location
  tags        = local.tags
}

module "log_analytics" {
  source              = "./modules/log_analytics"
  name                = "${local.name_prefix}-law"
  resource_group_name = module.rg.name
  location            = var.location
  tags                = local.tags
}
resource "random_string" "suffix" { 
  length = 5  
  special = false  
  upper = false 
  }

resource "azurerm_container_app_environment" "env" {
  name                       = "${local.name_prefix}-env"
  location                   = var.location
  resource_group_name        = module.rg.name
  log_analytics_workspace_id = module.log_analytics.id
  workload_profile {
     name                  = local.workload_profile_name
     workload_profile_type = local.workload_profile_type
  }
}

resource "azurerm_container_app" "app" {
  name                         = "${local.name_prefix}-app-${random_string.suffix.result}"
  resource_group_name          = module.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id

  revision_mode = "Single" 

  identity {
    type = "SystemAssigned"
  }

  ingress {
    external_enabled           = true
    target_port                = var.port
    transport                  = "auto" 
    allow_insecure_connections = false
    
    traffic_weight {
    latest_revision = true
    percentage  = var.traffic_to_latest
    }
  }

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = "app"
      image  = var.image
      cpu    = var.cpu
      memory = var.memory
    }
  }
}

resource "azurerm_container_registry" "acr" {
  name                = replace("${local.name_prefix}acr", "/[^a-z0-9]/", "")
  resource_group_name = module.rg.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_container_app.app.identity[0].principal_id
  depends_on           = [azurerm_container_app.app, azurerm_container_registry.acr]
}
