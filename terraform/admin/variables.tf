variable "hz_name" {
  description = "Hosted zone name"
  type        = string
}

variable "hz_id" {
  description = "Hosted zone ID"
  type        = string
}

variable "record_name" {
  description = "Subdomain record name"
  type        = string
}

variable "bucket_public_dir" {
  description = "Public dir path of the S3 bucket"
  type        = string
  default     = "/"
}
