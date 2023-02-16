resource "aws_iam_role" "codedeploy" {
  name               = format("%s-codedeploy", local.app.name)
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role.json
}

resource "aws_iam_role_policy_attachment" "codedeploy" {
  role       = aws_iam_role.codedeploy.name
  policy_arn = data.aws_iam_policy.aws_codedeploy_role.arn
}

# CodeDeploy
resource "aws_codedeploy_app" "server" {
  compute_platform = "Server"
  name             = var.AWS_CODEDEPLOY_APP_NAME

  tags = {
    "app.donas.me/tier"  = "production"
    "obj.donas.me/group" = "cicd"
  }
}

resource "aws_codedeploy_deployment_group" "server" {
  app_name              = aws_codedeploy_app.server.name
  deployment_group_name = var.AWS_CODEDEPLOY_DEPLOY_GROUP_NAME
  service_role_arn      = aws_iam_role.codedeploy.arn

  ec2_tag_set {
    ec2_tag_filter {
      type  = "KEY_AND_VALUE"
      key   = "cicd.donas.me/managed-by"
      value = aws_codedeploy_app.server.name
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  tags = {
    "app.donas.me/tier"  = "production"
    "obj.donas.me/group" = "cicd"
  }
}
