# Create public IPs
resource "azurerm_public_ip" "public_ip" {
  name                         = "publicIP"
  location                     = "eastus"
  resource_group_name          = azurerm_resource_group.rg.name
  allocation_method            = "Dynamic"

  tags = {
    environment = "Terraform_vnets"
  }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  for_each = var.config
  name                      = "nic"
  location                  = "eastus"
  resource_group_name       = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic_conf"
    subnet_id                     = azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  tags = {
    environment = "Terraform_vnets"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "sg-nic_connect" {
  for_each = var.config
  network_interface_id      = azurerm_network_interface.nic[each.key].id
  network_security_group_id = azurerm_network_security_group.sg.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.config
  name                  = "vm-${each.key}-${each.value.name}"
  location              = "eastus"
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]
  size                  = "each.value.size"

  os_disk {
    name              = "myOsDisk1"
    caching           = "ReadWrite"
    storage_account_type = "Premium_LRS"

    }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name  = "vm"
  admin_username = "azureuser"
  disable_password_authentication = true

//      admin_ssh_key {
//          username       = "azureuser"
//          public_key     = "tls_private_key.ssh.public_key_openssh"
//      }

  tags = {
    environment = "vm-${each.key}-${each.value.environment}"
  }
}