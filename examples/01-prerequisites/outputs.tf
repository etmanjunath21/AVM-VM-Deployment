# Resource Group Outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = data.azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = data.azurerm_resource_group.main.location
}

# Key Vault Outputs
output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = module.key_vault.resource_id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.key_vault.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.key_vault.uri
}

# Virtual Network Outputs
output "virtual_network_id" {
  description = "ID of the Virtual Network"
  value       = module.virtual_network.resource_id
}

output "virtual_network_name" {
  description = "Name of the Virtual Network"
  value       = module.virtual_network.name
}

output "subnet_id" {
  description = "ID of the VM subnet"
  value       = module.virtual_network.subnets["vm_subnet"].resource_id
}

output "subnet_name" {
  description = "Name of the VM subnet"
  value       = var.subnet_name
}

# Network Security Group Outputs
output "network_security_group_id" {
  description = "ID of the Network Security Group"
  value       = module.network_security_group.resource_id
}

output "network_security_group_name" {
  description = "Name of the Network Security Group"
  value       = module.network_security_group.name
}
