output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "bastion_subnet_id" {
  value = azurerm_subnet.bastion.id
}

output "private_endpoints_subnet_id" {
  value = azurerm_subnet.private_endpoints.id
}

output "training_subnet_id" {
  value = azurerm_subnet.training.id
}

output "scoring_subnet_id" {
  value = azurerm_subnet.scoring.id
}

output "scoring_aks_api_subnet_id" {
  value = azurerm_subnet.scoring_aks_api.id
}

output "subnet_ids" {
  value = [
    azurerm_subnet.bastion.id,
    azurerm_subnet.private_endpoints.id,
    azurerm_subnet.training.id,
    azurerm_subnet.scoring.id,
    azurerm_subnet.scoring_aks_api.id
  ]
}
