resource "aws_route_table" "nat_rt" {
  #check file 01
  vpc_id = data.aws_vpc.demo_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.demo_vpc_nat.id
  }

  tags = {
    Name        = "NAT-RouteTable"
    description = "Route table for outbound traffic to private subnet"
  }

  depends_on = [
    #check file 08 for dependency 
    aws_nat_gateway.demo_vpc_nat
  ]
}

