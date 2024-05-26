resource "azurerm_public_ip" "default" {
  name                = "pip-${var.workload}-firewall"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  # Workaround as per documentation
  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_firewall" "default" {
  name                = "afw-${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  firewall_policy_id  = var.firewall_policy_id
  sku_tier            = var.sku_tier

  # Alert (defaul), Deny, Off
  threat_intel_mode = "Alert"

  ip_configuration {
    name                 = "ipconfig1"
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.default.id
  }
}

### Monitor ###
resource "azurerm_monitor_diagnostic_setting" "default" {
  name                       = "firewall-monitor"
  target_resource_id         = azurerm_firewall.default.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AZFWNetworkRule"
  }

  enabled_log {
    category = "AZFWNatRule"
  }

  enabled_log {
    category = "AZFWApplicationRule"
  }

  metric {
    category = "AllMetrics"
  }
}
