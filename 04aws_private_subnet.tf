resource "aws_subnet" "demo_vpc_private_sg1" {
  count                   = var.availability_zones_count
  vpc_id                  = data.aws_vpc.demo_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, count.index + var.availability_zones_count)
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "demo_vpc-private-subnet1"
  }
  depends_on = [
    #for this dependency see file 03
    aws_subnet.demo_vpc_public_sg
  ]

}