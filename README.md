# Azure VM Infrastructure with Ansible Provisioning

This project uses **Terraform** to provision two virtual machines in **Microsoft Azure**, and **Ansible** to configure the application server. The infrastructure is modular and secure, with separate configurations for application and database VMs.

## Features
- ☁️ **Infrastructure as Code** with Terraform  
- 🔐 **Secure SSH key-based login**  
- 🛡️ **Separate NSG rules**: HTTP access only to `appvm`, SSH access to both  
- 🤖 **Automated provisioning** of NGINX and MySQL via Ansible  
- 📦 **Modular design** using reusable Terraform modules 

## Infrastructure Overview

```
Azure
├── Resource Group
├── Virtual Network
│   └── Subnet
├── Network Security Groups
│   ├── appvm-nsg (SSH + HTTP)
│   └── dbvm-nsg  (SSH only)
├── Public IPs 
├── Network Interfaces
├── Virtual Machines
│   ├── appvm (NGINX installed by Ansible)
│   └── dbvm (mysql installed by Ansible)
└── Storage Accounts
```

## Project Structure

```
.
├── terraform
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│   ├── modules
│     └── vm
│         ├── main.tf
│         ├── variables.tf
│         └── outputs.tf
├── ansible
│   ├── roles
│   │  └── vm
│   │      ├── mysql
│   │      │  ├── default
│   │      │  │  └── main.tf
│   │      │  ├── defaults
│   │      │  │  └── main.tf
│   │      │  └── tasks
│   │      │    └── main.tf
│   │      └── nginx
│   │        └── tasks
│   │          └── main.tf
│   ├── playbook.yml
│   ├── azure_rm.yaml
│   └── inventory.txt
└── README.md
```

## Prerequisites

- ✅ Azure credentials exported as environment variables:

  ```bash
  export ARM_CLIENT_ID="xxx"
  export ARM_CLIENT_SECRET="xxx"
  export ARM_SUBSCRIPTION_ID="xxx"
  export ARM_TENANT_ID="xxx"
  ```
- ✅ Terraform
- ✅ Ansible (on WSL/Linux/macOS)
- ✅ SSH key pair (public key path needed in `main.tf`)

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/SkrytyZubr/azure-vm-infra-ansible.git
cd azure-vm-infra-ansible
```

### 2. Configure Terraform Variables

Update your `main.tf`:

```hcl
ssh_keys {
  path     = "/home/${var.admin_username}/.ssh/authorized_keys"
  key_data = file("C:/Users/<username>/.ssh/azure_vm_key.pub")
}
```

### 3. Deploy the Infrastructure

```bash
terraform init
terraform apply
```

### 4. Configure Ansible Inventory (optional)

```bash
[webserver]
appvm ansible_host=<appvm_public_ip>

[database]
dbvm ansible_host=<dbvm_public_ip>
```

### 5. Run Ansible Playbook

```bash
ansible-playbook -i inventory.txt playbook.yml -u <admin_username> --private-key ~/.ssh/azure_vm_key
```

## Access the Web Server

Visit the **public IP** of `appvm` in your browser. You should see the default **NGINX** welcome page.

## Security Notes

- Only `appvm` has port 80 open to the world.
- Both VMs allow SSH, using key-based authentication only.
- `dbvm` has **no** open ports except SSH.
