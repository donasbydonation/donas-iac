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
    "app.donas.me/tier"       = "production"
    "obj.donas.me/created-by" = "haeram.kim1"
    "obj.donas.me/group"      = "auth"
    "obj.donas.me/saved-at"   = "github.com/Boost-projects/config"
  }
}

resource "aws_iam_access_key" "config_gh_action_robot" {
  user = aws_iam_user.config_gh_action_robot.name
}
