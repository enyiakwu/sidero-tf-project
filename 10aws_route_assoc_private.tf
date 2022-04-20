resource "aws_route_table_association" "assoc2" {
  #associating the private subnet with its own route table inthis file
  subnet_id      = aws_subnet.demo_vpc_private_sg1[0].id
  route_table_id = aws_route_table.nat_rt.id

  depends_on = [
    #check file 09 for dependency
    aws_route_table.nat_rt
  ]
}