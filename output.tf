output "resource_group_id" {
  value       = azurerm_resource_group.tk-rg.id
  description = "Id for the resource Group"
}

output "storage_location" {
  value       = azurerm_storage_account.tk-st.location
  description = "location of the storage account"
}

output "virtual_machine_username" {
  value       = azurerm_windows_virtual_machine.tk-vm.admin_username
  description = "admin username of the vm"
}

output "mssql_server" {
    value = azurerm_mssql_server.tk-server.id
    description = "microsoft sql server id"
}
output "cosmosdb_account_cs" {
  value       = azurerm_cosmosdb_account.tk-acc.connection_strings
  sensitive = true
  description = "connection string of the cosmosdb account"
}