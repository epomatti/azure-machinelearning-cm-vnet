resource "azuread_user" "data_scientist" {
  account_enabled     = true
  user_principal_name = "${var.data_scientist_username}@${var.tenant_domain}"
  display_name        = var.data_scientist_username
  password            = var.data_scientist_password
}
