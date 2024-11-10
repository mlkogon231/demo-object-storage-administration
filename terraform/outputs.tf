# terraform/outputs.tf
output "azure_infra_resource_group_name" {
  value = module.azure_infrastructure.resource_group_name
}

output "azure_infra_vnet_name" {
  value = module.azure_infrastructure.vnet_name
}

output "azure_infra_vm_private_ip" {
  value = module.azure_infrastructure.vm_private_ip
}

output "azure_infra_vm_name" {
  value = module.azure_infrastructure.vm_name
}

