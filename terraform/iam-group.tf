resource "aws_iam_group" "admin" {
  name = "admin"
  path = "/"
}

resource "aws_iam_group" "gh_action_robot" {
  name = "gh-action-robot"
  path = "/"
}
