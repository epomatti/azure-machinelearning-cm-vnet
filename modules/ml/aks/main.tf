# resource "azurerm_private_dns_zone" "default" {
#   name                = "private.${var.location}.azmk8s.io"
#   resource_group_name = var.resource_group_name
# }

resource "azurerm_kubernetes_cluster" "default" {
  name                                = "aks-${var.workload}"
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  node_resource_group                 = "rg-aks-${var.workload}"
  dns_prefix_private_cluster          = "private"
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = false
  sku_tier                            = "Free"

  default_node_pool {
    name                  = "default"
    node_count            = var.node_count
    vm_size               = var.vm_size
    vnet_subnet_id        = var.scoring_subnet_id
    enable_node_public_ip = false
  }

  network_profile {
    network_plugin    = "kubenet"
    network_policy    = null # TODO: Implement Calico
    load_balancer_sku = "standard"

    # This will not integrate with the existing VNET
    # however, it must not overlap with an existing Subnet
    service_cidr   = "192.168.90.0/24"
    dns_service_ip = "192.168.90.10"
  }

  # TODO: Implement this
  api_server_access_profile {
    vnet_integration_enabled = false
    # subnet_id                = var.scoring_aks_api_subnet_id
  }

  identity {
    # AML doesn't support User Assigned Identities
    type = "SystemAssigned"
  }
}

resource "azurerm_machine_learning_inference_cluster" "default" {
  name                  = "cluster001"
  location              = var.location
  cluster_purpose       = "DevTest"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.default.id
  description           = "Inference cluster with Terraform"

  machine_learning_workspace_id = var.machine_learning_workspace_id
}

resource "azurerm_role_assignment" "acr" {
  principal_id                     = azurerm_kubernetes_cluster.default.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.container_registry_id
  skip_service_principal_aad_check = true
}
