# - AMI
## - Ubuntu 20.04
data "aws_ami" "ubuntu_2004" {
  most_recent = true
  owners      = [var.ami_owner]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# - Policy
## - CodeDeploy
data "aws_iam_policy" "aws_codedeploy_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

data "aws_iam_policy" "aws_codedeploy_fullaccess" {
  arn = "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess"
}