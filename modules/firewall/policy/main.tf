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

  application_rule_collection {
    name     = "HTTP"
    priority = 500
    action   = "Allow"

    rule {
      name = "All"

      source_ip_groups  = [azurerm_ip_group.training.id]
      destination_fqdns = ["terra.com.br"] # TODO: Update this to the actual FQDNs

      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
    }
  }
}

# resource "azurerm_firewall_policy_rule_collection_group" "bastion" {
#   name               = "BastionRuleCollectionGroup"
#   firewall_policy_id = azurerm_firewall_policy.policy_01.id
#   priority           = 600

#   application_rule_collection {
#     name     = "HTTP"
#     priority = 600
#     action   = "Allow"

#     rule {
#       name = "All"

#       source_ip_groups  = [azurerm_ip_group.bastion.id]
#       destination_fqdns = ["*"]

#       protocols {
#         type = "Http"
#         port = 80
#       }

#       protocols {
#         type = "Https"
#         port = 443
#       }
#     }
#   }
# }
