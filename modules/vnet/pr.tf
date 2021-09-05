# Virtual network peering
resource "azurerm_virtual_network_peering" "vnet_1-2" {
  for_each = var.config
  name                      = "peer1to2"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet[each.key][0].name
  remote_virtual_network_id = azurerm_virtual_network.vnet[each.key][1].id
}

resource "azurerm_virtual_network_peering" "vnet_2-1" {
  for_each = var.config
  name                      = "peer2to1"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet[each.key][1].name
  remote_virtual_network_id = azurerm_virtual_network.vnet[each.key][0].id
}

