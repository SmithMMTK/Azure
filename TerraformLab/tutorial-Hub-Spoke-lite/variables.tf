variable "location" {
  description = "Location of the network"
  default     = "southeastasia"
}

variable "username" {
  description = "Username for Virtual Machines"
  default     = "azureuser"
}

variable "password" {
  description = "Password for Virtual Machines"
  default     = "Password1234!"
}

variable "vmsize" {
  description = "Size of the VMs"
  default     = "Standard_DS1_v2"
}

variable "rg_name" {
  description = "Resource Group Name to host resources"
  default = "az-Tf-VNET5"
}