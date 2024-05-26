output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "vnet_name" {
  value = azurerm_virtual_network.default.name
}

output "bastion_subnet_id" {
  value = azurerm_subnet.bastion.id
}

output "bastion_subnet_address_prefixes" {
  value = azurerm_subnet.bastion.address_prefixes
}

output "private_endpoints_subnet_id" {
  value = azurerm_subnet.private_endpoints.id
}

output "training_subnet_id" {
  value = azurerm_subnet.training.id
}

output "training_subnet_address_prefixes" {
  value = azurerm_subnet.training.address_prefixes
}

output "scoring_subnet_id" {
  value = azurerm_subnet.scoring.id
}

output "scoring_aks_api_subnet_id" {
  value = azurerm_subnet.scoring_aks_api.id
}

output "proxy_subnet_id" {
  value = azurerm_subnet.proxy.id
}

output "subnet_ids" {
  value = [
    azurerm_subnet.bastion.id,
    azurerm_subnet.private_endpoints.id,
    azurerm_subnet.training.id,
    azurerm_subnet.scoring.id,
    azurerm_subnet.scoring_aks_api.id,
    azurerm_subnet.proxy.id
  ]
}
