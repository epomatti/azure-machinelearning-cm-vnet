variable "workload" {
  type = string
}

variable "affix" {
  type = string
}

variable "location" {
  type = string
}

variable "region_service_tag" {
  type = string
}

variable "machilelearning_rg_name" {
  type = string
}

variable "aml_workspace_default_storage_name" {
  type = string
}

### Firewall ###
variable "firewall_sku_tier" {
  type = string
}

variable "firewall_policy_sku" {
  type = string
}

### Spoke ###
variable "machinelearning_vnet_id" {
  type = string
}

variable "machinelearning_vnet_name" {
  type = string
}

variable "training_subnet_id" {
  type = string
}

# variable "bastion_subnet_id" {
#   type = string
# }

variable "training_subnet_address_prefixes" {
  type = list(string)
}

# variable "bastion_subnet_address_prefixes" {
#   type = list(string)
# }

variable "training_nsg_id" {
  type = string
}
