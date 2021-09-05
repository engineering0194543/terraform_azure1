//# Create virtual machine
//resource "azurerm_linux_virtual_machine" "vm" {
//  name                  = "vm1"
//  location              = "eastus"
//  resource_group_name   = "azurerm_resource_group.rg.name"
//  network_interface_ids = [azurerm_network_interface.nic.id]
//  size                  = "Standard_DS1_v2"
//
//  os_disk {
//    name              = "myOsDisk1"
//    caching           = "ReadWrite"
//    storage_account_type = "Premium_LRS"
//  }
//
//  source_image_reference {
//    publisher = "Canonical"
//    offer     = "UbuntuServer"
//    sku       = "18.04-LTS"
//    version   = "latest"
//  }
//
//  computer_name  = "vm"
//  admin_username = "azureuser"
//  disable_password_authentication = true
//
//  //    admin_ssh_key {
//  //        username       = "azureuser"
//  //        public_key     = tls_private_key.example_ssh.public_key_openssh
//  //    }
//  //
//  //    boot_diagnostics {
//  //        storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
//  //    }
//
//  tags = {
//    environment = "Terraform_vnets"
//  }
//}