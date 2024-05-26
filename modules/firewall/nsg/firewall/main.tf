resource "azurerm_network_security_group" "default" {
  name                = "nsg-${var.workload}-firewall"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "default" {
  subnet_id                 = var.firewall_subnet_id
  network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_network_security_rule" "allow_inbound_ssh_proxy" {
  name                        = "AllowAllFromMachineLearningTraining"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefixes     = var.training_nsg_source_address_prefixes
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.default.name
}
