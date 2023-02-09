# - ASG
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "6.7.1"

  # Autoscaling group
  name = format("%s-server", var.app_name)

  vpc_zone_identifier = module.vpc.private_subnets
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1
  user_data           = file("./data/ec2-userdata.b64")
  image_id            = data.aws_ami.ubuntu_2004.id
  instance_type       = var.default_instance_type
  key_name            = format("%s-ssh", var.app_name)

  # SG
  security_groups = [aws_security_group.server.id]

  # IAM instance profile
  create_iam_instance_profile = true
  iam_role_name               = format("%s-server", var.app_name)
  iam_role_policies = {
    AWSCodeDeployRole       = data.aws_iam_policy.aws_codedeploy_role.arn
    AWSCodeDeployFullAccess = data.aws_iam_policy.aws_codedeploy_fullaccess.arn
  }

  # Tags
  tag_specifications = [
    {
      resource_type = "instance"
      tags = {
        "obj.donas.me/controller" = "donas-app" # TODO
      }
    }
  ]

  tags = {
    "app.donas.me/tier"       = "production"
    "obj.donas.me/group"      = "server"
    "arch.donas.me/access"    = "private"
    "arch.donas.me/layer"     = "server"
  }
}
