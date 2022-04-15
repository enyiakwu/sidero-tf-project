terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket         = "sidero-backend-artifacts"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Create a VPC to launch our instances into
resource "aws_vpc" "production_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.production_vpc.id
  depends_on = [
    aws_vpc.production_vpc
  ]

}

# Grant the VPC internet access on its main route table
resource "aws_route" "production_rt" {
  route_table_id         = aws_vpc.production_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public.id
}

# Create a subnet to launch our instances into
resource "aws_subnet" "public" {
  count                   = var.availability_zones_count
  vpc_id                  = aws_vpc.production_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

}

# Create a private subnet for our instances
resource "aws_subnet" "private" {
  count = var.availability_zones_count
  vpc_id                  = aws_vpc.production_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, count.index + var.availability_zones_count)
  availability_zone       = data.aws_availability_zones.available.names[count.index]

}

# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "elb_sg" {
  name        = "Production VPC LB"
  description = "Used to give the infrasture on this vpc traffic from the web"
  vpc_id      = aws_vpc.production_vpc.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "production_vpc_sg" {
  name        = "default_securitygroup"
  description = "used to access the instance via ssh and http protocol"
  vpc_id      = aws_vpc.production_vpc.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # HTTPS access from the VPC
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "web" {
  # name = "terraform-example-elb"

  subnets         = [aws_subnet.public[0].id]
  security_groups = [aws_security_group.elb_sg.id]
  instances       = [aws_instance.production_server.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}


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
  key_name = var.key_name

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

resource "aws_s3_bucket" "sid_bucket_artifacts" {
  bucket = var.artifacts_bucket_name
  force_destroy = true

}

resource "aws_s3_bucket_acl" "artifact_bucket_acl" {
  bucket = aws_s3_bucket.sid_bucket_artifacts.id
  acl    = "private"

}

resource "aws_s3_bucket_versioning" "artifact_bucket_versioning" {
  bucket = aws_s3_bucket.sid_bucket_artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}
