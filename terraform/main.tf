provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "demoAnsible"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "demoAnsible-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "demoAnsible-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

module "app_vm" {
  source         = "./modules/vm"
  vm_name        = "appvm"
  subnet_id      = azurerm_subnet.subnet.id
  location       = var.location
  resource_group = azurerm_resource_group.rg.name
  public_ip_dns  = "appvmdevopsmc"
  enable_http    = true
  admin_username = var.admin_username
}

module "db_vm" {
  source         = "./modules/vm"
  vm_name        = "dbvm"
  subnet_id      = azurerm_subnet.subnet.id
  location       = var.location
  resource_group = azurerm_resource_group.rg.name
  public_ip_dns  = "dbvmdevopsmc"
  enable_http    = false
  admin_username = var.admin_username
}