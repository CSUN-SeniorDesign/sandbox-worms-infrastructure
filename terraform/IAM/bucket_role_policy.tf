/*===================S3 BUCKET===================*/
resource "aws_s3_bucket" "sandboxworms-packages-92618" {
  bucket = "sandboxworms-packages-92618"
  tags {
    Name        = "sandboxworms-packages-92618"
  }
}

/*===============DATA TAG====================*/
#data "aws_s3_bucket" "package_bucket"{
#    bucket = "Packages"
#}	
/*data.aws_s3_bucket.package_bucket.arn*/

/*===================USER===================*/
resource "aws_iam_user" "CCI" {
	name = "CCI"
}

/*===================POLICIES===================*/
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
				  "s3:ListBucket",
        "Resource": "${aws_s3_bucket.sandboxworms-packages-92618.arn}"
    }]
}
EOF
}


resource "aws_iam_policy" "CCI_policy_GET" {
  name        = "CCI_policy_GET"
  path        = "/"
  description = "Policy for Instances"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
        "Effect": "Allow",
        "Action": "s3:GetObject", 
				  "s3:ListBucket",
        "Resource": "${aws_s3_bucket.sandboxworms-packages-92618.arn}"
    }]
}
EOF
}

/*===================ROLES===================*/
resource "aws_iam_role" "circ-ci" {
  name = "circ-ci"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
            "Effect": "Allow",
            "Action": "s3:PutObject", "s3:ListBucket",
            "Resource": "${aws_s3_bucket.sandboxworms-packages-92618.arn}"
        }]
}
EOF
}

resource "aws_iam_role" "instance-package" {
  name = "instance-package"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
            "Effect": "Allow",
            "Action": "s3:GetObject", "s3:ListBucket",
            "Resource": "${aws_s3_bucket.sandboxworms-packages-92618.arn}"
        }]
}
EOF
}

/*===================POLICY ATTACH===================*/
/*resource "aws_iam_policy_attachment" "CCI_put" {
  name       = "CCI_put"
  users      = ["${aws_iam_user.CCI.name}"]
  roles      = ["${aws_iam_role.circ-ci.name}"]
#  groups     = ["${aws_iam_group.group.name}"]
  policy_arn = "${aws_iam_policy.CCI_policy_PUT.arn}"
}

resource "aws_iam_policy_attachment" "instance_get" {
  name       = "instance_get"
  roles      = ["${aws_iam_role.instance-package.name}"]
  policy_arn = "${aws_iam_policy.CCI_policy_GET.arn}"
}*/

resource "aws_iam_role_policy_attachment" "CCI_put" {
    role       = "${aws_iam_role.circ-ci.name}"
    policy_arn = "${aws_iam_policy.CCI_policy_PUT.arn}"
}

resource "aws_iam_role_policy_attachment" "instance_get" {
    role       = "${aws_iam_role.instance-package.name}"
    policy_arn = "${aws_iam_policy.CCI_policy_GET.arn}"
}

