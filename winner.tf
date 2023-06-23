resource "null_resource" "withsshkey" {
  provisioner "local-exec" {
    command = "ssh -p 2241 wabsuper@wall-x.bzhack.bzh"
  }
}