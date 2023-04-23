#
# Admin account group
#
resource "aws_iam_group" "admin" {
  name = "admin"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "admin" {
  group      = aws_iam_group.admin.name
  policy_arn = data.aws_iam_policy.aws_administrator_access.arn
}

#
# GitHub action robot account group
#
resource "aws_iam_group" "gh_action_robot" {
  name = "gh-action-robot"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "gh_action_robot" {
  group      = aws_iam_group.gh_action_robot.name
  policy_arn = data.aws_iam_policy.aws_administrator_access.arn
}

#
# S3://donas-public-read-bucket robot account group
#
resource "aws_iam_group" "s3_public_read_bucket_robot" {
  name = "s3-public-read-bucket-robot"
  path = "/"
}

resource "aws_iam_group_policy" "s3_public_read_bucket_robot" {
  name   = "s3-public-read-bucket-robot"
  group  = aws_iam_group.s3_public_read_bucket_robot.name
  policy = data.aws_iam_policy_document.s3_public_read_bucket_full_access.json
}
