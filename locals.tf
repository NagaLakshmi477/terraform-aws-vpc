locals {
  common_tags = {
    Project = var.project
    Environment = var.environment
    Terraform = "true"
  }
  azs_info =slice(data.aws_availability_zones.available.names,0,2)
}