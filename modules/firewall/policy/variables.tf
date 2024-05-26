variable "workload" {
  type = string
}

variable "region_service_tag" {
  type = string
}

variable "policies_sku" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "firewall_subnet_prefixes" {
  type = list(string)
}

variable "training_subnet_address_prefixes" {
  type = list(string)
}

# variable "bastion_subnet_address_prefixes" {
#   type = list(string)
# }

variable "log_analytics_workspace_id" {
  type = string
}

variable "aml_workspace_default_storage_name" {
  type = string
}
