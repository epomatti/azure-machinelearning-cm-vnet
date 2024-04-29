resource "azurerm_role_assignment" "datalake_owner" {
  scope                = var.datalake_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.datastores_service_principal_object_id
}

resource "azurerm_role_assignment" "datalake_contributor" {
  scope                = var.datalake_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.datastores_service_principal_object_id
}
