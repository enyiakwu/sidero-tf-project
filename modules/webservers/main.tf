resource "aws_instance" "production_server" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    type = "ssh"
    # The default username for our AMI
    user = "ubuntu"
    host = self.public_ip
    # The connection will use the local SSH agent for authentication.
  }
  availability_zone = var.aws_availability_zone

  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = var.aws_amis[var.aws_region]

  # The name of our SSH keypair we created above.
  key_name = "oregon"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = [aws_security_group.production_vpc_sg.id]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = aws_subnet.public[0].id

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo apt-get install cloud-utils -y
                EC2_INSTANCE_ID=$(ec2metadata --instance-id)
                sudo echo "Page is hosted in instance id $EC2_INSTANCE_ID" > /var/www/html/index.html
                EOF

}