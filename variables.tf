variable "project" {
  type = string
}
variable "environment" {
  type = string
}
variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type = list(string)
  
}
variable "private_subnet_cidr" {
  type = list(string)
  
}
variable "database_subnet_cidr" {
  type = list(string)
  
}
#optinal
variable "vpc_tags" {
  type = map(string)
  default = {}
}

variable "igw_tags" {
  type = map(string)
  default = {}
}
variable "pub_subnet_tags" {
  type = map(string)
  default = {}
}
variable "public_subnet_cidrs" {
  type = map(string)
  default = {}
}

variable "private_subnet_tags" {
  type = map(string)
  default = {}
}
variable "private_subnet_cidrs" {
  type = map(string)
  default = {}
}

variable "data_subnet_tags" {
  type = map(string)
  default = {}
}
variable "database_subnet_cidrs" {
  type = map(string)
  default = {}
}


variable "pub_route_tags" {
  type = map(string)
  default = {}
}

variable "private_route_tags" {
  type = map(string)
  default = {}
}
variable "database_route_tags" {
  type = map(string)
  default = {}
}

variable "eip_tags" {
  type = map(string)
  default = {}
}

variable "nat_tags" {
  type = map(string)
  default = {}
}

variable "is_peering_required" {
  default = false
}

variable "vpc_peering_tags" {
  type = map(string)
  default = {}
}