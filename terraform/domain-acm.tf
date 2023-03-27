module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = local.route53.hz_name
  zone_id     = module.route53_hz.route53_zone_zone_id[local.route53.hz_name]

  wait_for_validation = true

  tags = {
    "app.donas.me/tier"    = "production"
    "obj.donas.me/group"   = "cert"
    "arch.donas.me/access" = "public"
    "arch.donas.me/layer"  = "global"
  }
}
