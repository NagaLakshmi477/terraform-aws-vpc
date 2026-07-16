resource "aws_vpc" "main" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"
    enable_dns_hostnames = "true"
    tags = merge(
        var.vpc_tags,
        local.common_tags,{
            Name = "${var.project}-${var.environment}"
        }
    )
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.igw_tags,
        local.common_tags,{
            Name = "${var.project}-${var.environment}"
        }
    )
}


resource "aws_subnet" "public" {
count = length(var.public_subnet_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = slice( data.aws_availability_zones.available.names,0,2)[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    var.pub_subnet_tags,
        local.common_tags,{
            Name = "${var.project}-${var.environment}-public-${local.az_names[count.index]}"
        }
    )
}


resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  count = length(var.private_subnet_cidr)
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = slice( data.aws_availability_zones.available.names,0,2)[count.index]
   
 tags = merge(
    var.private_subnet_tags,
        local.common_tags,{
            Name = "${var.project}-${var.environment}-private-${local.az_names[count.index]}"
        }
    )
}

resource "aws_subnet" "database" {
  vpc_id = aws_vpc.main.id
  count = length(var.database_subnet_cidr)
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = slice( data.aws_availability_zones.available.names,0,2)[count.index]
   
 tags = merge(
    var.private_subnet_tags,
        local.common_tags,{
            Name = "${var.project}-${var.environment}-database-${local.az_names[count.index]}"
        }
    )
}
# create elasti Ip and attach to NAT

resource "aws_eip" "nat" {
    domain = "vpc"
    tags = merge(
        var.eip_tags,
        local.common_tags,
        {
            Name =  "${var.project}-${var.environment}"
        }
    )
}

# NAT gateway 

resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.public[0].id # taking 1 st avalibily zone
    # To ensure proper ordering, it is recommended to add an explicit dependency
    # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
    tags = merge(
    var.nat_tags,
    local.common_tags,
    {
        Name =  "${var.project}-${var.environment}"
    }
  )
  
}

## route table 
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    
    tags = merge(
        var.pub_route_tags,
      local.common_tags,
       {
         Name =  "${var.project}-${var.environment}-public"
      }
    )   
  
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    
    tags = merge(
        var.private_route_tags,
      local.common_tags,
       {
         Name =  "${var.project}-${var.environment}-private"
      }
    )   
  
}

resource "aws_route_table" "database" {
    vpc_id = aws_vpc.main.id
    
    tags = merge(
        var.database_route_tags,
      local.common_tags,
       {
         Name =  "${var.project}-${var.environment}-database"
      }
    )   
  
}

resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
}

# here we will connect to the natgat beacuse for outbound traffic
resource "aws_route" "private" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main.id
}

resource "aws_route" "database" {
    route_table_id = aws_route_table.database.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main.id
}

# subnet assications

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidr)
  subnet_id = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}