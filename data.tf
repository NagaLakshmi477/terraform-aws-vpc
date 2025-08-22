data "aws_availability_zones" "available"{
    state = "available"
}


output "az_info" {
  value = data.aws_availability_zones.available
}