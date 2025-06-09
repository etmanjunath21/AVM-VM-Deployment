# AVM VM Deployment using Microsoft Azure Verified Modules

This repository contains Terraform code for deploying Windows VMs using Microsoft's official Azure Verified Modules (AVM) directly from GitHub.

## Structure

- `examples/01-prerequisites/` - Creates Key Vault, VNet, and Subnet using AVM modules
- `examples/02-vm-deployment/` - Deploys the VM using Microsoft AVM module

## Microsoft AVM Modules Used

- **Key Vault**: `Azure/avm-res-keyvault-vault/azurerm`
- **Virtual Network**: `Azure/avm-res-network-virtualnetwork/azurerm`
- **Network Security Group**: `Azure/avm-res-network-networksecuritygroup/azurerm`
- **Virtual Machine**: `Azure/avm-res-compute-virtualmachine/azurerm`

## Prerequisites

1. Azure CLI installed and configured
2. Terraform >= 1.5
3. Existing Resource Group in Azure

## Usage

### Step 1: Deploy Prerequisites

```bash
cd examples/01-prerequisites
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform plan
terraform apply