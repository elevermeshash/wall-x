# Generate a random Password
resource "random_password" "AM" {
  length           = 16
  special          = true
  min_special      = 2
  min_upper        = 2
  min_numeric      = 2
  override_special = "_%@|/"
}

# Generate SSH Key
resource "tls_private_key" "rsa-4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.rsa-4096.private_key_pem
  filename        = "ssh_private_key.pem"
  file_permission = "0600"
}

# Render template with variables
data "template_file" "cloudinit" {
  template = file("${path.module}/cloud-init-conf.tpl")

  vars = {
    wabadmin_password   = random_password.AM.result
    wabsuper_password   = random_password.AM.result
    wabupgrade_password = random_password.AM.result
  }

}

# Generate a base64 encoded cloud init file form Rendered template
data "cloudinit_config" "cloudinit" {
  gzip          = false
  base64_encode = true
  part {
    filename     = "cloud-init-conf.yaml"
    content_type = "text/cloud-config"
    content      = data.template_file.cloudinit.rendered
  }
}

# Uncomment to auto-accept Wallix Agreement on the marketplace
/*
resource "azurerm_marketplace_agreement" "wallix" {
  publisher = "wallix"
  offer     = "wallixaccessmanager"
  plan      = "BYOL"
}
*/

data "azurerm_resource_group" "resource_group" {
  name = var.az_resource_group_name
}