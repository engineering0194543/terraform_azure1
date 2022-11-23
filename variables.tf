variable "resource_group_name" {
  type        = string
  default = "myTFResourceGroup"
}

variable "virtual_network" {
  type        = string
  default     = "myTFvnet"
  description = "vnet name in myTFResourceGroup"
}

variable "storage_account" {
  type        = string
  default     = "mytfst"
  description = "storage account name in myTFResourceGroup"
}

variable "virtual_Machine" {
  type        = string
  default     = "myTFvm"
  description = "vm name in myTFResourceGroup"
}

variable "vm_tags" {
  type = object({
    Environment   = string
    Cost          = number
  })
  default = {
    Environment = "Dev"
    Cost        = "1000"
  }
  description = "tags that apply to the vm"
}

variable "mssql_server" {
  type        = string
  default     = "mytfsqlserver"
  description = "server name in myTFResourceGroup"
}

variable "mssql_firewall" {
  type        = string
  default     = "mytfsqlfirewall"
  description = "firewall rule name for the server"
}

variable "mssql_database" {
  type        = string
  default     = "mytfsqlserver"
  description = "database name in myTFResourceGroup"
}

variable "sqldb_tags" {
  type = map
  default = {
    Environment = "devop"
  }
}

variable "cosmodb_acc" {
  type = string
  default = "mytfcosmosacc"
  description = "cosmosdb account name for the cosmosdb"
}

variable "cosmosdb_acc_tag" {
  type = map
  default = {
    Environment = "Production"
  }
  description = "tag name for cosmosdb account "
}

variable "cosmosdb" {
  type = string
  default = "mytfcosmosdb"
  description = "cosmosdb name"
}

variable "cosmosdb_cn" {
  type = string
  default = "mytfcosmosdbcon"
  description = "cosmosdb container for the cosmosdb"
}





# just keep this aside
#variables
#  variable "subscription_id" {}
#  variable "client_id" {}
#  variable "client_secret" {} 
#  variable "tenant_id" {}
#  variable "AUTH_KEY" {}
#  variable "Host" {} 