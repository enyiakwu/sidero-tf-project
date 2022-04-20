# Create a VPC in the same Availability Zone
# resource "aws_vpc" "demo" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_support   = "true"
#   enable_dns_hostnames = "true"
#   instance_tenancy     = "default"
#   tags = {
#     Name = "Tf-vpc"
#   }
# }

data "aws_vpc" "demo_vpc" {
  id = var.vpc_id
}

data "aws_availability_zones" "available" {
  state = "available"
}