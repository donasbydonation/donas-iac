module "route53_hz" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  zones = {
    "donas.me" = {
      tags = {
      }
    }
  }

  tags = {
    "app.donas.me/tier"    = "production"
    "obj.donas.me/group"   = "domain"
    "arch.donas.me/access" = "public"
    "arch.donas.me/layer"  = "global"
  }
}
