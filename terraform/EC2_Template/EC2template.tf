# EC2 TEMPLATE
# REFER TO https://www.terraform.io/docs/providers/aws/r/instance.html FOR ADDITIONAL OPTIONS/ATTRIBUTES
#DON'T FORGET TO REMOVE THE COMMENTS
/*
resource "aws_instance" "YOUR_INSTANCE_NAME" {
  ami           = "309956199498/RHEL-7.5_HVM_GA-20180322-x86_64-1-Hourly2-GP2"
  instance_type = "t2.micro"
  availability_zone = ""
  subnet_id = ""
  tags {
    Name = "YOUR_INSTANCE_NAME"
  }
}
*/