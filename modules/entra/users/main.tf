resource "azuread_user" "data_scientist" {
  account_enabled     = true
  user_principal_name = "${var.data_scientist_username}@${var.tenant_domain}"
  display_name        = var.data_scientist_username
  password            = var.user_password
}

resource "azuread_user" "administrator" {
  account_enabled     = true
  user_principal_name = "${var.administrator_username}@${var.tenant_domain}"
  display_name        = var.administrator_username
  password            = var.user_password
}
