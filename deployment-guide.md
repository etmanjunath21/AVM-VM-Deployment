---

## File: deployment-guide.md

```markdown
# AVM VM Deployment Guide

## Quick Start

### 1. Prerequisites Setup
- Ensure you have an existing Azure Resource Group
- Update `examples/01-prerequisites/terraform.tfvars` with your values
- Run the prerequisites deployment

### 2. VM Deployment
- Update `examples/02-vm-deployment/terraform.tfvars` with your values
- Deploy the VM using the prerequisites infrastructure

### 3. Access Your VM
- Use the public IP output from the VM deployment
- Connect via RDP using the admin username and password from Key Vault

## Important Notes

- **Key Vault Names**: Must be globally unique across Azure
- **VM Names**: Must be unique within the resource group
- **IP Ranges**: Update `allowed_ip_range` with your public IP for security
- **VM Sizes**: Choose appropriate size based on your workload requirements

## Troubleshooting

### Common Issues
1. **Key Vault name already exists**: Use a unique name
2. **Insufficient permissions**: Ensure you have Contributor access to the resource group
3. **Network connectivity**: Verify NSG rules and public IP configuration

### Getting Help
- Review Terraform plan output before applying
- Check Azure portal for resource status
- Review Terraform state files for current configuration