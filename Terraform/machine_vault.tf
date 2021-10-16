variable "storage_account_name" {
    type=string
    default="appstoregebr19"
}
 
variable "network_name" {
    type=string
    default="staging1"
}
 
variable "vm_name" {
    type=string
    default="stagingvm1"
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
 
data "azurerm_key_vault" "keyvault" {
  name                = "demoappvaultaz400"
  resource_group_name = "az400demo"
}
 
data "azurerm_key_vault_secret" "vmsecret" {
  name         = "ServerPwd"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}
 
resource "azurerm_virtual_network" "staging" {
  name                = var.network_name
  address_space       = ["10.0.0.0/16"]
  location            = "Brazil South"
  resource_group_name = "terraform_grp2"
}
 
resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = "terraform_grp2"
  virtual_network_name = azurerm_virtual_network.staging.name
  address_prefix     = "10.0.0.0/24"
}
 
resource "azurerm_network_interface" "interface" {
  name                = "default-interface"
  location            = "Brazil South"
  resource_group_name = "terraform_grp2"
 
  ip_configuration {
    name                          = "interfaceconfiguration"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
  }
}
 
resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = "Brazil South"
  resource_group_name   = "terraform_grp2"
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
    computer_name  = "stagingvm1"
    admin_username = "demousr"
    admin_password = data.azurerm_key_vault_secret.vmsecret.value
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }  
}