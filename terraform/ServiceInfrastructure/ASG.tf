data "aws_availability_zones" "all" {}

data "aws_iam_instance_profile" "instance_profile"{
    name = "instance_profile"
}


# ----------------------------------------------------------------------------------
# CREATE THE AUTO SCALING GROUP
# ----------------------------------------------------------------------------------
 resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.sandbox.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  target_group_arns = ["${aws_lb_target_group.sandbox-target.arn}"]
  desired_capacity =  4
  min_size         =  3
  max_size         =  5
  force_delete     =  true
  #vpc_zone_identifier       = ["${aws_subnet.example1.id}", "${aws_subnet.example2.id}"]
  
  vpc_zone_identifier       = ["subnet-0fc83728f731aebd4", "subnet-0ef3812a09d7fd828"]
  
 # problem  notification_target_arn = "arn:aws:sqs:us-east-1:444455556666:queue1*"
 # problem  role_arn                = "arn:aws:iam::429784283093:role/circ-ci"

 # iam_instance_profile = "${data.aws_iam_instance_profile.instance_profile.name}"
 
#Health check type is ELB for any load balancer
  health_check_type = "ELB"
  health_check_grace_period = 300
   tag {
    key = "Name"
    value = "asg-for-webservers"
    propagate_at_launch = true
  }
}

# ---------------------------------------------------------------------------------
# CREATE A LAUNCH CONFIGURATION THAT DEFINES EACH EC2 INSTANCE IN THE ASG
# ----------------------------------------------------------------------------------
 resource "aws_launch_configuration" "sandbox" {
  # AMI is using Redhat 7 - in us-east-1
  image_id = "ami-0b78d6ee1a229d003"
  iam_instance_profile = "data.iam_instance_profile.instance_profile.name"
  instance_type = "t2.micro"
  security_groups = ["${data.aws_security_group.ALBSG.id}"]
   
  # Important note: whenever using a launch configuration with an auto scaling group, you must set
  # create_before_destroy = true. However, as soon as you set create_before_destroy = true in one resource, you must
  # also set it in every resource that it depends on, or you'll get an error about cyclic dependencies (especially when
  # removing resources). 
  
  lifecycle {
    create_before_destroy = true
  }
}