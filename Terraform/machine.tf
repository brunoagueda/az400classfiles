variable "storage_account_name" {
    type=string
    default="appstoregebr18"
}
 
variable "network_name" {
    type=string
    default="staging"
}
 
variable "vm_name" {
    type=string
    default="stagingvm"
}
 
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      
    }
  }
}

provider "azurerm"{
    
  features {}
}
 
resource "azurerm_virtual_network" "staging" {
  name                = var.network_name
  address_space       = ["10.0.0.0/16"]
  location            = "Brazil South"
  resource_group_name = "terraform_grp"
}
 
resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = "terraform_grp"
  virtual_network_name = azurerm_virtual_network.staging.name
  address_prefix     = "10.0.0.0/24"
}
 
resource "azurerm_network_interface" "interface" {
  name                = "default-interface"
  location            = "Brazil South"
  resource_group_name = "terraform_grp"
 
  ip_configuration {
    name                          = "interfaceconfiguration"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
  }
}
 
resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = "Brazil South"
  resource_group_name   = "terraform_grp"
  network_interface_ids = [azurerm_network_interface.interface.id]
  vm_size               = "Standard_DS1_v2"
 
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "stagingvm"
    admin_username = "brunoagueda"
    admin_password = "AzurePortal@123"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }  
}