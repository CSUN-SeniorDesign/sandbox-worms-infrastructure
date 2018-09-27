

/*===============DATA TAG====================*/
data "aws_s3_bucket" "sandboxworms-packages-92618"{
    bucket = "sandboxworms-packages-92618"
}	
/*data.aws_s3_bucket.sandboxworms-packages-92618.arn*/

/*===================USER + GROUP===================*/
resource "aws_iam_user" "CCI" {
	name = "CCI"
}

resource "aws_iam_group" "circle-ci-group" {
  name = "circle-ci-group"
  path = "/"
}

resource "aws_iam_group_membership" "circle-ci-group-add"{
	name = "circle-ci-group-add"
	users = ["${aws_iam_user.CCI.name}"]
	group = "${aws_iam_group.circle-ci-group.id}"
}

/*===================POLICIES===================*/
resource "aws_iam_policy" "CCI_policy_PUT" {
  name        = "CCI_policy_PUT"
  path        = "/"
  description = "Policy for Circle Ci"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::sandboxworms-packages-92618",
                "arn:aws:s3:::sandboxworms-packages-92618/*"
            ]
        }
    ]
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
        "Action": ["s3:GetObject", 
				  "s3:ListBucket"],
        "Resource": "${data.aws_s3_bucket.sandboxworms-packages-92618.arn}"
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
			"Statement": [
			{
			"Action": "sts:AssumeRole",
			"Principal": {
				"Service": "ec2.amazonaws.com"
			},
			"Effect": "Allow",
			"Sid": ""
			}
		]
	}
EOF
}

resource "aws_iam_role" "instance-package" {
  name = "instance-package"
    assume_role_policy = <<EOF
{
		"Version": "2012-10-17",
			"Statement": [
			{
			"Action": "sts:AssumeRole",
			"Principal": {
				"Service": "ec2.amazonaws.com"
			},
			"Effect": "Allow",
			"Sid": ""
			}
		]
	}
EOF
}

/*===================POLICY ATTACH===================*/
resource "aws_iam_role_policy_attachment" "CCI_put" {
    role       = "${aws_iam_role.circ-ci.name}"
    policy_arn = "${aws_iam_policy.CCI_policy_PUT.arn}"
}

resource "aws_iam_role_policy_attachment" "instance_get" {
    role       = "${aws_iam_role.instance-package.name}"
    policy_arn = "${aws_iam_policy.CCI_policy_GET.arn}"
}

resource "aws_iam_group_policy_attachment" "CCI_group_attach" {
  group	 = "${aws_iam_group.circle-ci-group.id}"
  policy_arn = "${aws_iam_policy.CCI_policy_PUT.arn}"
}
