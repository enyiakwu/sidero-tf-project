resource "aws_eip" "demo_vpc_eip" {
  vpc = true
  tags = {
    Name = "demo_vpc_eip"
  }
  depends_on = [
    #dependency check file 05
    aws_route_table_association.assoc1
  ]
}