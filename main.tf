# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

locals {
  tags = {
    environment = "Lab"
    owner = "Teekay"
  }
}

resource "azurerm_resource_group" "tk-rg" {
  name     = var.resource_group_name
  location = "East US2"
  tags = {
    "Environment" = "Test"
    "Team"        = "DevOps"
  }
}

resource "azurerm_storage_account" "tk-st" {
  name                     = var.storage_account
  resource_group_name      = azurerm_resource_group.tk-rg.name
  location                 = azurerm_resource_group.tk-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.tags
}

resource "azurerm_virtual_network" "tk-vnet" {
  name                = var.virtual_network
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.tk-rg.location
  resource_group_name = azurerm_resource_group.tk-rg.name
}

resource "azurerm_subnet" "tk-subnet" {
  name                 = "mytfsubnet"
  resource_group_name  = azurerm_resource_group.tk-rg.name
  virtual_network_name = azurerm_virtual_network.tk-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "tk-nic" {
  name                = "mytfnic"
  location            = azurerm_resource_group.tk-rg.location
  resource_group_name = azurerm_resource_group.tk-rg.name

  ip_configuration {
    name                          = "mytfsubnet"
    subnet_id                     = azurerm_subnet.tk-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "tk-vm" {
  name                = var.virtual_Machine
  resource_group_name = azurerm_resource_group.tk-rg.name
  location            = azurerm_resource_group.tk-rg.location
  size                = "Standard_F2"
  admin_username      = "teekayvm"
  admin_password      = "Tk@12345"
  network_interface_ids = [
    azurerm_network_interface.tk-nic.id,
  ]
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  tags = var.vm_tags
}

resource "azurerm_mssql_server" "tk-server" {
  name                         = var.mssql_server
  resource_group_name          = azurerm_resource_group.tk-rg.name
  location                     = azurerm_resource_group.tk-rg.location
  version                      = "12.0"
  administrator_login          = "teekaysv"
  administrator_login_password = "Tk@12345"
}

resource "azurerm_mssql_firewall_rule" "tk-fw" {
  name = var.mssql_firewall
  server_id = azurerm_mssql_server.tk-server.id
  start_ip_address = "10.0.0.0"
  end_ip_address = "10.0.255.255"
} 

resource "azurerm_mssql_database" "tk-sqldb" {
  name           = var.mssql_database
  server_id      = azurerm_mssql_server.tk-server.id
  license_type   = "LicenseIncluded"
  sku_name       = "S0" 
  tags = var.sqldb_tags
}

resource "azurerm_cosmosdb_account" "tk-acc" {
  name = var.cosmodb_acc
  location = azurerm_resource_group.tk-rg.location
  resource_group_name = azurerm_resource_group.tk-rg.name
  offer_type = "Standard"
  kind = "GlobalDocumentDB"
  enable_automatic_failover = true
  consistency_policy {
    consistency_level = "Session"
  }
  geo_location {
    location = azurerm_resource_group.tk-rg.location
    failover_priority = 0
  }
  geo_location {
    location = "West US"
    failover_priority = 1
  }
}

resource "azurerm_cosmosdb_sql_database" "tk-cosmsodb" {
  name = var.cosmosdb
  resource_group_name = azurerm_resource_group.tk-rg.name
  account_name = azurerm_cosmosdb_account.tk-acc.name
}

resource "azurerm_cosmosdb_sql_container" "tk-cn" {
  name = var.cosmosdb_cn
  resource_group_name = azurerm_resource_group.tk-rg.name
  account_name = azurerm_cosmosdb_account.tk-acc.name
  database_name = azurerm_cosmosdb_sql_database.tk-cosmsodb.name
  partition_key_path = "/definition/id"
}

# below is a sample for app service plan and its dependencies with 2 tier app

resource "azurerm_resource_group" "AppStg" {
  name     = var.resource_group_name
  location = "westus"
  
  tags = {
    "Environment" = "2tier App Service"
  }
}

resource "azurerm_app_service_plan" "main" {
  name                = "tkappplan"
  location            = "${azurerm_resource_group.AppStg.location}"
  resource_group_name = "${azurerm_resource_group.AppStg.name}"
  
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "mainapp" {
  name                  = "tkapp"
  location              = "${azurerm_resource_group.AppStg.location}"
  resource_group_name   = "${azurerm_resource_group.AppStg.name }"
  app_service_plan_id   = "${azurerm_app_service_plan.main.id}"

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type = "LocalGit"
  }

  connection_string {
    name    = "Database"
    type    = "SQLServer"
    value   = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}

resource "azurerm_storage_account" "appstg" {
  name                     = "appservicestg"
  location                 = "${azurerm_resource_group.AppStg.location}"
  resource_group_name      = "${azurerm_resource_group.AppStg.name }"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_server" "main" {
  name                         = "appdbserver"
  location                     = "${azurerm_resource_group.AppStg.location}"
  resource_group_name          = "${azurerm_resource_group.AppStg.name }"
  version                      = "12.0"
  administrator_login          = "teekaysv"
  administrator_login_password = "Tk@12345"
}

resource "azurerm_sql_database" "main" {
  name                = "appdb"
  location            = "${azurerm_resource_group.AppStg.location}"
  resource_group_name = "${azurerm_resource_group.AppStg.name }"
  server_name         = "${azurerm_sql_server.main.name}"
}
#End


