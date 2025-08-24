variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }

variable "storage_account_name" { type = string }
variable "storage_account_access_key" {
  type      = string
  sensitive = true
}

variable "application_insights_key" {
  type      = string
  sensitive = true
}

variable "app_settings" {
  type        = map(string)
  default     = {}
  description = "Additional app settings, e.g., APP_ENV, KeyVault refs"
}

variable "tags" { type = map(string) }
