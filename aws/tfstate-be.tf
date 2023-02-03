# - S3
resource "aws_s3_bucket" "donas_tfstate_bucket" {
  bucket = "donas-tfstate-bucket"

  tags = {
    "app.donas.me/tier"       = "production"
    "obj.donas.me/created-by" = "root"
    "obj.donas.me/group"      = "tfstate"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "donas_tfstate_bucket" {
  bucket = aws_s3_bucket.donas_tfstate_bucket.bucket

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "donas_tfstate_bucket" {
  bucket = aws_s3_bucket.donas_tfstate_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}


# - DynamoDB for locking
resource "aws_dynamodb_table" "donas_tfstate_lock" {
  name         = "donas-tfstate-lock"
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
