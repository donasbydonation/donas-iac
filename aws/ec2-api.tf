# - Ubuntu 20.04 AMI
data "aws_ami" "ubuntu_2004" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# - SSH RSA keypair
resource "aws_key_pair" "ssh" {
  key_name   = format("%s-ssh", var.app_name)
  public_key = file("./data/ec2-ssh.pub")
}
