output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.default.id
}

output "application_insights_id" {
  value = azurerm_application_insights.default.id
}
