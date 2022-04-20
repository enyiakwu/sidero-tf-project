
resource "aws_instance" "demo_vpc_mysql" {
	ami           = var.aws_amis[var.aws_region]  # Lookup the correct AMI based on the region we specified
	instance_type = "t2.micro"
	key_name 	  = aws_key_pair.deployer.key_name #depends on file 13
	subnet_id 	  = aws_subnet.demo_vpc_private_sg1[0].id #depends on file 4
  user_data     = <<EOF
	  #!/bin/bash 
    sudo wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm 
    sudo yum localinstall mysql57-community-release-el7-11.noarch.rpm
    sudo yum install mysql-community-server
    sudo systemctl start mysqld.service
EOF
	
	vpc_security_group_ids = [
		#depends on file 12
		aws_security_group.demovpcdbSG.id
	]
	
	tags = {
		Name = "MysqlDB"
	}

	

	depends_on = [
		#depends on file 13
		aws_key_pair.deployer
	]
}
