terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.116.0, < 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Data source for existing resource group
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# Data source for existing Key Vault
data "azurerm_key_vault" "main" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

# Data source for existing subnet
data "azurerm_subnet" "vm_subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

# Data source for VM admin password from Key Vault
data "azurerm_key_vault_secret" "vm_admin_password" {
  name         = "vm-admin-password"
  key_vault_id = data.azurerm_key_vault.main.id
}

# Deploy Windows VM using Microsoft AVM module
module "windows_vm" {
  source = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "~> 0.14"

  name                = var.vm_name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  admin_username                     = var.admin_username
  disable_password_authentication    = false
  admin_password                     = data.azurerm_key_vault_secret.vm_admin_password.value
  os_type                           = "Windows"
  sku_size                          = var.vm_size
  zone                              = var.vm_zone

  source_image_reference = var.source_image_reference

  os_disk = {
    caching                = var.os_disk_caching
    storage_account_type   = var.os_disk_storage_account_type
    disk_size_gb          = var.os_disk_size_gb
  }

  # Network interface configuration
  network_interfaces = {
    network_interface_1 = {
      name = "${var.vm_name}-nic"
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "${var.vm_name}-ip-config"
          private_ip_subnet_resource_id = data.azurerm_subnet.vm_subnet.id
          create_public_ip_address      = var.enable_public_ip
          public_ip_address_name        = var.enable_public_ip ? "${var.vm_name}-pip" : null
          public_ip_sku                 = var.enable_public_ip ? "Standard" : null
          public_ip_allocation_method   = var.enable_public_ip ? "Static" : null
          is_primary_ipconfiguration    = true
        }
      }
    }
  }

  # Enable system-assigned managed identity
  managed_identities = {
    system_assigned = true
  }

  # Enable disk encryption if Key Vault is available
  encryption_at_host_enabled = true

  tags = var.tags
}