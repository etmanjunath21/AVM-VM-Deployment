terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.116.0, < 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# Data source for current client configuration
data "azurerm_client_config" "current" {}

# Data source for existing resource group
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# Random password for VM admin
resource "random_password" "vm_admin_password" {
  length  = 16
  special = true
}

# Deploy Key Vault using Microsoft AVM module
module "key_vault" {
  source = "Azure/avm-res-keyvault-vault/azurerm"
  version = "~> 0.9"

  name                = var.key_vault_name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name                        = var.key_vault_sku
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  purge_protection_enabled        = true
  soft_delete_retention_days      = 7

  network_acls = {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  role_assignments = {
    current_user = {
      role_definition_id_or_name = "Key Vault Administrator"
      principal_id               = data.azurerm_client_config.current.object_id
    }
  }

  secrets = {
    vm_admin_password = {
      name  = "vm-admin-password"
      value = random_password.vm_admin_password.result
    }
  }

  tags = var.tags
}

# Deploy Virtual Network using Microsoft AVM module
module "virtual_network" {
  source = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.7"

  name                = var.vnet_name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  address_space       = var.vnet_address_space

  subnets = {
    vm_subnet = {
      name             = var.subnet_name
      address_prefixes = var.subnet_address_prefixes
    }
  }

  tags = var.tags
}

# Deploy Network Security Group using Microsoft AVM module
module "network_security_group" {
  source = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "~> 0.3"

  name                = "${var.subnet_name}-nsg"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  security_rules = {
    allow_rdp = {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "Allow-RDP-Restricted"
      priority                   = 1001
      protocol                   = "Tcp"
      source_address_prefix      = var.allowed_ip_range
      source_port_range          = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "3389"
      description               = "Allow RDP from specified IP range only"
    }
    allow_winrm = {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "Allow-WinRM-Restricted"
      priority                   = 1002
      protocol                   = "Tcp"
      source_address_prefix      = var.allowed_ip_range
      source_port_range          = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "5985"
      description               = "Allow WinRM from specified IP range only"
    }
    deny_all_inbound = {
      access                     = "Deny"
      direction                  = "Inbound"
      name                       = "Deny-All-Other-Inbound"
      priority                   = 4000
      protocol                   = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      description               = "Deny all other inbound traffic"
    }
  }

  tags = var.tags
}

# Associate NSG with subnet
resource "azurerm_subnet_network_security_group_association" "vm_subnet_nsg" {
  subnet_id                 = module.virtual_network.subnets["vm_subnet"].resource_id
  network_security_group_id = module.network_security_group.resource_id
}

