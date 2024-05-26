# resource "azurerm_network_security_rule" "firewall" {
#   name                        = "AllowFirewallPeering"
#   priority                    = 3000
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = var.training_nsg_source_address_prefix
#   destination_address_prefix  = var.training_nsg_destination_address_prefix
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.training.name
# }
