locals {
  prefix-hub         = "hub"
  hub-location       = "southeastasia"
  hub-resource-group = "az-hub-vnet-rg-tr"
  shared-key         = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  hub-address-space = "20.0.0.0/16"
}

resource "azurerm_resource_group" "hub-vnet-rg" {
  name     = "${local.hub-resource-group}"
  location = "${local.hub-location}"
}

 

resource "azurerm_virtual_network" "hub-vnet" {
  name                = "${local.prefix-hub}-vnet-hol"
  location            = "${azurerm_resource_group.hub-vnet-rg.location}"
  resource_group_name = "${azurerm_resource_group.hub-vnet-rg.name}"
  address_space       = ["${local.hub-address-space}"]
  
  tags = {
    environment = "hub-spoke"
  }
}