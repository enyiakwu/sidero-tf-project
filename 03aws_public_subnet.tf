# Creating a public subnet
resource "aws_subnet" "demo_vpc_public_sg" {
  count                   = var.availability_zones_count
  vpc_id                  = data.aws_vpc.demo_vpc.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, count.index)
  map_public_ip_on_launch = "true"

  tags = {
    Name = "demo-vpc-public-subnet"
  }
  depends_on = [
    #here you will see two dependencies see files 01 & 02 for these dependencies
    data.aws_vpc.demo_vpc,
    aws_internet_gateway.demo_vpc_ig
  ]
}