provider "azurerm" {
}
resource "azurerm_resource_group" "rg" {
  location = "southeastasia"
  name = "az-Tf-VNET5-1-3"
}