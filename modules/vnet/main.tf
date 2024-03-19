resource "azurerm_virtual_network" "default" {
  name                = "vnet-${var.workload}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.0.0/26"]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault"]
}

resource "azurerm_subnet" "machine_learning" {
  name                 = "machine-learning"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.90.0/26"]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault"]
}

### NSG ###
resource "azurerm_network_security_group" "default" {
  name                = "nsg-${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "default" {
  subnet_id                 = azurerm_subnet.default.id
  network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_subnet_network_security_group_association" "machine_learning" {
  subnet_id                 = azurerm_subnet.machine_learning.id
  network_security_group_id = azurerm_network_security_group.default.id
}
