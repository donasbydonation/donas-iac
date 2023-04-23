data "aws_iam_policy" "aws_administrator_access" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy_document" "s3_public_read_bucket_full_access" {
  statement {
    actions = [
      "s3:*",
      "s3-object-lambda:*",
    ]

    resources = [
      format("%s/*", module.s3_public_read_bucket.s3_bucket_arn),
    ]
  }
}
