output "app_registration_client_id" {
  value = module.entra_service_principal.app_registration_client_id
}

output "aml_workspace_name" {
  value = module.ml_workspace.aml_workspace_name
}

output "data_lake_id" {
  value = module.data_lake.id
}
