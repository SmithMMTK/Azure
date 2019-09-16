locals {
  vm-location       = "southeastasia"
  vm-resource-group = "azTrVm"
  vm-vnet-name = "myVnet"
  vm-address-space = "10.10.0.0/16"
  vm-address-subnet = "10.10.0.0/24"
  
  vm-name = "vm1"
  
  vm-ssh-key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzTaBCVGCQn57Yd1s/cUwXB73BmW2hDTf6lBNKF5135H1p6FKDZxynAOKGX+jWMVqGsdQtdpOhYx6w/vNJxcK2zlD0gY/GoI8JxoxGayKiQe1OgNaepI7Iwl4LkpvRTeBDmL95o7o//qzJMFIo3USpdkfK/1CGeOmVMrxHgCVgQV4DF525zRDIDxAKiaBfrfPvskyrVf5fjwthmdKeZCYT4xTCSDCt/6lpr7p5LTXF5fBrNaA1Jix5lJu16A1qL3a0A2gOf/HhenLsnpPI6fO4GGS/UsTqeR2uvhfa+YZQ94cVQ7zoaR130zmeCm08E17jAxLE/H0O1d03Bijz40eV smithm@smmb.local"
  
}

# Create Resource Group
resource "azurerm_resource_group" "myterraformgroup" {
    name     =  "${local.vm-resource-group}"
    location = "${local.vm-location}"

    tags = {
        environment = "Terraform Demo"
    }
}

# Create Virtual Network
resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "${local.vm-vnet-name}"
    address_space       = ["${local.vm-address-space}"]
    location            = "${local.vm-location}"
    resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"

    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "mySubnet"
    resource_group_name  = "${azurerm_resource_group.myterraformgroup.name}"
    virtual_network_name = "${azurerm_virtual_network.myterraformnetwork.name}"
    address_prefix       = "${local.vm-address-subnet}"
}

# Create public IP address
resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "myPublicIP-${local.vm-name}"
    location                     = "${local.vm-location}"
    resource_group_name          = "${azurerm_resource_group.myterraformgroup.name}"
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform Demo"
    }
}

# Create Network Security Group
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "myNetworkSecurityGroup"
    location            = "${local.vm-location}"
    resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
    
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

    tags = {
        environment = "Terraform Demo"
    }
}

# Create virtual network interface card
resource "azurerm_network_interface" "myterraformnic" {
    name                = "myNIC-${local.vm-name}"
    location            = "${local.vm-location}"
    resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
    network_security_group_id = "${azurerm_network_security_group.myterraformnsg.id}"

    ip_configuration {
        name                          = "myNicConfiguration-${local.vm-name}"
        subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.myterraformpublicip.id}"
    }

    tags = {
        environment = "Terraform Demo"
    }
}

resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.myterraformgroup.name}"
    }
    
    byte_length = 8
}

resource "azurerm_storage_account" "mystorageaccount" {
    name                = "diag${random_id.randomId.hex}"
    resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
    location            = "${local.vm-location}"
    account_replication_type = "LRS"
    account_tier = "Standard"

    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_virtual_machine" "myterraformvm" {
    name                  = "${local.vm-name}"
    location              = "${local.vm-location}"
    resource_group_name   = "${azurerm_resource_group.myterraformgroup.name}"
    network_interface_ids = ["${azurerm_network_interface.myterraformnic.id}"]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "${local.vm-name}"
        admin_username = "azureuser"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
            key_data = "${local.vm-ssh-key}"
        }
    }

    boot_diagnostics {
        enabled     = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

    tags = {
        environment = "Terraform Demo"
    }
}

