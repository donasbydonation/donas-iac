# VPC
resource "aws_vpc" "main" {
  cidr_block = format("%s.0.0/16", var.vpc_cidr_prefix)

  tags = {
    Name                      = format("%s-main", var.app_name)
    "app.donas.me/tier"       = "production"
    "obj.donas.me/created-by" = "haeram.kim1"
    "obj.donas.me/group"      = "network"
  }
}

# Gateways
## IGW
resource "aws_internet_gateway" "main_1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name                      = format("%s-1", aws_vpc.main.tags.Name)
    "app.donas.me/tier"       = "production"
    "obj.donas.me/created-by" = "haeram.kim1"
    "obj.donas.me/group"      = "network"
  }
}

# Public Subnet
## Route Table
resource "aws_route_table" "main_pub" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name                      = format("%s-pub", aws_vpc.main.tags.Name)
    "app.donas.me/tier"       = "production"
    "arch.donas.me/access"    = "public"
    "arch.donas.me/layer"     = "public"
    "obj.donas.me/created-by" = "haeram.kim1"
    "obj.donas.me/group"      = "network"
  }
}

resource "aws_route" "main_pub" {
  route_table_id         = aws_route_table.main_pub.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_1.id
}

## Subnet - AZ1
resource "aws_subnet" "main_pub_az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = format("%s.1.0/24", var.vpc_cidr_prefix)

  availability_zone = format("%sa", var.app_region)

  tags = {
    Name                      = format("%s-pub-az1", aws_vpc.main.tags.Name)
    "app.donas.me/tier"       = "production"
    "arch.donas.me/access"    = "public"
    "arch.donas.me/az"        = format("%sa", var.app_region)
    "arch.donas.me/layer"     = "public"
    "obj.donas.me/created-by" = "haeram.kim1"
    "obj.donas.me/group"      = "network"
  }
}

resource "aws_route_table_association" "main_pub_az1" {
  subnet_id      = aws_subnet.main_pub_az1.id
  route_table_id = aws_route_table.main_pub.id
}

## Subnet - AZ2
resource "aws_subnet" "main_pub_az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = format("%s.4.0/24", var.vpc_cidr_prefix)

  availability_zone = format("%sc", var.app_region)

  tags = {
    Name                      = format("%s-pub-az2", aws_vpc.main.tags.Name)
    "app.donas.me/tier"       = "production"
    "arch.donas.me/access"    = "public"
    "arch.donas.me/az"        = format("%sc", var.app_region)
    "arch.donas.me/layer"     = "public"
    "obj.donas.me/created-by" = "haeram.kim1"
    "obj.donas.me/group"      = "network"
  }
}

resource "aws_route_table_association" "main_pub_az2" {
  subnet_id      = aws_subnet.main_pub_az2.id
  route_table_id = aws_route_table.main_pub.id
}

# Private Subnet
## Route Table
resource "aws_route_table" "main_priv" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name                      = format("%s-priv", aws_vpc.main.tags.Name)
    "app.donas.me/tier"       = "production"
    "arch.donas.me/access"    = "private"
    "arch.donas.me/layer"     = "api"
    "obj.donas.me/created-by" = "haeram.kim1"
    "obj.donas.me/group"      = "network"
  }
}

# TODO: EC2-NAT GW
# resource "aws_route" "main_priv" {
#   route_table_id         = aws_route_table.main_priv.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway..id
# }

## API Layer (AZ1)
resource "aws_subnet" "main_priv_api_az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = format("%s.2.0/24", var.vpc_cidr_prefix)

  availability_zone = format("%sa", var.app_region)

  tags = {
    Name                      = format("%s-priv-api-az1", aws_vpc.main.tags.Name)
    "app.donas.me/tier"       = "production"
    "arch.donas.me/access"    = "private"
    "arch.donas.me/az"        = format("%sa", var.app_region)
    "arch.donas.me/layer"     = "api"
    "obj.donas.me/created-by" = "haeram.kim1"
    "obj.donas.me/group"      = "network"
  }
}

resource "aws_route_table_association" "main_priv_api_az1" {
  subnet_id      = aws_subnet.main_priv_api_az1.id
  route_table_id = aws_route_table.main_priv.id
}

## API Layer (AZ2)
resource "aws_subnet" "main_priv_api_az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = format("%s.5.0/24", var.vpc_cidr_prefix)

  availability_zone = format("%sc", var.app_region)

  tags = {
    Name                      = format("%s-priv-api-az2", aws_vpc.main.tags.Name)
    "app.donas.me/tier"       = "production"
    "arch.donas.me/access"    = "private"
    "arch.donas.me/az"        = format("%sc", var.app_region)
    "arch.donas.me/layer"     = "api"
    "obj.donas.me/created-by" = "haeram.kim1"
    "obj.donas.me/group"      = "network"
  }
}

resource "aws_route_table_association" "main_priv_api_az2" {
  subnet_id      = aws_subnet.main_priv_api_az2.id
  route_table_id = aws_route_table.main_priv.id
}

## DB Layer (AZ1)
resource "aws_subnet" "main_priv_db_az1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = format("%s.3.0/24", var.vpc_cidr_prefix)

  availability_zone = format("%sa", var.app_region)

  tags = {
    Name                      = format("%s-priv-db-az1", aws_vpc.main.tags.Name)
    "app.donas.me/tier"       = "production"
    "arch.donas.me/access"    = "private"
    "arch.donas.me/az"        = format("%sa", var.app_region)
    "arch.donas.me/layer"     = "db"
    "obj.donas.me/created-by" = "haeram.kim1"
    "obj.donas.me/group"      = "network"
  }
}

resource "aws_route_table_association" "main_priv_db_az1" {
  subnet_id      = aws_subnet.main_priv_db_az1.id
  route_table_id = aws_route_table.main_priv.id
}

## DB Layer (AZ2)
resource "aws_subnet" "main_priv_db_az2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = format("%s.6.0/24", var.vpc_cidr_prefix)

  availability_zone = format("%sc", var.app_region)

  tags = {
    Name                      = format("%s-priv-db-az2", aws_vpc.main.tags.Name)
    "app.donas.me/tier"       = "production"
    "arch.donas.me/access"    = "private"
    "arch.donas.me/az"        = format("%sc", var.app_region)
    "arch.donas.me/layer"     = "db"
    "obj.donas.me/created-by" = "haeram.kim1"
    "obj.donas.me/group"      = "network"
  }
}

resource "aws_route_table_association" "main_priv_db_az2" {
  subnet_id      = aws_subnet.main_priv_db_az2.id
  route_table_id = aws_route_table.main_priv.id
}
