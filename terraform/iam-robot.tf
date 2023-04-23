#
# GitHub action robot account
#
resource "aws_iam_user_group_membership" "config_gh_action_robot" {
  user = aws_iam_user.config_gh_action_robot.name

  groups = [
    aws_iam_group.gh_action_robot.name,
  ]
}

resource "aws_iam_user" "config_gh_action_robot" {
  name = "config@gh-action-robot"
  path = "/"

  tags = {
    "app.donas.me/tier"     = "production"
    "obj.donas.me/group"    = "auth"
    "obj.donas.me/saved-at" = "github.com/donasbydonation/donas-iac"
  }
}

resource "aws_iam_access_key" "config_gh_action_robot" {
  user = aws_iam_user.config_gh_action_robot.name
}

#
# S3://donas-public-read-bucket robot account
#
resource "aws_iam_user" "apiserver_s3_public_read_bucket_robot" {
  name = "apiserver@s3-public-read-bucket-robot"
  path = "/"

  tags = {
    "app.donas.me/tier"     = "production"
    "obj.donas.me/group"    = "auth"
    "obj.donas.me/saved-at" = "github.com/donasbydonation/donas-iac"
  }
}

resource "aws_iam_user_group_membership" "apiserver_s3_public_read_bucket_robot" {
  user = aws_iam_user.apiserver_s3_public_read_bucket_robot.name

  groups = [
    aws_iam_group.s3_public_read_bucket_robot.name,
  ]
}

resource "aws_iam_access_key" "apiserver_s3_public_read_bucket_robot" {
  user = aws_iam_user.apiserver_s3_public_read_bucket_robot.name
}
