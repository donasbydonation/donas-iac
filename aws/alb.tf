# - ALB A Record
module "route53_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_id = module.route53_hz.route53_zone_zone_id[var.route53_hz]

  records = [
    {
      name = ""
      type = "A"
      alias = {
        name    = module.alb.lb_dns_name
        zone_id = module.alb.lb_zone_id
      }
    }
  ]
}

# - ALB
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = format("%s-lb", var.app_name)

  load_balancer_type = "application"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  security_group_rules = {
    ingress_all_http = {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ingress_all_https = {
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ingress_web = {
      type                     = "ingress"
      from_port                = var.web_port
      to_port                  = var.web_port
      protocol                 = "TCP"
      source_security_group_id = aws_security_group.server.id
    }
    egress_all_https = {
      type        = "egress"
      from_port   = 443
      to_port     = 443
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress_web = {
      type                     = "egress"
      from_port                = var.web_port
      to_port                  = var.web_port
      protocol                 = "TCP"
      source_security_group_id = aws_security_group.server.id
    }
  }

  target_groups = [
    {
      name_prefix      = "asg"
      backend_protocol = "HTTP"
      backend_port     = var.web_port
      target_type      = "instance"
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = module.acm.acm_certificate_arn
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  tags = {
    "app.donas.me/tier"    = "production"
    "obj.donas.me/group"   = "lb"
    "arch.donas.me/access" = "public"
    "arch.donas.me/layer"  = "public"
  }
}
