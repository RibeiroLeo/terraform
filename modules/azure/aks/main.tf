locals {
  tags = merge(var.tags, {
    ManagedBy = "Terraform"
    Module    = "azure-aks"
  })
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
  tags                = local.tags
}

resource "azurerm_user_assigned_identity" "cluster" {
  name                = "id-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

resource "azurerm_role_assignment" "network" {
  scope                = var.subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.cluster.principal_id
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "aks-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = substr(replace(var.name, "_", "-"), 0, 45)
  kubernetes_version  = var.kubernetes_version
  sku_tier            = "Free"

  private_cluster_enabled           = var.private_cluster_enabled
  role_based_access_control_enabled = true
  local_account_disabled            = length(var.admin_group_object_ids) > 0
  oidc_issuer_enabled               = true
  workload_identity_enabled         = true
  image_cleaner_enabled             = true
  image_cleaner_interval_hours      = 168
  azure_policy_enabled              = true
  cost_analysis_enabled             = false
  node_os_upgrade_channel           = "NodeImage"
  automatic_upgrade_channel         = "patch"

  node_provisioning_profile {
    mode = "Manual"
  }

  default_node_pool {
    name                         = "system"
    vm_size                      = var.vm_size
    vnet_subnet_id               = var.subnet_id
    auto_scaling_enabled         = true
    min_count                    = var.min_count
    max_count                    = var.max_count
    only_critical_addons_enabled = true
    os_disk_size_gb              = 64
    type                         = "VirtualMachineScaleSets"
    node_public_ip_enabled       = false
    zones                        = ["1", "2", "3"]

    upgrade_settings {
      max_surge = "33%"
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.cluster.id]
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = length(var.admin_group_object_ids) > 0 ? [1] : []
    content {
      azure_rbac_enabled     = true
      admin_group_object_ids = var.admin_group_object_ids
    }
  }

  oms_agent {
    log_analytics_workspace_id      = azurerm_log_analytics_workspace.this.id
    msi_auth_for_monitoring_enabled = true
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "azure"
    load_balancer_sku   = "standard"
    outbound_type       = "loadBalancer"
    pod_cidr            = "10.244.0.0/16"
    service_cidr        = "10.2.0.0/16"
    dns_service_ip      = "10.2.0.10"
  }

  depends_on = [azurerm_role_assignment.network]
  tags       = local.tags

  lifecycle {
    ignore_changes = [default_node_pool[0].node_count]
  }
}
