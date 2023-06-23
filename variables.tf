variable "az_resource_group_name" {
  description = "Specifies the name of the Resource Group in which the objects should exist"
  type        = string
}

variable "az_location" {
  description = "Specifies the location in which the objects should exist"
  type        = string
  default     = "francecentral"
}

variable "user_virtual_network_name" {
  description = "Specifies the name of an existing Virtual Network in which the objects should exist"
  type        = string
  default     = "Wallix-user-network"
}

variable "admin_virtual_network_name" {
  description = "Specifies the name of the Virtual Network in which the objects should exist"
  type        = string
  default     = "Wallix-admin-network"
}

variable "ha_virtual_network_name" {
  description = "Specifies the name of the Virtual Network in which the objects should exist"
  type        = string
  default     = "Wallix-HA-network"
}


variable "user_vnet_address_space" {
  description = "Specifies the name of the Virtual Network in which the objects should exist"
  type        = list(any)
  default     = ["10.6.0.0/24"]

}

variable "admin_vnet_address_space" {
  description = "Specifies the name of the Virtual Network in which the objects should exist"
  type        = list(any)
  default     = ["10.7.0.0/16"]

}

variable "ha_vnet_address_space" {
  description = "Specifies the name of the Virtual Network in which the objects should exist"
  type        = list(any)
  default     = ["10.8.0.0/16"]

}


variable "wabadmin_password" {
  type      = string
  sensitive = true
}

variable "wabsuper_password" {
  type      = string
  sensitive = true
}

variable "wabupgrade_password" {
  type      = string
  sensitive = true
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "Tags for resources."
}

variable "allowed_ip" {
  type = set(string)
}

variable "extra_allowed_ips" {
  type = set(string)
}

variable "ssh_key" {
  description = "Rather than providing the ssh key block, it is possible to source it using file function or script"
  type        = string
  sensitive   = true
}
