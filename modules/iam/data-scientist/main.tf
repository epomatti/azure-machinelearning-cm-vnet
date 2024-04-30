data "azurerm_subscription" "current" {}

locals {
  exclude_owner_condition = "((!(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidNotEquals {8e3af657-a8ff-443c-a75c-2fe8c4bcb635})) AND ((!(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidNotEquals {8e3af657-a8ff-443c-a75c-2fe8c4bcb635}))"
}

resource "azurerm_role_assignment" "rgs_reader" {
  count                = length(var.resource_group_ids)
  scope                = var.resource_group_ids[count.index]
  role_definition_name = "Reader"
  principal_id         = var.user_object_id
}

resource "azurerm_role_assignment" "rgs_aml_data_scientist" {
  count                = length(var.resource_group_ids)
  scope                = var.resource_group_ids[count.index]
  role_definition_name = "AzureML Data Scientist"
  principal_id         = var.user_object_id
}

resource "azurerm_role_assignment" "acr_push" {
  scope                = var.acr_id
  role_definition_name = "AcrPush"
  principal_id         = var.user_object_id
}

resource "azurerm_role_assignment" "acr_delete" {
  scope                = var.acr_id
  role_definition_name = "AcrDelete"
  principal_id         = var.user_object_id
}

# resource "azurerm_role_assignment" "blob_data_owner" {
#   scope                = var.resource_group_id
#   role_definition_name = "Storage Blob Data Owner"
#   principal_id         = var.user_object_id
# }

# resource "azurerm_role_assignment" "blob_data_contributor" {
#   scope                = var.resource_group_id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = var.user_object_id
# }
