# Terraform Azure Hybrid Landing Zone

This is my Terraform lab project to practice how to build and manage Azure infrastructure using Terraform, GitHub, and GitHub Actions.

The main goal is to learn a workflow that is closer to how infrastructure is managed in a real environment.

## What I built

This project includes:

* Separate dev and prod environments
* Azure Resource Groups
* Virtual Networks
* Subnets
* Network Security Groups
* NSG rules
* Route Table and routes
* Storage Account
* Private Endpoint
* Private DNS Zone
* Linux VM
* Windows VM
* Managed Identity
* Azure Key Vault
* Key Vault RBAC
* Remote Terraform state in Azure Storage
* GitHub source control
* GitHub Actions CI/CD
* OIDC authentication from GitHub to Azure

## Project Structure

```text
terraform-azure-hybrid-landing-zone
│
├── environments
│   ├── dev
│   └── prod
│
├── modules
│   ├── resource-group
│   ├── networking
│   ├── nsg
│   ├── route-table
│   ├── storage-account
│   ├── private-dns-zone
│   ├── private-endpoint
│   ├── key-vault
│   ├── linux-vm
│   └── windows-vm
│
└── .github
    └── workflows
```

## Dev Environment

The dev environment currently has:

```text
Resource Group:
rg-hybrid-lz-dev

VNet:
vnet-hybrid-lz-dev
10.10.0.0/16

Subnets:
10.10.1.0/24  Management
10.10.2.0/24  Workload
10.10.3.0/24  Private Endpoint
```

I also added NSGs for management and workload traffic.

Example rules:

```text
Management subnet
- RDP
- SSH

Workload subnet
- HTTPS from management subnet
```

## Routing

The workload subnet uses a route table.

Example:

```text
0.0.0.0/0 -> Internet
```

This is only for lab testing.

In a real environment, traffic may go through Azure Firewall or another security device.

## Private Access

I also tested private access for Azure services.

This includes:

* Private Endpoint
* Private DNS Zone
* VNet DNS link

I used this for Storage Account and Azure Key Vault.

## Virtual Machines

I deployed:

* 1 Linux VM
* 1 Windows VM

The Windows VM also uses a Managed Identity.

The Managed Identity was given permission to Azure Key Vault using RBAC.

This helped me understand how a VM can access Azure services without saving credentials inside the VM.

## Terraform State

Terraform state is stored in Azure Storage instead of only on my laptop.

This is useful because:

* state is stored in one place
* GitHub Actions can use the same state
* state locking helps stop two Terraform jobs from changing infrastructure at the same time

The state file is not stored in GitHub.

## Variables

Environment settings are stored in tfvars files.

Example:

```text
dev.ci.tfvars
terraform.tfvars
```

Sensitive values are not committed to GitHub.

For example, the Windows admin password is passed separately.

## Git Workflow

I used a simple Git workflow:

```text
main
 |
 +-- feature branch
        |
        +-- make change
        +-- git add
        +-- git commit
        +-- git push
        +-- Pull Request
        +-- Terraform plan
        +-- review
        +-- merge to main
```

After merge, I delete the feature branch.

## GitHub Actions

GitHub Actions is used to run Terraform automatically.

The workflow checks things like:

```text
terraform fmt
terraform init
terraform validate
terraform plan
```

Dev and prod are checked separately.

For changes that need apply, approval is required before deployment.

## OIDC Authentication

GitHub Actions connects to Azure using OIDC.

This means I do not need to save a long-lived Azure client secret in GitHub.

The flow is:

```text
GitHub Actions
      |
      | OIDC
      v
Microsoft Entra ID
      |
      v
Azure
```

A federated credential is configured in Entra ID for the GitHub repository.

## Useful Commands

Format check:

```powershell
terraform fmt -check -recursive
```

Initialize Terraform:

```powershell
terraform init
```

Validate:

```powershell
terraform validate
```

Plan dev:

```powershell
terraform plan -var-file="dev.ci.tfvars"
```

Plan prod:

```powershell
terraform plan
```

Check Git status:

```powershell
git status
```

Create feature branch:

```powershell
git checkout -b feature/example
```

Push branch:

```powershell
git push -u origin feature/example
```

## Things I Learned

Some useful things I learned from this project:

* how Terraform state works
* why remote state is useful
* how Terraform detects drift
* how modules help reuse code
* how `for_each` works
* how module outputs are used
* how dev and prod can use the same modules
* how Git branches and Pull Requests work
* how GitHub Actions can run Terraform
* how OIDC works with Azure
* how Terraform state locking works
* how Private Endpoint and Private DNS work
* how Managed Identity works
* how RBAC can be assigned using Terraform
* why passwords and secrets should not be stored in Git

## Example Issue I Found

During final testing, Terraform wanted to replace the Windows VM.

The reason was that I used a different value for the Windows admin password.

Terraform showed:

```text
admin_password = sensitive value
forces replacement
```

After using the same password as the original deployment, Terraform returned:

```text
No changes. Your infrastructure matches the configuration.
```

This was a good example of why Terraform plan should always be checked before apply.

## Final Result

At the end of the project:

```text
DEV  -> No changes
PROD -> No changes
```

The Terraform configuration matched the Azure infrastructure.

The GitHub CI/CD test also completed successfully.

## Next Step

Possible future improvements:

* Azure Firewall
* Hub and Spoke network
* Application Gateway
* Azure Monitor
* Log Analytics
* Azure Policy
* more RBAC examples
* more workloads

For now, this project is mainly for learning Terraform, Azure infrastructure, and CI/CD.

