variable "project_name" {
  description = "Project/name prefix for resources"
  type        = string
  default     = "azfunc-ref"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westeurope"
}

variable "environment" {
  description = "Deployment environment (dev|stg|prod)"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}

variable "enable_key_vault" {
  description = "Whether to provision a Key Vault"
  type        = bool
  default     = true
}
