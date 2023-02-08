# - SG
resource "aws_security_group" "lb" {
  name   = format("%s-lb", var.app_name)
  vpc_id = module.vpc.vpc_id

  tags = {
    Name                      = format("%s-lb", var.app_name)
    "app.donas.me/tier"       = "production"
    "obj.donas.me/created-by" = "haeram.kim1"
    "obj.donas.me/group"      = "access-control"
    "arch.donas.me/access"    = "public"
    "arch.donas.me/layer"     = "public"
  }
}

## - SG ingress rule: */*
resource "aws_security_group_rule" "lb_ing_all" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id

  lifecycle {
    create_before_destroy = true
  }
}

## - SG egress rule: */*
resource "aws_security_group_rule" "lb_eg_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id

  lifecycle {
    create_before_destroy = true
  }
}
