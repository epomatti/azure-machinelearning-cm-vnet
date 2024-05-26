resource "azurerm_route_table" "default" {
  name                          = "rt-all-to-hub"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = false

  route {
    name                   = "route-all-to-hub"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip
  }
}

resource "azurerm_subnet_route_table_association" "training" {
  subnet_id      = var.training_subnet_id
  route_table_id = azurerm_route_table.default.id
}

# resource "azurerm_subnet_route_table_association" "bastion" {
#   subnet_id      = var.bastion_subnet_id
#   route_table_id = azurerm_route_table.default.id
# }
