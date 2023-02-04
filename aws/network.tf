# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = format("%s.0.0/16", var.vpc_cidr_prefix)

  tags = {
    Name                      = format("%s-main-vpc", var.app_name)
    "app.donas.me/tier"       = "production"
    "obj.donas.me/created-by" = "haeram.kim1"
    "obj.donas.me/group"      = "network"
  }
}

# Gateways
## IGW
resource "aws_internet_gateway" "main_vpc_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name                      = format("%s-igw", aws_vpc.main_vpc.tags.Name)
    "app.donas.me/tier"       = "production"
    "obj.donas.me/created-by" = "haeram.kim1"
    "obj.donas.me/group"      = "network"
  }
}
