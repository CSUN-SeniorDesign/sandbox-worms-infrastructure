provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

resource "aws_kms_key" "proj5_bucket_key" {
  #count = "${var.bootstrap}"

  description             = "Global Terraform state encryption key"
  deletion_window_in_days = 30

  tags {
    Origin = "Terraform"
  }
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "key-default-1",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::429784283093:root",
          "arn:aws:iam::429784283093:user/CCI",
          "arn:aws:iam::429784283093:role/instance-package"
        ]
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF
}
resource "aws_s3_bucket" "proj5bucket" {
  bucket = "sandboxworms-proj5-102018"
  acl    = "public-read"
  website {
    index_document = "index.html"
  }
  versioning {
    enabled = true
  }
  lifecycle_rule {
    id      = "expire"
    enabled = true

    noncurrent_version_expiration {
      days = 90
    }
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.proj5_bucket_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }
  
  tags {
    Name        = "sandboxworms-proj5-102018"
  }

}

