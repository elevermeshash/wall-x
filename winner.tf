resource "null_resource" "withsshkey" {
command = "ssh -p 2241 wabsuper@wall-x.bzhack.bzh"
}