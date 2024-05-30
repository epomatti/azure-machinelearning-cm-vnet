output "private_dns_zone_blob_id" {
  value = azurerm_private_dns_zone.blob.id

  depends_on = [azurerm_private_dns_zone_virtual_network_link.blob]
}
