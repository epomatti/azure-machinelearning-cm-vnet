terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
  }
}

# https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/privatelinkscopes?pivots=deployment-language-terraform
# Reference: https://github.com/hashicorp/terraform-provider-azurerm/issues/19370
resource "azapi_resource" "ampls_default" {
  type      = "microsoft.insights/privateLinkScopes@2021-07-01-preview"
  name      = "ampls-${var.workload}"
  location  = "global"
  parent_id = var.resouce_group_id

  # Must use "Open" mode following the documentation for Machine Learning:
  # https://learn.microsoft.com/en-us/azure/machine-learning/how-to-secure-workspace-vnet?view=azureml-api-2&tabs=required%2Cpe%2Ccli#azure-monitor
  body = jsonencode({
    properties = {
      accessModeSettings = {
        ingestionAccessMode = "Open"
        queryAccessMode     = "Open"
      }
    }
  })
}

resource "azurerm_monitor_private_link_scoped_service" "log_analytics_workspace" {
  name                = "amplsmonitor-${var.workload}"
  resource_group_name = var.resource_group_name
  scope_name          = azapi_resource.ampls_default.name
  linked_resource_id  = var.log_analytics_workspace_id
}

resource "azurerm_monitor_private_link_scoped_service" "application_insights" {
  name                = "amplsservice-${var.workload}"
  resource_group_name = var.resource_group_name
  scope_name          = azapi_resource.ampls_default.name
  linked_resource_id  = var.application_insights_id
}
