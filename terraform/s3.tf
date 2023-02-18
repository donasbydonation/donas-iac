module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.7.0"

  bucket = format("%s-server-bucket", local.app.name)
  acl    = "private"

  versioning = {
    enabled = true
  }
}
