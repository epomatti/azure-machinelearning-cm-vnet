variable "tenant_domain" {
  type = string
}

variable "data_scientist_username" {
  type = string
}

variable "data_scientist_password" {
  type      = string
  sensitive = true
}
