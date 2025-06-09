output "resource_group_name" {
  description = "Name of the resource group"
  value       = data.azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = data.azurerm_resource_group.main.location
}

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = module.key_vault.resource_id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.key_vault.resource.name
}

output "key_vault_location" {
  description = "Location of the Key Vault"
  value       = module.key_vault.resource.location
}

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = module.virtual_network.resource_id
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = module.virtual_network.resource.name
}

output "subnet_id" {
  description = "ID of the VM subnet"
  value       = module.virtual_network.subnets["vm_subnet"].resource_id
}

output "subnet_name" {
  description = "Name of the VM subnet"
  value       = module.virtual_network.subnets["vm_subnet"].name
}

output "vm_admin_password_secret_name" {
  description = "Name of the secret containing VM admin password"
  value       = "vm-admin-password"
}