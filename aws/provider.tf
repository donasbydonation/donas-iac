terraform {
  backend "s3" {
    bucket         = "donas-tfstate-bucket"
    key            = "donas-tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "donas-tfstate-lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.17.1"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}
