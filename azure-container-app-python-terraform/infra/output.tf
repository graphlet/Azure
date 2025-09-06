output "resource_group_name" {
  value = module.rg.name
}

output "containerapp_environment_name" {
  value = azurerm_container_app_environment.env.name
}

output "containerapp_name" {
  value = azurerm_container_app.app.name
}

