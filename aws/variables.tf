variable "app_name" {
  type = string
}

variable "tfstate_name" {
  type = string
}

variable "vpc_cidr_prefix" {
  type = string
}

variable "app_region" {
  type = string
}

variable "default_instance_type" {
  type = string
}

variable "web_port" {
  type = number
}

variable "ami_owner" {
  type = string
}

variable "AWS_ASG_USER_DATA" {
  type = string
}

variable "route53_hz" {
  type = string
}

variable "AWS_RDS_DBNAME" {
  type = string
}

variable "AWS_RDS_PORT" {
  type = string
}

variable "AWS_RDS_USERNAME" {
  type = string
}

variable "AWS_RDS_PASSWORD" {
  type = string
}
