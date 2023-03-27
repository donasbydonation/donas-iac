module "admin" {
  source = "./admin"

  hz_name = local.route53.hz_name
  hz_id = module.route53_hz.route53_zone_zone_id[local.route53.hz_name]
  record_name = local.route53.admin_record_name
}
