output "app_registration_client_id" {
  value = module.entra_service_principal.app_registration_client_id
}

output "aml_workspace_name" {
  value = module.ml_workspace.aml_workspace_name
}

output "data_lake_id" {
  value = module.data_lake.id
}

output "proxy_public_ip_address" {
  value = var.vm_proxy_create_flag == true ? module.proxy[0].public_ip_address : ""
}

output "proxy_ssh" {
  value = var.vm_proxy_create_flag == true ? "ssh -i keys/ssh_key ${module.proxy[0].username}@${module.proxy[0].public_ip_address}" : ""
}
