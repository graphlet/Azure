variable "project_name" {
  description = "Project/name prefix for resources"
  type        = string
  default     = "azcontainer-ref"
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Deployment environment (dev|stg|prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westeurope"
}

variable "traffic_to_latest" { 
    type = number 
    default = 100 
}

variable "port" { 
    type = number  
    default = 8000 
}

variable "secrets" { 
    type = map(string) 
    default = {} 
}

variable "min_replicas" { 
    type = number  
    default = 1 
}

variable "max_replicas" { 
    type = number  
    default = 3 
}

variable "image" { 
    type = string 
    default = "tiangolo/uvicorn-gunicorn-fastapi:python3.9"
}

variable "memory" { 
    type = string  
    default = "1Gi"  
}

variable "cpu" { 
    type = number  
    default = 0.5 
}