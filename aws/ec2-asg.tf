# - ASG
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "6.7.1"

  # Autoscaling group
  name = format("%s-server", local.app.name)

  vpc_zone_identifier = module.vpc.private_subnets
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1
  user_data           = var.AWS_ASG_USER_DATA
  image_id            = data.aws_ami.ubuntu_2004.id
  instance_type       = local.ec2.instance_type
  key_name            = format("%s-ssh", local.app.name)

  # ALB
  target_group_arns = module.alb.target_group_arns

  # SG
  security_groups = [aws_security_group.server.id]

  # IAM instance profile
  create_iam_instance_profile = true
  iam_role_name               = format("%s-server", local.app.name)
  iam_role_policies = {
    AWSCodeDeployRole       = data.aws_iam_policy.aws_codedeploy_role.arn
    AWSCodeDeployFullAccess = data.aws_iam_policy.aws_codedeploy_fullaccess.arn
  }

  # Tags
  tag_specifications = [
    {
      resource_type = "instance"
      tags = {
        "cicd.donas.me/managed-by" = aws_codedeploy_app.server.name
      }
    }
  ]

  tags = {
    "app.donas.me/tier"    = "production"
    "obj.donas.me/group"   = "server"
    "arch.donas.me/access" = "private"
    "arch.donas.me/layer"  = "server"
  }
}
