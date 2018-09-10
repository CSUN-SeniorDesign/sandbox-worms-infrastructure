provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

resource "aws_iam_user" "aubrey" {
  name = "aubrey"
  path = "/system/"
}

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "region" {
        default = "us-east-1"
}