data "azurerm_subscription" "current" {}

resource "azurerm_role_assignment" "subscription_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = var.user_object_id
}

resource "azurerm_role_assignment" "resource_group_contributor" {
  scope                = var.resource_group_id
  role_definition_name = "Contributor"
  principal_id         = var.user_object_id
}

resource "azurerm_role_assignment" "blob_data_owner" {
  scope                = var.resource_group_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.user_object_id
}

resource "azurerm_role_assignment" "blob_data_contributor" {
  scope                = var.resource_group_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.user_object_id
}

resource "azurerm_role_assignment" "key_vault_administrator" {
  scope                = var.resource_group_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.user_object_id
}

resource "azurerm_role_assignment" "user_access_administrator" {
  scope                = var.resource_group_id
  role_definition_name = "User Access Administrator"
  principal_id         = var.user_object_id
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = var.resource_group_id
  role_definition_name = "Network Contributor"
  principal_id         = var.user_object_id
}
