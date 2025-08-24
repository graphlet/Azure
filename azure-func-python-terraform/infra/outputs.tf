output "function_app_name" {
  value = module.function_app.name
}

output "function_app_default_hostname" {
  value = module.function_app.default_hostname
}

output "key_vault_name" {
  value       = try(module.key_vault[0].name, null)
  description = "Key Vault name (if enabled)"
}
