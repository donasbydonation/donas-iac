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

  bucket = format("%s-admin-bucket", local.app.name)

  attach_policy = true
  policy  = data.aws_iam_policy_document.admin_web_public_read.json

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
      format("arn:aws:s3:::%s-admin-bucket/*", local.app.name),
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}
