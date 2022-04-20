# Generating a private_key
resource "tls_private_key" "demovpckey" {
  algorithm = "RSA"
  rsa_bits  = 4096
  depends_on = [
    #check file 12 for dependency
    aws_security_group.demovpcdbSG
  ]
}

resource "local_file" "private-key" {
  content  = tls_private_key.demovpckey.private_key_pem
  filename = "demovpckey.pem" #naming our key pair so that we can connect via ssh into our instances
}

resource "aws_key_pair" "deployer" {
  key_name   = "demovpckey"
  public_key = tls_private_key.demovpckey.public_key_openssh
  depends_on = [
    #check the resource at the top as this block depends on line 2
    tls_private_key.demovpckey
  ]
}