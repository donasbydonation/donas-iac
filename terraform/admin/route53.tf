resource "aws_route53_record" "this" {
  zone_id = var.hz_id
  name    = format("%s.%s", var.record_name, var.hz_name)
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = true
  }
}
