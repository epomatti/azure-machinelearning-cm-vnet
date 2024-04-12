locals {
  vnet_address_space = "10.0.0.0/16"
}

resource "azurerm_virtual_network" "default" {
  name                = "vnet-${var.workload}"
  address_space       = [local.vnet_address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "bastion" {
  name                 = "bastion"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "private-endpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.20.0/24"]
}

resource "azurerm_subnet" "training" {
  name                 = "training"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.40.0/24"]
}

resource "azurerm_subnet" "scoring" {
  name                 = "scoring"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.90.0/24"]
}

resource "azurerm_subnet" "scoring_aks_api" {
  name                 = "scoring-aks-api"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.95.0/24"]
}

resource "azurerm_subnet" "proxy" {
  name                 = "proxy"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.200.0/24"]
}

### Default NSG ###
resource "azurerm_network_security_group" "default" {
  name                = "nsg-default"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "private_endpoints" {
  subnet_id                 = azurerm_subnet.private_endpoints.id
  network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_subnet_network_security_group_association" "scoring" {
  subnet_id                 = azurerm_subnet.scoring.id
  network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_subnet_network_security_group_association" "scoring_aks_api" {
  subnet_id                 = azurerm_subnet.scoring_aks_api.id
  network_security_group_id = azurerm_network_security_group.default.id
}

### Bastion NSG ###
resource "azurerm_network_security_group" "bastion" {
  name                = "nsg-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "bastion" {
  subnet_id                 = azurerm_subnet.bastion.id
  network_security_group_id = azurerm_network_security_group.bastion.id
}

resource "azurerm_network_security_rule" "allow_inbound_rdp_bastion" {
  name                        = "AllowInboundRDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "${var.allowed_ip_address}/32"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.bastion.name
}

# TODO: Add outbound restrictions

### Proxy NSG ###
resource "azurerm_network_security_group" "proxy" {
  name                = "nsg-proxy"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "proxy" {
  subnet_id                 = azurerm_subnet.proxy.id
  network_security_group_id = azurerm_network_security_group.proxy.id
}

resource "azurerm_network_security_rule" "allow_inbound_ssh_proxy" {
  name                        = "AllowInboundSSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "${var.allowed_ip_address}/32"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.proxy.name
}

### Training NSG ###
resource "azurerm_network_security_group" "training" {
  name                = "nsg-training"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "training" {
  subnet_id                 = azurerm_subnet.training.id
  network_security_group_id = azurerm_network_security_group.training.id
}

resource "azurerm_network_security_rule" "allow_vnet_outbound" {
  name                        = "AllowVNET"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = var.training_nsg_destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.training.name
}

resource "azurerm_network_security_rule" "block_internet_outbound" {
  name                        = "DenyInternetOutbound"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.training.name
}
