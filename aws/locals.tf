locals {
  app = {
    name     = "donas"
    region   = "ap-northeast-2"
    web_port = 3000
  }

  vpc = {
    cidr_prefix = "10.0"
  }

  route53 = {
    hz_name = "donas.me"
  }

  ec2 = {
    instance_type    = "t2.micro"
    ubuntu_ami_owner = "099720109477" # Canonical
  }

  rds = {
    instance_type    = "db.t3.micro"
    engine_version   = "10.5"
    storage_size     = 20
    max_storage_size = 50
  }
}
