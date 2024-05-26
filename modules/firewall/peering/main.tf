resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "hub-to-spoke"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.firewall_vnet_name
  remote_virtual_network_id    = var.machinelearning_vnet_id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "spoke-to-hub"
  resource_group_name          = var.machilelearning_rg_name
  virtual_network_name         = var.machinelearning_vnet_name
  remote_virtual_network_id    = var.firewall_vnet_id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}
