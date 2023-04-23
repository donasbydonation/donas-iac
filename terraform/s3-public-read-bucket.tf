data "aws_iam_policy_document" "s3_public_read_bucket_read_only" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      format("%s/*", module.s3_public_read_bucket.s3_bucket_arn),
    ]
  }
}

module "s3_public_read_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.7.0"

  bucket = format("%s-public-read-bucket", local.app.name)

  attach_policy = true
  policy        = data.aws_iam_policy_document.s3_public_read_bucket_read_only.json

  versioning = {
    enabled = true
  }
}
