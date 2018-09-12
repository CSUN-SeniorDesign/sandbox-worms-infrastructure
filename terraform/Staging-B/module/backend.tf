terraform {
backend "s3" {
 /* #access_key = "${var.aws_access_key}"
  #secret_key = "${var.aws_secret_key}"
  #region     = "${var.region}"
 #encrypt = true
 bucket = "sandboxworms-rstate-0911218-22"
 key="terraform.tfstate"
 region="us-east-1"
 dynamodb_table = "sandboxworms-lockdb-09112018-22"*/
 } 
}