resource "aws_nat_gateway" "demo_vpc_nat" {
  #Elastic ip creation being allocated here
  allocation_id = aws_eip.demo_vpc_eip.id
  #nat gateways reside in the public subnet so we are associating it with the public subnet id
  subnet_id = aws_subnet.demo_vpc_public_sg[0].id

  tags = {
    Name = "demo_vpc_NAT"
  }

  depends_on = [
    #check file 07 for the dependency
    aws_eip.demo_vpc_eip
  ]
}