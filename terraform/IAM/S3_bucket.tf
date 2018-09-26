/*===================S3 BUCKET===================*/
resource "aws_s3_bucket" "sandboxworms-packages-92618" {
  bucket = "sandboxworms-packages-92618"
  tags {
    Name        = "sandboxworms-packages-92618"
  }
}