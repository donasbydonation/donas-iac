# - Global Certificate
resource "aws_acm_certificate" "this" {
  provider                  = aws
  domain_name               = var.hz_name
  subject_alternative_names = [format("%s.%s", var.record_name, var.hz_name)]
  validation_method         = "DNS"
}

# - ACM Validation
resource "aws_acm_certificate_validation" "this" {
  provider                = aws
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.this: record.fqdn]
}

resource "aws_route53_record" "this" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = var.hz_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}
