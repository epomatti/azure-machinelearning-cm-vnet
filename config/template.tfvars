# Project
location = "brazilsouth"
workload = "litware"

# The IPv4 from where you'll access the resources
allowed_ip_address = ""

# Machine Learning - Compute
mlw_instance_create_flag             = true
mlw_instance_vm_size                 = "STANDARD_D2AS_V4"
mlw_instance_ssh_public_key_rel_path = "keys/ssh_key.pub"

# MSSQL
mssql_sku                  = "Basic"
mssql_max_size_gb          = 2
mssql_admin_login          = "sqladmin"
mssql_admin_login_password = "P4ssw0rd!2023"

# Virtual Machine
vm_size      = "Standard_B4as_v2"
vm_image_sku = "win11-23h2-ent"
