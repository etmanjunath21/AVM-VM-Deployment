
  variable "resource_group_name" {
  description = "Name of the existing resource group"
  type        = string
}

variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "key_vault_sku" {
  description = "SKU name for Key Vault"
  type        = string
  default     = "standard"
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network (limited for testing)"
  type        = list(string)
  default     = ["10.10.0.0/24"]  # Limited to 256 IPs for testing
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the subnet (limited for testing)"
  type        = list(string)
  default     = ["10.10.0.0/28"]  # Limited to 16 IPs for testing
}

variable "allowed_ip_range" {
  description = "IP range allowed for RDP/WinRM access (CHANGE THIS FOR SECURITY)"
  type        = string
  default     = "0.0.0.0/0"  # CHANGE TO YOUR PUBLIC IP FOR SECURITY
  validation {
    condition = can(cidrhost(var.allowed_ip_range, 0))
    error_message = "The allowed_ip_range must be a valid CIDR block (e.g., '203.0.113.0/32' for single IP)."
  }
}

variable "enable_public_ip" {
  description = "Enable public IP for the VM (set to false for private access only)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "lab"
    Project     = "avm-vm-deployment"
  }
}