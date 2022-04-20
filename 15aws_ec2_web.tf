resource "aws_instance" "webserver" {
  ami           = var.aws_amis[var.aws_region] #region specific
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name #depends on file 13
  subnet_id     = aws_subnet.demo_vpc_public_sg[0].id   #depends on file 03
  user_data     = <<-EOF
	              #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo apt-get install cloud-utils -y
                EC2_INSTANCE_ID=$(ec2metadata --instance-id)
                sudo echo "Page is hosted in instance id $EC2_INSTANCE_ID" > /var/www/html/index.html
                EOF

  vpc_security_group_ids = [
    #depends on file 11
    aws_security_group.demovpcwebSG.id
  ]

  tags = {
    Name = "Webserver"
  }

  depends_on = [
    #depends on file 14
    aws_instance.demo_vpc_mysql
  ]
}

