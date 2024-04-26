output "data_scientist_user_object_id" {
  value = azuread_user.data_scientist.object_id
}

output "administrator_user_object_id" {
  value = azuread_user.administrator.object_id
}
