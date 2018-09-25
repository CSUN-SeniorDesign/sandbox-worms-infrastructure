/*
resource "aws_iam_user" "CCI" {
	name = "CCI"
}
*/

resource "aws_s3_bucket" "Packages" {
  bucket = "Packages"
  tags {
    Name        = "Packages"
  }
}

resource "aws_iam_policy" "CCI_policy_PUT" {
  name        = "CCI_policy_PUT"
  path        = "/"
  description = "Policy for Circle Ci"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
        "Effect": "Allow",
        "Action": "s3:PutObject",
        "Resource": "${aws_s3_bucket.Packages.arn}"
    }]
}
EOF
}


resource "aws_iam_policy" "CCI_policy_GET" {
  name        = "CCI_policy_GET"
  path        = "/"
  description = "Policy for Circle Ci"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
        "Effect": "Allow",
        "Action": "s3:GetObject",
        "Resource": "${aws_s3_bucket.Packages.arn}"
    }]
}
EOF
}


resource "aws_iam_role" "circ_ci" {
  name = "circ_ci"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.Packages.arn}"
        }]
}
EOF
}

resource "aws_iam_role" "instance_package" {
  name = "instance_package"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.Packages.arn}"
        }]
}
EOF
}

####################Circle Ci Put
resource "aws_iam_policy_attachment" "CCI_put" {
  name       = "CCI_put"
#  users      = ["${aws_iam_user.CCI.name}"]
  roles      = ["${aws_iam_role.circ_ci.name}"]
#  groups     = ["${aws_iam_group.group.name}"]
  policy_arn = "${aws_iam_policy.CCI_policy_PUT.arn}"
}


####################Circle Ci Get
resource "aws_iam_policy_attachment" "instance_get" {
  name       = "instance_get"
  roles      = ["${aws_iam_role.instance_package.name}"]
  policy_arn = "${aws_iam_policy.CCI_policy_GET.arn}"
}
