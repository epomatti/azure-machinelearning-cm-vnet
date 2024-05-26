resource "azurerm_firewall_policy" "policy_01" {
  name                = "afwp-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.policies_sku

  insights {
    enabled                            = true
    default_log_analytics_workspace_id = var.log_analytics_workspace_id
    retention_in_days                  = 30
  }
}

resource "azurerm_ip_group" "training" {
  name                = "ipgroup-training-space"
  location            = var.location
  resource_group_name = var.resource_group_name
  cidrs               = var.training_subnet_address_prefixes
}

# resource "azurerm_ip_group" "bastion" {
#   name                = "ipgroup-bastion-space"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   cidrs               = var.bastion_subnet_address_prefixes
# }

# https://learn.microsoft.com/en-us/azure/machine-learning/how-to-access-azureml-behind-firewall?view=azureml-api-2&tabs=ipaddress%2Cpublic
resource "azurerm_firewall_policy_rule_collection_group" "training" {
  name               = "TrainingRuleCollectionGroup"
  firewall_policy_id = azurerm_firewall_policy.policy_01.id
  priority           = 500

  network_rule_collection {
    name     = "Collection001"
    priority = 10000
    action   = "Allow"

    rule {
      name                  = "AzureActiveDirectory"
      source_ip_groups      = [azurerm_ip_group.training.id]
      protocols             = ["TCP"]
      destination_ports     = ["80", "443"]
      destination_addresses = ["AzureActiveDirectory"]
    }

    rule {
      name                  = "AzureMachineLearningTCP"
      source_ip_groups      = [azurerm_ip_group.training.id]
      protocols             = ["TCP"]
      destination_ports     = ["443", "8787", "18881"]
      destination_addresses = ["AzureMachineLearning"]
    }

    rule {
      name                  = "AzureMachineLearningUDP"
      source_ip_groups      = [azurerm_ip_group.training.id]
      protocols             = ["UDP"]
      destination_ports     = ["5831"]
      destination_addresses = ["AzureMachineLearning"]
    }

    rule {
      name              = "Other"
      source_ip_groups  = [azurerm_ip_group.training.id]
      protocols         = ["TCP"]
      destination_ports = ["443"]
      destination_addresses = [
        # Section: Outbound
        "BatchNodeManagement.${var.region_service_tag}",
        "AzureResourceManager",
        "Storage.${var.region_service_tag}",
        "AzureFrontDoor.FrontEnd",
        "MicrosoftContainerRegistry.${var.region_service_tag}",
        "Frontdoor.FirstParty",
        "AzureMonitor",

        # Section: Recommended configuration for training and deploying models
        "MicrosoftContainerRegistry.${var.region_service_tag}",
        "AzureFrontDoor.FirstParty"
      ]
    }

    rule {
      name              = "ScenarioFirewallBetweenAMLandStorageEndpoints"
      source_ip_groups  = [azurerm_ip_group.training.id]
      protocols         = ["Any"]
      destination_ports = ["445"]
      destination_addresses = [
        "Storage.${var.region_service_tag}",
      ]
    }

    rule {
      name              = "ScenarioWorkspaceWithHBIEnabled"
      source_ip_groups  = [azurerm_ip_group.training.id]
      protocols         = ["Any"]
      destination_ports = ["80", "443"]
      destination_addresses = [
        "Keyvault.${var.region_service_tag}",
      ]
    }
  }

  network_rule_collection {
    name     = "Collection002"
    priority = 10100
    action   = "Allow"

    rule {
      name              = "CommonPythonPackages"
      source_ip_groups  = [azurerm_ip_group.training.id]
      protocols         = ["TCP"]
      destination_ports = ["80", "443"]
      destination_addresses = [
        "anaconda.com",
        "*.anaconda.com",
        "*.anaconda.org",
        "pypi.org",
        "*.pythonhosted.org",
        "pytorch.org",
        "*.pytorch.org",
        "*.tensorflow.org"
      ]
    }
  }

  network_rule_collection {
    name     = "Collection003"
    priority = 10200
    action   = "Allow"

    rule {
      name              = "MicrosoftAzurePublic"
      source_ip_groups  = [azurerm_ip_group.training.id]
      protocols         = ["TCP"]
      destination_ports = ["80", "443"]
      destination_addresses = [
        "login.microsoftonline.com",
        "management.azure.com"
      ]
    }
  }

  # network_rule_collection {
  #   name     = "Collection004"
  #   priority = 10300
  #   action   = "Allow"

  #   rule {
  #     name              = "MicrosoftAMLHosts"
  #     source_ip_groups  = [azurerm_ip_group.training.id]
  #     protocols         = ["TCP"]
  #     destination_ports = ["80", "443"]
  #     destination_addresses = [
  #       "ml.azure.com",
  #       "*.azureml.ms",
  #       "*.azureml.net",
  #       "*.modelmanagement.azureml.net",
  #       "*.notebooks.azure.net",
  #       "${var.aml_workspace_default_storage_name}.file.core.windows.net",
  #       "${var.aml_workspace_default_storage_name}.dfs.core.windows.net",
  #       "${var.aml_workspace_default_storage_name}.blob.core.windows.net",
  #       "graph.microsoft.com",
  #       "*.aznbcontent.net",
  #       "automlresources-prod.azureedge.net",
  #       "aka.ms",
  #     ]
  #   }
  # }

  # network_rule_collection {
  #   name     = "Collection005"
  #   priority = 10400
  #   action   = "Allow"

  #   rule {
  #     name              = "MicrosoftAMLHostsSMB"
  #     source_ip_groups  = [azurerm_ip_group.training.id]
  #     protocols         = ["TCP"]
  #     destination_ports = ["445"]
  #     destination_addresses = [
  #       "${var.aml_workspace_default_storage_name}.file.core.windows.net"
  #     ]
  #   }
  # }

  # network_rule_collection {
  #   name     = "Collection006"
  #   priority = 10500
  #   action   = "Allow"

  #   rule {
  #     name              = "AMLComputeTCPHTTP"
  #     source_ip_groups  = [azurerm_ip_group.training.id]
  #     protocols         = ["TCP"]
  #     destination_ports = ["443"]
  #     destination_addresses = [
  #       "graph.windows.net",
  #       "*.instances.azureml.net",
  #       "*.instances.azureml.ms",
  #       "${var.location}.tundra.azureml.ms",
  #       "*.blob.core.windows.net",
  #       "*.table.core.windows.net",
  #       "*.queue.core.windows.net",
  #       "${var.location}.file.core.windows.net",
  #       "${var.location}.blob.core.windows.net",
  #       "*.vault.azure.net"
  #     ]
  #   }
  # }

  # network_rule_collection {
  #   name     = "Collection007"
  #   priority = 10600
  #   action   = "Allow"

  #   rule {
  #     name              = "AMLComputeInstanceAMLMS"
  #     source_ip_groups  = [azurerm_ip_group.training.id]
  #     protocols         = ["TCP"]
  #     destination_ports = ["443", "8787", "18881"]
  #     destination_addresses = [
  #       "graph.windows.net",
  #       "*.instances.azureml.net",
  #       "*.instances.azureml.ms",
  #       "${var.location}.tundra.azureml.ms",
  #       "*.blob.core.windows.net",
  #       "*.table.core.windows.net",
  #       "*.queue.core.windows.net",
  #       "${var.location}.file.core.windows.net",
  #       "${var.location}.blob.core.windows.net",
  #       "*.vault.azure.net"
  #     ]
  #   }
  # }
}

