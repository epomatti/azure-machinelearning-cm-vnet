variable "workload" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "training_nsg_source_address_prefixes" {
  type = list(string)
}

variable "firewall_subnet_id" {
  type = string
}
