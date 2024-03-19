### Zones ###
resource "azurerm_private_dns_zone" "aml" {
  name                = "privatelink.api.azureml.ms"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone" "registry" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone" "dfs" {
  name                = "privatelink.dfs.core.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone" "sql_server" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name
}

### Links ###
resource "azurerm_private_dns_zone_virtual_network_link" "aml" {
  name                  = "aml-workspace-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.aml.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "registry" {
  name                  = "registry-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.registry.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "dfs" {
  name                  = "dfs-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dfs.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql_server" {
  name                  = "sqlserver-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sql_server.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = true
}

### Endpoints ###
resource "azurerm_private_endpoint" "aml" {
  name                = "pe-aml"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoints_subnet_id

  private_dns_zone_group {
    name = azurerm_private_dns_zone.aml.name
    private_dns_zone_ids = [
      azurerm_private_dns_zone.aml.id
    ]
  }

  private_service_connection {
    name                           = "aml-workspace"
    private_connection_resource_id = var.aml_workspace_id
    is_manual_connection           = false
    subresource_names              = ["amlworkspace"]
  }
}

resource "azurerm_private_endpoint" "registry" {
  name                = "pe-cr"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoints_subnet_id

  private_dns_zone_group {
    name = azurerm_private_dns_zone.registry.name
    private_dns_zone_ids = [
      azurerm_private_dns_zone.registry.id
    ]
  }

  private_service_connection {
    name                           = "registry"
    private_connection_resource_id = var.container_registry_id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }
}

resource "azurerm_private_endpoint" "dfs" {
  name                = "pe-dfs"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoints_subnet_id

  private_dns_zone_group {
    name = azurerm_private_dns_zone.dfs.name
    private_dns_zone_ids = [
      azurerm_private_dns_zone.dfs.id
    ]
  }

  private_service_connection {
    name                           = "dfs"
    private_connection_resource_id = var.data_lake_storage_account_id
    is_manual_connection           = false
    subresource_names              = ["dfs"]
  }
}

resource "azurerm_private_endpoint" "sql_server" {
  name                = "pe-sqlserver"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoints_subnet_id

  private_dns_zone_group {
    name = azurerm_private_dns_zone.sql_server.name
    private_dns_zone_ids = [
      azurerm_private_dns_zone.sql_server.id
    ]
  }

  private_service_connection {
    name                           = "sql-server"
    private_connection_resource_id = var.sql_server_id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }
}
