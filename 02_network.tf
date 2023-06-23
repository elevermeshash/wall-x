# Virtual Network

# Get my public IP

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

# Locals

locals {
  AM_Subnets = cidrsubnets(azurerm_virtual_network.AM.address_space[0], 4, 4, 4)
  #Bastion_Subnets = cidrsubnets(azurerm_virtual_network.BASTION.address_prefixes[0], 8, 8)

  external_ip = toset(["${chomp(data.http.myip.response_body)}"])
  allowed_ips = setunion("${local.external_ip}", "${var.extra_allowed_ips}")
}

resource "azurerm_virtual_network" "AM" {
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  name                = var.user_virtual_network_name
  address_space       = var.user_vnet_address_space

}

resource "azurerm_subnet" "USER_AM" {
  name                 = "subnet_AM_user"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.AM.name
  address_prefixes     = ["${local.AM_Subnets[0]}"]

}

resource "azurerm_subnet" "HA_AM" {
  name                 = "subnet_AM_HA"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.AM.name
  address_prefixes     = ["${local.AM_Subnets[1]}"]

}
resource "azurerm_subnet" "ADMIN_AM" {
  name                 = "subnet_AM_admin"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.AM.name
  address_prefixes     = ["${local.AM_Subnets[2]}"]

}


resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-testBSI_AM"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  security_rule {
    name                       = "allow-https"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefixes    = local.allowed_ips
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-http"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefixes    = local.allowed_ips
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-ssh-admin"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "2242"
    source_address_prefixes    = local.allowed_ips
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-ssh"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = var.allowed_ip
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow-rdp"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefixes    = var.allowed_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-mysql"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefixes    = azurerm_subnet.HA_AM.address_prefixes
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-mysql"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3307"
    source_address_prefixes    = azurerm_subnet.HA_AM.address_prefixes
    destination_address_prefix = "*"
  }


}

resource "azurerm_subnet_network_security_group_association" "sga_am_admin" {
  subnet_id                 = azurerm_subnet.ADMIN_AM.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "sga_am_user" {
  subnet_id                 = azurerm_subnet.USER_AM.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "sga_am_HA" {
  subnet_id                 = azurerm_subnet.HA_AM.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}