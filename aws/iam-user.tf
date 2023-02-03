resource "aws_iam_user" "haeram_kim1" {
  name = "haeram.kim1"
  path = "/"

  tags = {
    "app.donas.me/tier"       = "development"
    "obj.donas.me/created-by" = "root"
    "obj.donas.me/group"      = "auth"
    "obj.donas.me/saved-at"   = "hrk-MacBookPro.local"
    "user.donas.me/teamname"  = "development"
    "user.donas.me/user-role" = "sre"
    "user.donas.me/username"  = "Haeram Kim"
  }
}

resource "aws_iam_user_group_membership" "haeram_kim1" {
  user = aws_iam_user.haeram_kim1.name

  groups = [
    aws_iam_group.admin.name,
  ]
}

resource "aws_iam_access_key" "haeram_kim1" {
  user = aws_iam_user.haeram_kim1.name
}
