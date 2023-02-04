# - S3
resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = format("%s-bucket", var.tfstate_name)

  tags = {
    "app.donas.me/tier"       = "production"
    "obj.donas.me/created-by" = "root"
    "obj.donas.me/group"      = "tfstate"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_bucket" {
  bucket = aws_s3_bucket.tfstate_bucket.bucket

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "tfstate_bucket" {
  bucket = aws_s3_bucket.tfstate_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}


# - DynamoDB for locking
resource "aws_dynamodb_table" "tfstate_lock" {
  name         = format("%s-lock", var.tfstate_name)
  table_class  = "STANDARD"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    "app.donas.me/tier"       = "production"
    "obj.donas.me/created-by" = "root"
    "obj.donas.me/group"      = "tfstate"
  }
}
