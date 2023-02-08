# - SSH RSA keypair
resource "aws_key_pair" "ssh" {
  key_name   = format("%s-ssh", var.app_name)
  public_key = file("./data/ec2-ssh.pub")
}

# - SG
resource "aws_security_group" "server" {
  name        = format("%s-server", var.app_name)
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = format("%s-server", var.app_name)
    "app.donas.me/tier"       = "production"
    "obj.donas.me/created-by" = "haeram.kim1"
    "obj.donas.me/group"      = "access-control"
    "arch.donas.me/access"    = "private"
    "arch.donas.me/layer"     = "server"
  }
}

## - SG ingress rule: {{web_port}}/TCP
resource "aws_security_group_rule" "server_ing_web" {
  type                     = "ingress"
  from_port                = var.web_port
  to_port                  = var.web_port
  protocol                 = "TCP"
  source_security_group_id = aws_security_group.lb.id
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
