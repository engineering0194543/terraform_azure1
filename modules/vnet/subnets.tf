# Create subnet
resource "azurerm_subnet" "subnet" {
  for_each = var.config
  name                 = "sb-${each.key}-${each.value.subnet_CIDR}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet[each.key].name
  address_prefixes       = [each.value.subnet_CIDR]
}