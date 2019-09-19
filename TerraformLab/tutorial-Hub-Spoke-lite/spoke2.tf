locals {
  spoke2-location       = "southeastasia"
  #spoke2-resource-group = "spoke2-vnet-rg"
  spoke2-resource-group = "${var.rg_name}"
  prefix-spoke2         = "spoke2"
}

resource "azurerm_resource_group" "spoke2-vnet-rg" {
  name     = "${local.spoke2-resource-group}"
  location = "${local.spoke2-location}"
}

resource "azurerm_virtual_network" "spoke2-vnet" {
  name                = "${local.prefix-spoke2}-vnet"
  location            = "${azurerm_resource_group.spoke2-vnet-rg.location}"
  resource_group_name = "${azurerm_resource_group.spoke2-vnet-rg.name}"
  address_space       = ["10.2.0.0/16"]

}

resource "azurerm_subnet" "spoke2-mgmt" {
  name                 = "mgmt"
  resource_group_name  = "${azurerm_resource_group.spoke2-vnet-rg.name}"
  virtual_network_name = "${azurerm_virtual_network.spoke2-vnet.name}"
  address_prefix       = "10.2.0.64/27"
}

resource "azurerm_public_ip" "spoke2publicip" {
    name                         = "spoke2pip"
    location                     = "${local.spoke2-location}"
    resource_group_name          = "${azurerm_resource_group.spoke2-vnet-rg.name}"
    allocation_method            = "Dynamic"
}

resource "azurerm_network_security_group" "spoke2nsg" {
    name                = "spoke2_nsg"
    location            = "${local.spoke2-location}"
    resource_group_name = "${azurerm_resource_group.spoke2-vnet-rg.name}"
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

}

resource "azurerm_subnet" "spoke2-workload" {
  name                 = "workload"
  resource_group_name  = "${azurerm_resource_group.spoke2-vnet-rg.name}"
  virtual_network_name = "${azurerm_virtual_network.spoke2-vnet.name}"
  address_prefix       = "10.2.1.0/24"
}

resource "azurerm_virtual_network_peering" "spoke2-hub-peer" {
  name                      = "${local.prefix-spoke2}-hub-peer"
  resource_group_name       = "${azurerm_resource_group.spoke2-vnet-rg.name}"
  virtual_network_name      = "${azurerm_virtual_network.spoke2-vnet.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.hub-vnet.id}"

  allow_virtual_network_access = true
  allow_forwarded_traffic = true
  allow_gateway_transit   = false
  use_remote_gateways     = false
  depends_on = ["azurerm_virtual_network.spoke2-vnet", "azurerm_virtual_network.hub-vnet"]
}

resource "azurerm_network_interface" "spoke2-nic" {
  name                 = "${local.prefix-spoke2}-nic"
  location             = "${azurerm_resource_group.spoke2-vnet-rg.location}"
  resource_group_name  = "${azurerm_resource_group.spoke2-vnet-rg.name}"
  enable_ip_forwarding = true
  network_security_group_id = "${azurerm_network_security_group.spoke2nsg.id}"

  ip_configuration {
    name                          = "${local.prefix-spoke2}"
    subnet_id                     = "${azurerm_subnet.spoke2-mgmt.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = "${azurerm_public_ip.spoke2publicip.id}"
  }

}

resource "azurerm_virtual_machine" "spoke2-vm" {
  name                  = "${local.prefix-spoke2}-vm"
  location              = "${azurerm_resource_group.spoke2-vnet-rg.location}"
  resource_group_name   = "${azurerm_resource_group.spoke2-vnet-rg.name}"
  network_interface_ids = ["${azurerm_network_interface.spoke2-nic.id}"]
  vm_size               = "${var.vmsize}"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1-spoke2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.prefix-spoke2}-vm"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

}

resource "azurerm_virtual_network_peering" "hub-spoke2-peer" {
  name                      = "hub-spoke2-peer"
  resource_group_name       = "${azurerm_resource_group.hub-vnet-rg.name}"
  virtual_network_name      = "${azurerm_virtual_network.hub-vnet.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.spoke2-vnet.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
  depends_on = ["azurerm_virtual_network.spoke2-vnet", "azurerm_virtual_network.hub-vnet"]
}

#resource "azurerm_subnet_network_security_group_association" "spoke2nsglink" {
#  subnet_id                 = "${azurerm_subnet.spoke2-mgmt.id}"
#  network_security_group_id = "${azurerm_network_security_group.spoke2nsg.id}"
#  depends_on = ["azurerm_virtual_network.spoke2-vnet", "azurerm_subnet.spoke2-mgmt", "azurerm_network_security_group.spoke2nsg"]
#}