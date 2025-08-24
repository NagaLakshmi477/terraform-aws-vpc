output "vpc_id" {
  value = aws_vpc.main.id
}

#this is public subnet for roboshop
output "public_subnet_ids" {
  
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  
  value = aws_subnet.private[*].id
}


output "database_subnet_ids" {
  
  value = aws_subnet.database[*].id
}