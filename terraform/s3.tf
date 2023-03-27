module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.7.0"

  bucket = format("%s-server-bucket", local.app.name)
  acl    = "private"

  versioning = {
    enabled = true
  }
}

module "s3_admin_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.7.0"

  bucket = format("%s.%s", local.route53.admin_record_name, local.route53.hz_name)

  attach_policy = true
  policy        = data.aws_iam_policy_document.admin_web_public_read.json

  website = {
    index_document = "index.html"
    error_document = "index.html"
  }
}

data "aws_iam_policy_document" "admin_web_public_read" {
  statement {
    sid = "PublicReadGetObject"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      format("arn:aws:s3:::%s.%s/*", local.route53.admin_record_name, local.route53.hz_name),
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

module "route53_admin_cname_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_id = module.route53_hz.route53_zone_zone_id[local.route53.hz_name]

  records = [
    {
      name = local.route53.admin_record_name
      type = "A"
      alias = {
        name    = module.s3_admin_bucket.s3_bucket_website_domain
        zone_id = module.s3_admin_bucket.s3_bucket_hosted_zone_id
      }
    },
  ]
}
