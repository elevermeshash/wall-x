resource "azurerm_public_ip" "am1_public_ip" {
  name                = "am1-public_ip"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  allocation_method   = "Dynamic"
}
resource "azurerm_public_ip" "am2_public_ip" {
  name                = "am2-public_ip"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "am-1_user" {
  name                = "am-1_user-nic"
  location            = var.az_location
  resource_group_name = var.az_resource_group_name

  ip_configuration {
    name                          = "am1-user"
    subnet_id                     = azurerm_subnet.USER_AM.id
    private_ip_address_allocation = "Dynamic"
  }

}
resource "azurerm_network_interface" "am-2_user" {
  name                = "am-2_user-nic"
  location            = var.az_location
  resource_group_name = var.az_resource_group_name

  ip_configuration {
    name                          = "am2-user"
    subnet_id                     = azurerm_subnet.USER_AM.id
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurerm_network_interface" "am-1_admin" {
  name                = "am-1_admin-nic"
  location            = var.az_location
  resource_group_name = var.az_resource_group_name

  ip_configuration {
    name                          = "am1-admin"
    subnet_id                     = azurerm_subnet.ADMIN_AM.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.am1_public_ip.id
  }

}
resource "azurerm_network_interface" "am-2_admin" {
  name                = "am-2_admin-nic"
  location            = var.az_location
  resource_group_name = var.az_resource_group_name

  ip_configuration {
    name                          = "am2-admin"
    subnet_id                     = azurerm_subnet.ADMIN_AM.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.am2_public_ip.id
  }

}


resource "azurerm_network_interface" "am-1_ha" {
  name                = "am-1_ha-nic"
  location            = var.az_location
  resource_group_name = var.az_resource_group_name

  ip_configuration {
    name                          = "am1-ha"
    subnet_id                     = azurerm_subnet.HA_AM.id
    private_ip_address_allocation = "Dynamic"
  }

}
resource "azurerm_network_interface" "am-2_ha" {
  name                = "am-2_ha-nic"
  location            = var.az_location
  resource_group_name = var.az_resource_group_name

  ip_configuration {
    name                          = "am2-ha"
    subnet_id                     = azurerm_subnet.HA_AM.id
    private_ip_address_allocation = "Dynamic"
  }

}
/*
resource "azurerm_marketplace_agreement" "barracuda" {
  publisher = "wallix"
  offer     = "wallixaccessmanager"
  plan      = "BYOL"
}
*/

resource "azurerm_linux_virtual_machine" "am1" {
  name                = "am1"
  resource_group_name = var.az_resource_group_name
  location            = var.az_location
  size                = "Standard_B2ms"

  admin_username                  = "wabadmin"
  admin_password                  = random_password.AM.result
  disable_password_authentication = false
  custom_data                     = data.cloudinit_config.cloudinit.rendered


  admin_ssh_key {
    username   = "wabadmin"
    public_key = tls_private_key.rsa-4096.public_key_openssh
  }

  network_interface_ids = [
    azurerm_network_interface.am-1_admin.id,
    azurerm_network_interface.am-1_user.id,
    azurerm_network_interface.am-1_ha.id,

  ]

  plan {
    publisher = "wallix"
    product   = "wallixaccessmanager"
    name      = "accessmanager-4"
  }

  source_image_reference {
    publisher = "wallix"
    offer     = "wallixaccessmanager"
    sku       = "accessmanager-4"
    version   = "4.0.3"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = var.tags

}


resource "azurerm_linux_virtual_machine" "am2" {
  name                = "am2"
  resource_group_name = var.az_resource_group_name
  location            = var.az_location
  size                = "Standard_B2ms"

  admin_username                  = "wabadmin"
  admin_password                  = random_password.AM.result
  disable_password_authentication = false
  custom_data                     = data.cloudinit_config.cloudinit.rendered


  admin_ssh_key {
    username   = "wabadmin"
    public_key = tls_private_key.rsa-4096.public_key_openssh
  }

  network_interface_ids = [

    azurerm_network_interface.am-2_user.id,
    azurerm_network_interface.am-2_ha.id,
    azurerm_network_interface.am-2_admin.id,
  ]

  plan {
    publisher = "wallix"
    product   = "wallixaccessmanager"
    name      = "accessmanager-4"
  }

  source_image_reference {
    publisher = "wallix"
    offer     = "wallixaccessmanager"
    sku       = "accessmanager-4"
    version   = "4.0.3"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = var.tags

}