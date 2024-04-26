variable "tenant_domain" {
  type = string
}

variable "data_scientist_username" {
  type = string
}

variable "administrator_username" {
  type = string
}

variable "user_password" {
  type      = string
  sensitive = true
}
