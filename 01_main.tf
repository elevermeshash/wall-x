# Use a given resource group
data "azurerm_resource_group" "resource_group" {
  name = var.az_resource_group_name

}

data "template_file" "cloudinit" {
  template = file("${path.module}/cloud-init-conf.tpl")

  vars = {
    wabadmin_password   = var.wabadmin_password
    wabsuper_password   = var.wabsuper_password
    wabupgrade_password = var.wabupgrade_password
  }

}

data "cloudinit_config" "cloudinit" {
  gzip          = false
  base64_encode = true
  part {
    filename     = "cloud-init-conf.yaml"
    content_type = "text/cloud-config"
    content      = data.template_file.cloudinit.rendered
  }
}

resource "tls_private_key" "rsa-4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.rsa-4096.private_key_pem
  filename        = "ssh_private_key.pem"
  file_permission = "0600"
}