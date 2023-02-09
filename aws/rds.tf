# - SG
resource "aws_security_group" "db" {
  name   = format("%s-db", var.app_name)
  vpc_id = module.vpc.vpc_id

  tags = {
    Name                   = format("%s-db", var.app_name)
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
  type              = "egress"
  from_port         = var.AWS_RDS_PORT
  to_port           = var.AWS_RDS_PORT
  protocol          = "TCP"
  source_security_group_id = aws_security_group.server.id
  security_group_id = aws_security_group.db.id

  lifecycle {
    create_before_destroy = true
  }
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.4.1"

  identifier = format("%s-db", var.app_name)

  engine            = "mariadb"
  engine_version    = "10.5"
  family = "mariadb10.5"
  major_engine_version = "10.5"

  instance_class    = var.rds_instance_type
  allocated_storage      = 20
  max_allocated_storage  = 50

  db_name  = var.AWS_RDS_DBNAME
  port     = var.AWS_RDS_PORT
  username = var.AWS_RDS_USERNAME
  password = var.AWS_RDS_PASSWORD

  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name = module.vpc.database_subnet_group_name

  tags = {
    "app.donas.me/tier"    = "production"
    "obj.donas.me/group"   = "db"
    "arch.donas.me/access" = "private"
    "arch.donas.me/layer"  = "db"
  }
}
