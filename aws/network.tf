# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/3.19.0
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name                 = var.app_name
  cidr                 = format("%s.0.0/16", var.vpc_cidr_prefix)
  azs                  = [format("%sa", var.app_region), format("%sc", var.app_region)]
  public_subnets       = [format("%s.11.0/24", var.vpc_cidr_prefix), format("%s.12.0/24", var.vpc_cidr_prefix)]
  private_subnets      = [format("%s.21.0/24", var.vpc_cidr_prefix), format("%s.22.0/24", var.vpc_cidr_prefix)]
  database_subnets     = [format("%s.31.0/24", var.vpc_cidr_prefix), format("%s.32.0/24", var.vpc_cidr_prefix)]
  enable_dns_hostnames = true

  tags = {
    "app.donas.me/tier"       = "production"
    "obj.donas.me/created-by" = "haeram.kim1"
    "obj.donas.me/group"      = "network"
  }

  public_subnet_tags = {
    "arch.donas.me/access" = "public"
    "arch.donas.me/layer"  = "public"
  }

  private_subnet_tags = {
    "arch.donas.me/access" = "private"
    "arch.donas.me/layer"  = "server"
  }

  database_subnet_tags = {
    "arch.donas.me/access" = "private"
    "arch.donas.me/layer"  = "db"
  }
}

# -------------------------
# DISCLAIMER: Using NAT instance is not recommended; MUST migrate to NAT gateway later
# -------------------------
# https://registry.terraform.io/modules/int128/nat-instance/aws/2.1.0
module "nat" {
  source  = "int128/nat-instance/aws"
  version = "2.1.0"

  name                        = var.app_name
  vpc_id                      = module.vpc.vpc_id
  public_subnet               = module.vpc.public_subnets[0]
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  private_route_table_ids     = module.vpc.private_route_table_ids

  tags = {
    "app.donas.me/tier"       = "production"
    "obj.donas.me/created-by" = "haeram.kim1"
    "obj.donas.me/group"      = "network"
    "arch.donas.me/access"    = "public"
    "arch.donas.me/layer"     = "public"
  }
}

resource "aws_eip" "nat" {
  network_interface = module.nat.eni_id

  tags = {
    "Name"                    = format("nat-instance-%s", var.app_name)
    "app.donas.me/tier"       = "production"
    "obj.donas.me/created-by" = "haeram.kim1"
    "obj.donas.me/group"      = "network"
    "arch.donas.me/access"    = "public"
    "arch.donas.me/layer"     = "public"
  }
}
