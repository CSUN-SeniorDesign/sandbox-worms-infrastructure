resource "aws_kms_key" "tf_tar_enc_key" {
  #count = "${var.bootstrap}"

  description             = "Global Terraform state encryption key"
  deletion_window_in_days = 30

  tags {
    Origin = "Terraform"
  }
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

/*===================S3 BUCKET===================*/
resource "aws_s3_bucket" "sandboxworms-packages-92618" {
  bucket = "sandboxworms-packages-92618"
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
        kms_master_key_id = "${aws_kms_key.tf_tar_enc_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }
  
  tags {
    Name        = "sandboxworms-packages-92618"
  }
}