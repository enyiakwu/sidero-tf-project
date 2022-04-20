# Creating an Internet Gateway
resource "aws_internet_gateway" "demo_vpc_ig" {
  vpc_id = data.aws_vpc.demo_vpc.id

  tags = {
    Name        = "demo-igw"
    description = "Allows connection to VPC and EC2 instance present in public subnet."
  }

  depends_on = [
    #refer to file aws_vpc.tf for this dependency
    data.aws_vpc.demo_vpc
  ]
}

