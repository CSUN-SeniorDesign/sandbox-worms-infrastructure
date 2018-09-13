#CREATE USERS

resource "aws_iam_user" "aubrey_p1" {
	name = "aubrey_p1"
}

resource "aws_iam_user" "john_p1" {
	name = "john_p1"
}

resource "aws_iam_user" "nick_p1" {
	name = "nick_p1"
}

resource "aws_iam_user" "mark_p1" {
	name = "mark_p1"
}

resource "aws_iam_user" "yerden_p1" {
	name = "yerden_p1"
}

#CREATE POLICY


resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  users      = ["${aws_iam_user.yerden_p1.name}",
				"${aws_iam_user.mark_p1.name}",
				"${aws_iam_user.nick_p1.name}",
				"${aws_iam_user.john_p1.name}",
				"${aws_iam_user.aubrey_p1.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
