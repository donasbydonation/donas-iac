# - SG
resource "aws_security_group" "db" {
  name   = format("%s-db", local.app.name)
  vpc_id = module.vpc.vpc_id

  tags = {
    Name                   = format("%s-db", local.app.name)
    "app.donas.me/tier"    = "production"
    "obj.donas.me/group"   = "access-control"
    "arch.donas.me/access" = "private"
    "arch.donas.me/layer"  = "db"
  }
}

## - SG Rules
### - Ingress: {{AWS_RDS_PORT}}/TCP
resource "aws_security_group_rule" "db_ing_conn" {
  type                     = "ingress"
  from_port                = var.AWS_RDS_PORT
  to_port                  = var.AWS_RDS_PORT
  protocol                 = "TCP"
  source_security_group_id = aws_security_group.server.id
  security_group_id        = aws_security_group.db.id

  lifecycle {
    create_before_destroy = true
  }
}

### - Egress: {{AWS_RDS_PORT}}/TCP
resource "aws_security_group_rule" "db_eg_conn" {
  type                     = "egress"
  from_port                = var.AWS_RDS_PORT
  to_port                  = var.AWS_RDS_PORT
  protocol                 = "TCP"
  source_security_group_id = aws_security_group.server.id
  security_group_id        = aws_security_group.db.id

  lifecycle {
    create_before_destroy = true
  }
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.4.1"

  identifier = format("%s-db", local.app.name)

  engine               = var.AWS_RDS_ENGINE
  engine_version       = local.rds.engine_version
  family               = format("%s%s", var.AWS_RDS_ENGINE, local.rds.engine_version)
  major_engine_version = local.rds.engine_version

  instance_class        = local.rds.instance_type
  allocated_storage     = local.rds.storage_size
  max_allocated_storage = local.rds.max_storage_size

  db_name                = var.AWS_RDS_DBNAME
  port                   = var.AWS_RDS_PORT
  username               = var.AWS_RDS_USERNAME
  password               = var.AWS_RDS_PASSWORD
  create_random_password = false

  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = module.vpc.database_subnet_group_name

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_connection"
      value = "utf8mb4"
    },
    {
      name  = "character_set_database"
      value = "utf8mb4"
    },
    {
      name  = "character_set_results"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    },
    {
      name  = "collation_connection"
      value = "utf8mb4_unicode_ci"
    },
    {
      name  = "collation_server"
      value = "utf8mb4_general_ci"
    }
  ]

  tags = {
    "app.donas.me/tier"    = "production"
    "obj.donas.me/group"   = "db"
    "arch.donas.me/access" = "private"
    "arch.donas.me/layer"  = "db"
  }
}
