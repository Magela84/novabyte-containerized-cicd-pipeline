variable "location" {
  description = "Azure region where all resources will be deployed"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Environment name used for tagging and naming"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name used for tagging and naming"
  type        = string
  default     = "novabyte"
}

variable "owner" {
  description = "Owner of these resources"
  type        = string
  default     = "Magela84"
}

variable "acr_sku" {
  description = "Azure Container Registry SKU"
  type        = string
  default     = "Basic"
  # Basic  = cheapest — good for dev and learning
  # Standard = production workloads
  # Premium  = geo-replication and private endpoints
}

variable "container_app_cpu" {
  description = "CPU allocated to each container instance"
  type        = number
  default     = 0.25
  # 0.25 = quarter of a CPU core — minimum and cheapest
}

variable "container_app_memory" {
  description = "Memory allocated to each container instance"
  type        = string
  default     = "0.5Gi"
  # 0.5Gi = 512MB — minimum for Basic workloads
}

variable "min_replicas" {
  description = "Minimum number of container instances"
  type        = number
  default     = 0
  # 0 = scales to zero when no traffic — saves cost
}

variable "max_replicas" {
  description = "Maximum number of container instances"
  type        = number
  default     = 3
  # Auto-scales up to 3 under load
}
