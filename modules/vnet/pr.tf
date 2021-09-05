# Virtual network peering
//resource "azurerm_virtual_network_peering" "vnet_1-2" {
//  for_each = var.config
//  name                      = "peer1to2"
//  resource_group_name       = azurerm_resource_group.rg.name
//  virtual_network_name      = azurerm_virtual_network.vnet.name
//  remote_virtual_network_id = azurerm_virtual_network.vnet[1].id
//}

resource "azurerm_virtual_network_peering" "peering" {
  count = 2
  name                      = "peering-to-${element(azurerm_virtual_network.vnet.*.name, 1 - count.index)}"
  resource_group_name       = element(azurerm_resource_group.rg.*.name, count.index)
  virtual_network_name      = element(azurerm_virtual_network.vnet.*.name, count.index)
  remote_virtual_network_id = element(azurerm_virtual_network.vnet.*.id, 1 - count.index)
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}