provider "aws" {
  access_key = "AKIAJYQS7ZHXUD4LXOTQ"
  secret_key = "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"
  region     = "us-east-1"
}

resource "aws_iam_user" "aubrey" {
  name = "aubrey"
  path = "/system/"
}