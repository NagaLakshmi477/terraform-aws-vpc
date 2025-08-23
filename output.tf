output "vpc_id" {
  value = aws_vpc.main.id
}

#this is public subnet for roboshop
output "public_subnet_ids" {
  
  value = aws_subnet.public[*].id
}