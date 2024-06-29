resource "azurerm_user_assigned_identity" "mlw" {
  name                = "id-mlw"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_machine_learning_workspace" "default" {
  name                          = "mlw-${var.workload}"
  friendly_name                 = "Litware Machine Learning"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  public_network_access_enabled = var.public_network_access_enabled

  application_insights_id = var.application_insights_id
  key_vault_id            = var.key_vault_id
  storage_account_id      = var.storage_account_id
  container_registry_id   = var.container_registry_id

  primary_user_assigned_identity = azurerm_user_assigned_identity.mlw.id

  # Disabled is the state that seems to be required to enable VNET integration
  managed_network {
    isolation_mode = "Disabled"
  }

  identity {
    type = "UserAssigned"

    identity_ids = [
      azurerm_user_assigned_identity.mlw.id
    ]
  }

  depends_on = [
    azurerm_role_assignment.key_vault,
    azurerm_role_assignment.key_vault_administrator,
    azurerm_role_assignment.storage,
    azurerm_role_assignment.storage_contributor,
    azurerm_role_assignment.application_insights,
    azurerm_role_assignment.container_registry
  ]
}

resource "azurerm_role_assignment" "key_vault" {
  scope                = var.key_vault_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.mlw.principal_id
}

# Required for compute SSH keys
resource "azurerm_role_assignment" "key_vault_administrator" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_user_assigned_identity.mlw.principal_id
}

resource "azurerm_role_assignment" "storage" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.mlw.principal_id
}

resource "azurerm_role_assignment" "storage_contributor" {
  scope                = var.storage_account_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.mlw.principal_id
}

resource "azurerm_role_assignment" "application_insights" {
  scope                = var.application_insights_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.mlw.principal_id
}

resource "azurerm_role_assignment" "container_registry" {
  scope                = var.container_registry_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.mlw.principal_id
}
