locals {
  prefix-hub  = "hub"
  prefix-spoke1 = "spoke1"
  prefix-spoke2 = "spoke2"
  hub-location       = "southeastasia"
  hub-resource-group = "az-hub-vnet-rg-tr"
  shared-key         = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
  hub-address-space = "10.0.0.0/16"
  hub-address-subnet1 = "10.0.0.0/24"
  spoke1-address-space = "20.0.0.0/16"
  spoke1-address-subnet1 = "20.0.0.0/24"
  spoke2-address-space = "30.0.0.0/16"
  spoke2-address-subnet1 = "30.0.0.0/24"
}

## Create Resource Group
resource "azurerm_resource_group" "hub-vnet-rg" {
  name     = "${local.hub-resource-group}"
  location = "${local.hub-location}"
}

## Create Hub VNET 
resource "azurerm_virtual_network" "hub-vnet" {
  name                = "${local.prefix-hub}-vnet"
  location            = "${azurerm_resource_group.hub-vnet-rg.location}"
  resource_group_name = "${azurerm_resource_group.hub-vnet-rg.name}"
  address_space       = ["${local.hub-address-space}"]
  
  tags = {
    environment = "hub-spoke-vpn"
  }
}

## Create Hub Subnet
resource "azurerm_subnet" "hubsubnet" {
    name                 = "${local.prefix-hub}-subnet"
    resource_group_name  = "${azurerm_resource_group.hub-vnet-rg.name}"
    virtual_network_name = "${azurerm_virtual_network.hub-vnet.name}"
    address_prefix       = "${local.hub-address-subnet1}"
}


## Crate Spoke 1 VNET
resource "azurerm_virtual_network" "spoke1-vnet" {
  name = "${local.prefix-spoke1}-vnet"
  location = "${local.hub-location}"
  resource_group_name = "${azurerm_resource_group.hub-vnet-rg.name}"
  address_space = ["${local.spoke1-address-space}"]
  
  tags = {
    environment = "hub-spoke-vpn"}

}

## Create Spoke 1 Subnet
resource "azurerm_subnet" "spoke1subnet" {
    name = "${local.prefix-spoke1}-subnet"
    resource_group_name = "${azurerm_resource_group.hub-vnet-rg.name}"
    virtual_network_name = "${azurerm_virtual_network.spoke1-vnet.name}"
    address_prefix = "${local.spoke1-address-subnet1}"
}

## Create Spoke 2 VNET
resource "azurerm_virtual_network" "spoke2-vnet" {
  name = "${local.prefix-spoke2}-vnet"
  location = "${local.hub-location}"
  resource_group_name = "${azurerm_resource_group.hub-vnet-rg.name}"
  address_space = ["${local.spoke2-address-space}"]
  
  tags = {
    environment = "hub-spoke-vpn"}

}

## Create Spoke 2 Subnet
resource "azurerm_subnet" "spoke2subnet" {
  name = "${local.prefix-spoke2}-subnet"
  resource_group_name = "${azurerm_resource_group.hub-vnet-rg.name}"
  virtual_network_name = "${azurerm_virtual_network.spoke2-vnet.name}"
  address_prefix = "${local.spoke2-address-subnet1}"
}

## Create Network Peering between Hub -> Spoke VNET 1

module "vnetpeering" {
    source    =   "../.."
    vnet_peering_names  =   ["hub-to-spoke1", "spoke-to-hub"]
    vnet_names           = ["${azurerm_virtual_network.hub-vnet.name}","${azurerm_virtual_network.spoke1-vnet.name}"]
    resource_group_names = ["${azurerm_resource_group.hub-vnet-rg.name}","${azurerm_resource_group.hub-vnet-rg.name}"]

  tags = {
    environment = "dev"
    costcenter  = "it"
  }
}