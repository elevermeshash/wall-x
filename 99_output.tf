output "am_vnet" {
  value = azurerm_virtual_network.AM.subnet
}

output "am_user_subnet" {
  value = azurerm_subnet.USER_AM.address_prefixes
}

output "am_admin_subnet" {
  value = azurerm_subnet.ADMIN_AM.address_prefixes

}

output "am_ha_subnet" {
  value = azurerm_subnet.HA_AM.address_prefixes
}

output "network_info_am-1" {
  value = {
    "public_ip"          = "${azurerm_public_ip.am1_public_ip.ip_address}",
    "user_nic_user_ip"   = "${azurerm_network_interface.am-1_user.private_ip_address}"
    "user_nic_user_mac"  = "${azurerm_network_interface.am-1_user.mac_address}"
    "user_nic_ha_ip"     = "${azurerm_network_interface.am-1_ha.private_ip_address}"
    "user_nic_ha_mac"    = "${azurerm_network_interface.am-1_ha.mac_address}"
    "user_nic_admin_ip"  = "${azurerm_network_interface.am-1_admin.private_ip_address}"
    "user_nic_admin_mac" = "${azurerm_network_interface.am-1_admin.mac_address}"
  }

}

output "network_info_am-2" {
  value = {
    "public_ip"          = "${azurerm_public_ip.am2_public_ip.ip_address}",
    "user_nic_user_ip"   = "${azurerm_network_interface.am-2_user.private_ip_address}"
    "user_nic_user_mac"  = "${azurerm_network_interface.am-2_user.mac_address}"
    "user_nic_ha_ip"     = "${azurerm_network_interface.am-2_ha.private_ip_address}"
    "user_nic_ha_mac"    = "${azurerm_network_interface.am-2_ha.mac_address}"
    "user_nic_admin_ip"  = "${azurerm_network_interface.am-2_admin.private_ip_address}"
    "user_nic_admin_mac" = "${azurerm_network_interface.am-2_admin.mac_address}"
  }

}

output "your_public_ip" {
  value = local.external_ip
}

output "allowed_ip" {
  value = local.allowed_ips
}