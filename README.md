# Azure ML VNET

Implementation of [AML network isolation][1] with a customer-managed VNET.

<img src=".assets/aml.png" />

## Setup

Create the variables file:

```sh
cp config/template.tfvars .auto.tfvars
```

👉 Set your IP address in the `allowed_ip_address` variable.
👉 Set your the Entra ID tenant in the  `entraid_tenant_domain` variable.

Generate a key pair to manage instances with SSH:

```sh
ssh-keygen -f keys/ssh_key
```

Create the resources:

```sh
terraform init
terraform apply -auto-approve
```

Confirm and approve any private endpoints, both in the subscription, and within the managed AML workspace.

Manually create the datastores in AML and run the test notebooks.

## Compute

Create the AML compute and other resources by changing the appropriate flags:

> 💡 Follow the [documentation][2] steps to enable AKS VNET integration, if not yet done so.

```terraform
mlw_instance_create_flag = true
mlw_aks_create_flag      = true
mlw_mssql_create_flag    = true
```

---

### Clean-up

Delete the resources and avoid unplanned costs:

```sh
terraform destroy -auto-approve
```

[1]: https://learn.microsoft.com/en-us/azure/machine-learning/how-to-network-isolation-planning?view=azureml-api-2#recommended-architecture-use-your-azure-vnet
[2]: https://learn.microsoft.com/en-us/azure/aks/api-server-vnet-integration
