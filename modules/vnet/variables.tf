
variable "config" {
  description = "Map of project names to configuration"
    type        = map
    default     = {
      vm1 = {
        name                  = "vm1",
        vnet_name             = "vnet1",
        location              = "eastus",
        size                  = "Standard_DS1_v2",
        subnet_name           = "public_subnets",
        subnet_CIDR           = "10.0.1.0/24",
        vnet_CIDR             = "10.0.0.0/16",
        instances_per_subnet    = 1,
        instance_type           = "UbuntuServer",
        environment             = "env1"
      },
      vm2 = {
        name                  = "vm2",
        vnet_name             = "vnet2",
        location              = "eastus",
        size                  = "Standard_DS1_v2",
        subnet_name           = "private_subnets",
        subnet_CIDR           = "10.0.2.0/24",
        vnet_CIDR             = "10.1.0.0/16",
        instances_per_subnet    = 1,
        instance_type           = "UbuntuServer",
        environment             = "env2"
      }
    }
}

