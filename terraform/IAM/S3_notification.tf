data "aws_lambda_function" "existing" {
  function_name = "updateecr"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:us-east-1:429784283093:function:updateecr"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.sandboxworms-packages-92618.arn}"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.sandboxworms-packages-92618.id}"

  lambda_function {
    lambda_function_arn = "arn:aws:lambda:us-east-1:429784283093:function:updateecr"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "AWSLogs/"
    filter_suffix       = ".log"
  }
}