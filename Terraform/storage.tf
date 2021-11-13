variable "storage_account_name" {
    type=string
    default="appstoregebr17"
}
 
variable "resource_group_name" {
    type=string
    default="terraform_grp"
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
 
resource "azurerm_resource_group" "grp" {
  name     = var.resource_group_name
  location = "Brazil South"
}
 
resource "azurerm_storage_account" "store" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.grp.name
  location                 = azurerm_resource_group.grp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}