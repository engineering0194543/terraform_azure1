//Create resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg"
  location = "eastus"

  tags = {
    environment = "Terraform_vnets"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  for_each = var.config
  name                = each.value.vnet_name
  address_space       = [each.value.vnet_CIDR]
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = "Terraform_vnets"
  }
}

