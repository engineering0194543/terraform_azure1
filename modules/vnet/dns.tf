# DNS A Records
resource "azurerm_private_dns_zone" "dns_zone" {
  name                = "EIS.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_a_record" "dns_a_record" {
  for_each = var.config
  name                = "dns"
  zone_name           = azurerm_private_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = azurerm_network_interface.nic[each.key].private_ip_address
}

resource "azurerm_private_dns_zone_virtual_network_link" "privateDNS" {
  for_each = var.config
  name                  = "privateDNS"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet[each.key].id
}