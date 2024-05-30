variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_id" {
  type = string
}

variable "private_endpoints_subnet_id" {
  type = string
}

variable "aml_workspace_id" {
  type = string
}

variable "container_registry_id" {
  type = string
}

variable "keyvault_id" {
  type = string
}

variable "aml_storage_account_id" {
  type = string
}

variable "data_lake_storage_account_id" {
  type = string
}

variable "mlw_mssql_create_flag" {
  type = bool
}

variable "sql_server_id" {
  type = string
}
