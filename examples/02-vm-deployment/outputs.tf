output "vm_id" {
  description = "The ID of the Virtual Machine"
  value       = module.windows_vm.virtual_machine_id
}

output "vm_name" {
  description = "The name of the Virtual Machine"
  value       = module.windows_vm.virtual_machine_name
}

output "vm_private_ip" {
  description = "Private IP address of the VM"
  value       = module.windows_vm.virtual_machine_azurerm.private_ip_address
}

output "vm_public_ip" {
  description = "Public IP address of the VM (if enabled)"
  value       = var.enable_public_ip ? module.windows_vm.public_ip_address : null
}

output "vm_fqdn" {
  description = "Fully qualified domain name of the VM (if public IP enabled)"
  value       = var.enable_public_ip ? module.windows_vm.public_ip_fqdn : null
}

output "admin_username" {
  description = "Admin username for the VM"
  value       = var.admin_username
}

output "connection_info" {
  description = "Connection information for the VM"
  value = var.enable_public_ip ? {
    rdp_command = "mstsc /v:${module.windows_vm.public_ip_address}"
    ssh_command = "ssh ${var.admin_username}@${module.windows_vm.public_ip_address}"
    public_ip   = module.windows_vm.public_ip_address
    private_ip  = module.windows_vm.virtual_machine_azurerm.private_ip_address
  } : {
    rdp_command = "Connect via private network or VPN"
    ssh_command = "Connect via private network or VPN"
    public_ip   = "Not assigned"
    private_ip  = module.windows_vm.virtual_machine_azurerm.private_ip_address
  }
}