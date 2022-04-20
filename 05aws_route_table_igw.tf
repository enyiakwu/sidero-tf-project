# Creating a Routing Table
resource "aws_route_table" "demo_vpc_igw_rt" {
  vpc_id = data.aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_vpc_ig.id
  }

  tags = {
    Name        = "Demo_vpc_rt"
    description = "Route table for inbound traffic to vpc"
  }

  depends_on = [
    #by now you probably get the point but check files 01, 02, & 03 for dependcies
    data.aws_vpc.demo_vpc,
    aws_internet_gateway.demo_vpc_ig,
    aws_subnet.demo_vpc_public_sg
  ]
}
