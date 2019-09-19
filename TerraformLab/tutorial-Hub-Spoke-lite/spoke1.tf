locals {
  spoke1-location       = "southeastasia"
  #spoke1-resource-group = "spoke1-vnet-rg"
  spoke1-resource-group = "${var.rg_name}"
  prefix-spoke1         = "spoke1"
}

resource "azurerm_resource_group" "spoke1-vnet-rg" {
  name     = "${local.spoke1-resource-group}"
  location = "${local.spoke1-location}"
}

resource "azurerm_virtual_network" "spoke1-vnet" {
  name                = "spoke1-vnet"
  location            = "${azurerm_resource_group.spoke1-vnet-rg.location}"
  resource_group_name = "${azurerm_resource_group.spoke1-vnet-rg.name}"
  address_space       = ["10.1.0.0/16"]

}

resource "azurerm_subnet" "spoke1-mgmt" {
  name                 = "mgmt"
  resource_group_name  = "${azurerm_resource_group.spoke1-vnet-rg.name}"
  virtual_network_name = "${azurerm_virtual_network.spoke1-vnet.name}"
  address_prefix       = "10.1.0.64/27"
}

# Create public IP address
resource "azurerm_public_ip" "spoke1publicip" {
    name                         = "spoke1pip"
    location                     = "${local.spoke1-location}"
    resource_group_name          = "${azurerm_resource_group.spoke1-vnet-rg.name}"
    allocation_method            = "Dynamic"
}

resource "azurerm_network_security_group" "spoke1nsg" {
    name                = "spoke1_nsg"
    location            = "${local.spoke1-location}"
    resource_group_name = "${azurerm_resource_group.spoke1-vnet-rg.name}"
    
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


resource "azurerm_subnet" "spoke1-workload" {
  name                 = "workload"
  resource_group_name  = "${azurerm_resource_group.spoke1-vnet-rg.name}"
  virtual_network_name = "${azurerm_virtual_network.spoke1-vnet.name}"
  address_prefix       = "10.1.1.0/24"
}

resource "azurerm_virtual_network_peering" "spoke1-hub-peer" {
  name                      = "spoke1-hub-peer"
  resource_group_name       = "${azurerm_resource_group.spoke1-vnet-rg.name}"
  virtual_network_name      = "${azurerm_virtual_network.spoke1-vnet.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.hub-vnet.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
  allow_gateway_transit   = false
  use_remote_gateways     = false
  depends_on = ["azurerm_virtual_network.spoke1-vnet", "azurerm_virtual_network.hub-vnet"]
}

resource "azurerm_network_interface" "spoke1-nic" {
  name                 = "${local.prefix-spoke1}-nic"
  location             = "${azurerm_resource_group.spoke1-vnet-rg.location}"
  resource_group_name  = "${azurerm_resource_group.spoke1-vnet-rg.name}"
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "${local.prefix-spoke1}"
    subnet_id                     = "${azurerm_subnet.spoke1-mgmt.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = "${azurerm_public_ip.spoke1publicip.id}"
  }
  
  network_security_group_id = "${azurerm_network_security_group.spoke1nsg.id}"
}

resource "azurerm_virtual_machine" "spoke1-vm" {
  name                  = "${local.prefix-spoke1}-vm"
  location              = "${azurerm_resource_group.spoke1-vnet-rg.location}"
  resource_group_name   = "${azurerm_resource_group.spoke1-vnet-rg.name}"
  network_interface_ids = ["${azurerm_network_interface.spoke1-nic.id}"]
  vm_size               = "${var.vmsize}"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1-spoke1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.prefix-spoke1}-vm"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

}

resource "azurerm_virtual_network_peering" "hub-spoke1-peer" {
  name                      = "hub-spoke1-peer"
  resource_group_name       = "${azurerm_resource_group.hub-vnet-rg.name}"
  virtual_network_name      = "${azurerm_virtual_network.hub-vnet.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.spoke1-vnet.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
  depends_on = ["azurerm_virtual_network.spoke1-vnet", "azurerm_virtual_network.hub-vnet"]
}

#resource "azurerm_subnet_network_security_group_association" "spoke1nsglink" {
#  subnet_id                 = "${azurerm_subnet.spoke1-mgmt.id}"
#  network_security_group_id = "${azurerm_network_security_group.spoke1nsg.id}"
#  depends_on = ["azurerm_virtual_network.spoke1-vnet", "azurerm_subnet.spoke1-mgmt", "azurerm_network_security_group.spoke1nsg"]
#}
