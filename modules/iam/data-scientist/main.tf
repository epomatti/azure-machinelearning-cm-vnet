data "azurerm_subscription" "current" {}

locals {
  exclude_owner_condition = "((!(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidNotEquals {8e3af657-a8ff-443c-a75c-2fe8c4bcb635})) AND ((!(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidNotEquals {8e3af657-a8ff-443c-a75c-2fe8c4bcb635}))"
}

resource "azurerm_role_assignment" "subscription_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = var.user_object_id
}

resource "azurerm_role_assignment" "resource_group_contributor" {
  scope                = var.resource_group_id
  role_definition_name = "Contributor" # FIXME: Confirm if a data scientist should have contributor access
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
