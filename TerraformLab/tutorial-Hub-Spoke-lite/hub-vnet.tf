locals {
  prefix-hub         = "hub"
  hub-location       = "southeastasia"
  #hub-resource-group = "hub-vnet-rg"
  hub-resource-group = "${var.rg_name}"
  shared-key         = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}

resource "azurerm_resource_group" "hub-vnet-rg" {
  name     = "${local.hub-resource-group}"
  location = "${local.hub-location}"
}

resource "azurerm_virtual_network" "hub-vnet" {
  name                = "${local.prefix-hub}-vnet"
  location            = "${azurerm_resource_group.hub-vnet-rg.location}"
  resource_group_name = "${azurerm_resource_group.hub-vnet-rg.name}"
  address_space       = ["10.0.0.0/16"]

}

resource "azurerm_subnet" "hub-gateway-subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = "${azurerm_resource_group.hub-vnet-rg.name}"
  virtual_network_name = "${azurerm_virtual_network.hub-vnet.name}"
  address_prefix       = "10.0.255.224/27"
}

resource "azurerm_subnet" "hub-mgmt" {
  name                 = "mgmt"
  resource_group_name  = "${azurerm_resource_group.hub-vnet-rg.name}"
  virtual_network_name = "${azurerm_virtual_network.hub-vnet.name}"
  address_prefix       = "10.0.0.64/27"
}

resource "azurerm_public_ip" "hubpublicip" {
    name                         = "hubpip"
    location                     = "${local.hub-location}"
    resource_group_name          = "${azurerm_resource_group.hub-vnet-rg.name}"
    allocation_method            = "Dynamic"
}

resource "azurerm_network_security_group" "hubnsg" {
    name                = "hub_nsg"
    location            = "${local.hub-location}"
    resource_group_name = "${azurerm_resource_group.hub-vnet-rg.name}"
    
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


resource "azurerm_subnet" "hub-dmz" {
  name                 = "dmz"
  resource_group_name  = "${azurerm_resource_group.hub-vnet-rg.name}"
  virtual_network_name = "${azurerm_virtual_network.hub-vnet.name}"
  address_prefix       = "10.0.0.32/27"
}

resource "azurerm_network_interface" "hub-nic" {
  name                 = "${local.prefix-hub}-nic"
  location             = "${azurerm_resource_group.hub-vnet-rg.location}"
  resource_group_name  = "${azurerm_resource_group.hub-vnet-rg.name}"
  enable_ip_forwarding = true
  network_security_group_id = "${azurerm_network_security_group.hubnsg.id}"


  ip_configuration {
    name                          = "${local.prefix-hub}"
    subnet_id                     = "${azurerm_subnet.hub-mgmt.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = "${azurerm_public_ip.hubpublicip.id}"
  }

}

#Virtual Machine
resource "azurerm_virtual_machine" "hub-vm" {
  name                  = "${local.prefix-hub}-vm"
  location              = "${azurerm_resource_group.hub-vnet-rg.location}"
  resource_group_name   = "${azurerm_resource_group.hub-vnet-rg.name}"
  network_interface_ids = ["${azurerm_network_interface.hub-nic.id}"]
  vm_size               = "${var.vmsize}"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1-hubvm"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.prefix-hub}-vm"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

}
