# - SSH RSA keypair
resource "aws_key_pair" "ssh" {
  key_name   = format("%s-ssh", local.app.name)
  public_key = file("./data/ec2-ssh.pub")
}

# - SG
resource "aws_security_group" "server" {
  name   = format("%s-server", local.app.name)
  vpc_id = module.vpc.vpc_id

  tags = {
    Name                   = format("%s-server", local.app.name)
    "app.donas.me/tier"    = "production"
    "obj.donas.me/group"   = "access-control"
    "arch.donas.me/access" = "private"
    "arch.donas.me/layer"  = "server"
  }
}

## - SG ingress rule: {{NODEPORT}}/TCP
resource "aws_security_group_rule" "server_ing_nodeport" {
  type                     = "ingress"
  from_port                = local.sg.from_nodeport
  to_port                  = local.sg.to_nodeport
  protocol                 = "TCP"
  source_security_group_id = module.alb.security_group_id
  security_group_id        = aws_security_group.server.id

  lifecycle {
    create_before_destroy = true
  }
}

## - SG egress rule: */*
resource "aws_security_group_rule" "server_eg_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.server.id

  lifecycle {
    create_before_destroy = true
  }
}
