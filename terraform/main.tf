# ============================================================
# main.tf — NovaByte Containerized CI/CD Pipeline
# ============================================================

locals {
  name_prefix = "${var.project}-${var.environment}"

  common_tags = {
    environment = var.environment
    project     = var.project
    managed_by  = "terraform"
    owner       = var.owner
  }
}

# ── Resource Group ───────────────────────────────────────────

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.name_prefix}"
  location = var.location
  tags     = local.common_tags
}

# ── Azure Container Registry ─────────────────────────────────
# Stores all Docker images for NovaByte applications

resource "azurerm_container_registry" "main" {
  name                = "acr${var.project}${var.environment}001"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.acr_sku
  admin_enabled       = true
  tags                = local.common_tags
}

# ── Managed Identity ──────────────────────────────────────────
# Container Apps use this to pull images from ACR
# No passwords needed anywhere in the pipeline

resource "azurerm_user_assigned_identity" "main" {
  name                = "id-${local.name_prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
}

# ── RBAC — Identity can pull images from ACR ─────────────────

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.main.principal_id
}

# ── Log Analytics Workspace ───────────────────────────────────
# Container Apps require this for logging

resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${local.name_prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.common_tags
}

# ── Container Apps Environment ────────────────────────────────
# The shared infrastructure that Container Apps run inside

resource "azurerm_container_app_environment" "main" {
  name                       = "cae-${local.name_prefix}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  tags                       = local.common_tags
}

# ── Container App ─────────────────────────────────────────────
# Runs the NovaByte application container

resource "azurerm_container_app" "main" {
  name                         = "ca-${local.name_prefix}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"
  tags                         = local.common_tags

  # Use Managed Identity to pull from ACR
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.main.id]
  }

  # Connect to ACR using Managed Identity
  registry {
    server   = azurerm_container_registry.main.login_server
    identity = azurerm_user_assigned_identity.main.id
  }

  template {
    container {
      name   = "novabyte-app"
      image  = "${azurerm_container_registry.main.login_server}/novabyte-app:latest"
      cpu    = var.container_app_cpu
      memory = var.container_app_memory

      env {
        name  = "ENVIRONMENT"
        value = var.environment
      }

      env {
        name  = "PROJECT"
        value = var.project
      }
    }

    min_replicas = var.min_replicas
    max_replicas = var.max_replicas
  }

  # Allow public HTTPS traffic
  ingress {
    external_enabled = true
    target_port      = 8080
    transport        = "http"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  depends_on = [azurerm_role_assignment.acr_pull]
}
