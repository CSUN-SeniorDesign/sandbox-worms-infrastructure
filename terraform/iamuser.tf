provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "us-east-1"
}

resource "aws_iam_user" "aubrey" {
  name = "aubrey"
  path = "/system/"
}
