output "vm_id" {
  description = "ID of the virtual machine"
  value       = module.windows_vm.resource_id
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = module.windows_vm.resource.name
}

output "vm_private_ip" {
  description = "Private IP address of the virtual machine"
  value       = module.windows_vm.virtual_machine_azurerm.network_interface_ids
}

output "vm_public_ip" {
  description = "Public IP address of the virtual machine"
  value       = try(module.windows_vm.public_ip_addresses[0], null)
}