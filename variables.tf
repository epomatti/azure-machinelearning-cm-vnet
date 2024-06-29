variable "location" {
  type    = string
  default = "eastus2"
}

variable "region_service_tag" {
  description = "value to be used in the service tag for the region"
  type        = string
}

variable "workload" {
  type    = string
  default = "litware"
}

variable "allowed_ip_address" {
  type = string
}

# VNET
variable "vnet_training_nsg_source_address_prefix" {
  type = string
}

variable "vnet_training_nsg_destination_address_prefix" {
  type = string
}

### AML ###
variable "mlw_instance_create_flag" {
  type = bool
}

variable "mlw_instance_vm_size" {
  type = string
}

variable "mlw_instance_ssh_public_key_rel_path" {
  type = string
}

variable "mlw_public_network_access_enabled" {
  type = bool
}

### AKS ###
variable "mlw_aks_create_flag" {
  type = bool
}

variable "mlw_aks_node_count" {
  type = number
}

variable "mlw_aks_vm_size" {
  type = string
}

### Proxy ###
variable "vm_proxy_create_flag" {
  type = bool
}

variable "vm_proxy_vm_size" {
  type = string
}

### MSSQL ###
variable "mssql_create_flag" {
  type = bool
}

variable "mssql_sku" {
  type = string
}

variable "mssql_max_size_gb" {
  type = number
}

variable "mssql_admin_login" {
  type = string
}

variable "mssql_admin_login_password" {
  type = string
}

### Virtual Machine ###
variable "vm_size" {
  type = string
}

variable "vm_image_sku" {
  type = string
}

variable "vm_admin_username" {
  type = string
}

variable "vm_admin_password" {
  type      = string
  sensitive = true
}

### Entra ID ###
variable "entraid_tenant_domain" {
  type = string
}

variable "entraid_data_scientist_username" {
  type = string
}

variable "entraid_administrator_username" {
  type = string
}

variable "entraid_user_password" {
  type      = string
  sensitive = true
}

### Firewall ###
variable "firewall_create_flag" {
  type = bool
}

variable "firewall_sku_tier" {
  type = string
}

variable "firewall_policy_sku" {
  type = string
}
