# Copy this file to terraform.tfvars and update with your values

resource_group_name = "Fiserv-Terraform-Testing"
key_vault_name      = "kv-avm-lab-001"
vnet_name          = "vnet-avm-lab-001"
subnet_name        = "snet-vm-001"

# Optional: Customize these values
# vnet_address_space       = ["10.0.0.0/16"]
# subnet_address_prefixes  = ["10.0.1.0/24"]
# allowed_ip_range         = "YOUR_PUBLIC_IP/32"  # Replace with your public IP

tags = {
  Environment = "lab"
  Project     = "avm-vm-deployment"
  Owner       = "your-name"
}
