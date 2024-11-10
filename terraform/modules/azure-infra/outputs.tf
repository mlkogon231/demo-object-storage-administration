# modules/azure-infra/outputs.tf

output "resource_group_name" {
  value = azurerm_resource_group.infra.name
}

output "resource_group_id" {
  value = azurerm_resource_group.infra.id
}

output "vnet_name" {
  value = azurerm_virtual_network.infra.name
}

output "vnet_id" {
  value = azurerm_virtual_network.infra.id
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.main.name
}

output "vm_private_ip" {
  value = azurerm_network_interface.vm.private_ip_address
}

output "storage_account_name" {
  value = azurerm_storage_account.minio.name
}

output "storage_account_key" {
  value     = azurerm_storage_account.minio.primary_access_key
  sensitive = true
}

output "storage_container_name" {
  value = azurerm_storage_container.minio_data.name
}

output "backend_subnet_id" {
  value = azurerm_subnet.backend.id
}