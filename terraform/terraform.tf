

/*# create an S3 bucket to store the state file in
resource "aws_s3_bucket" "sandboxworms-tf-state" {
    bucket = "sandboxworms-tf-state"
	acl = ""
    versioning {
      enabled = true
    }
 
    lifecycle {
      prevent_destroy = true
    }
 
    tags {
      Name = "S3 Remote Terraform State Store"
    }      
	
}*/


terraform {
backend "s3" {
  #access_key = "${var.aws_access_key}"
  #secret_key = "${var.aws_secret_key}"
  #region     = "${var.region}"
 encrypt = true
 bucket = "sandboxworms-tf-state-0911"
key="tf-prod/terraform.tfstate"
region="us-east-1"
dynamodb_table = "sandboxworms-tf-lock-0911"
}
}
