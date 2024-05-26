resource "azurerm_resource_group" "default" {
  name     = "rg-${var.workload}-firewall-${var.affix}"
  location = var.location
}

module "vnet_firewall" {
  source              = "./vnet"
  workload            = var.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  affix               = var.affix
}

module "peerings" {
  source                  = "./peering"
  resource_group_name     = azurerm_resource_group.default.name
  machilelearning_rg_name = var.machilelearning_rg_name

  firewall_vnet_id   = module.vnet_firewall.vnet_id
  firewall_vnet_name = module.vnet_firewall.vnet_name

  machinelearning_vnet_id   = var.machinelearning_vnet_id
  machinelearning_vnet_name = var.machinelearning_vnet_name
}

resource "azurerm_log_analytics_workspace" "default" {
  name                = "log-${var.workload}-firewall-${var.affix}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

module "policy" {
  source                           = "./policy"
  workload                         = var.workload
  location                         = azurerm_resource_group.default.location
  region_service_tag               = var.region_service_tag
  resource_group_name              = azurerm_resource_group.default.name
  policies_sku                     = var.firewall_policy_sku
  firewall_subnet_prefixes         = module.vnet_firewall.firewall_subnet_address_prefixes
  training_subnet_address_prefixes = var.training_subnet_address_prefixes
  # bastion_subnet_address_prefixes  = var.bastion_subnet_address_prefixes
  log_analytics_workspace_id         = azurerm_log_analytics_workspace.default.id
  aml_workspace_default_storage_name = var.aml_workspace_default_storage_name
}

module "firewall" {
  source                     = "./firewall"
  workload                   = var.workload
  location                   = azurerm_resource_group.default.location
  resource_group_name        = azurerm_resource_group.default.name
  sku_tier                   = var.firewall_sku_tier
  firewall_subnet_id         = module.vnet_firewall.subnet_id
  firewall_policy_id         = module.policy.polic_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.default.id
}

module "user_defined_routes" {
  source              = "./routes"
  workload            = var.workload
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  firewall_private_ip = module.firewall.firewall_private_ip
  training_subnet_id  = var.training_subnet_id
  # bastion_subnet_id   = var.bastion_subnet_id
}
