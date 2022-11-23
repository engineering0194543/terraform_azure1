variable "resource_group_name" {
  type        = string
  default = "myTFResourceGroup"
}

variable "storage_account" {
  type        = string
  default     = "mytfst"
  description = "storage account name in myTFResourceGroup"
}

output "mergeRgSt" {
    value = merge(var.resource_group_name, var.storage_account)
}

# merge function- combining om concatinating two variable values to make one name 
# look up merge functions on terrform registry