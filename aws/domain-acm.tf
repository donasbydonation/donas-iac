module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name  = var.route53_hz
  zone_id      = module.route53_hz.route53_zone_zone_id[var.route53_hz]

  subject_alternative_names = [
    "*.${var.route53_hz}"
  ]

  wait_for_validation = true

  tags = {
    "app.donas.me/tier"    = "production"
    "obj.donas.me/group"   = "cert"
    "arch.donas.me/access" = "public"
    "arch.donas.me/layer"  = "global"
  }
}
