

output "Web_public_ip" {
  value = aws_instance.webserver.public_ip
}

output "Mysql_Instance_id" {
  value = aws_instance.demo_vpc_mysql.id
}

