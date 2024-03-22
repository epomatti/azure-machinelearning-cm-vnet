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

# resource "azurerm_role_assignment" "resource_group_rbac_administrator" {
#   scope                = var.resource_group_id
#   role_definition_name = "Role Based Access Control Administrator"
#   principal_id         = var.user_object_id
# }

# resource "azurerm_role_assignment" "key_vault_administrator" {
#   scope                = var.key_vault_id
#   role_definition_name = "Key Vault Administrator"
#   principal_id         = var.user_object_id
# }










# Required for compute SSH keys
# resource "azurerm_role_assignment" "key_vault_secrets" {
#   scope                = var.key_vault_id
#   role_definition_name = "Key Vault Secrets Officer"
#   principal_id         = azurerm_user_assigned_identity.mlw.principal_id
# }

# resource "azurerm_role_assignment" "storage" {
#   scope                = var.storage_account_id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = azurerm_user_assigned_identity.mlw.principal_id
# }

# resource "azurerm_role_assignment" "storage_contributor" {
#   scope                = var.storage_account_id
#   role_definition_name = "Contributor"
#   principal_id         = azurerm_user_assigned_identity.mlw.principal_id
# }

# resource "azurerm_role_assignment" "application_insights" {
#   scope                = var.application_insights_id
#   role_definition_name = "Contributor"
#   principal_id         = azurerm_user_assigned_identity.mlw.principal_id
# }

# resource "azurerm_role_assignment" "container_registry" {
#   scope                = var.container_registry_id
#   role_definition_name = "Contributor"
#   principal_id         = azurerm_user_assigned_identity.mlw.principal_id
# }

# ### Data Stores ###
# resource "azurerm_role_assignment" "lake" {
#   scope                = var.data_lake_id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = azurerm_user_assigned_identity.mlw.principal_id
# }

# resource "azurerm_role_assignment" "lake_contributor" {
#   scope                = var.data_lake_id
#   role_definition_name = "Contributor"
#   principal_id         = azurerm_user_assigned_identity.mlw.principal_id
# }
