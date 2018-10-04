data "aws_availability_zones" "all" {}

data "aws_iam_instance_profile" "instance_profile" {
    name = "instance_profile"
}

data "aws_ami" "baseAMI" {
    filter {
        name = "tag:Type"
        values = ["baseAMI"]
    }
}

# ----------------------------------------------------------------------------------
# CREATE THE AUTO SCALING GROUP
# ----------------------------------------------------------------------------------
 resource "aws_autoscaling_group" "sandboxworms-asg" {
  launch_configuration = "${aws_launch_configuration.sandbox.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  target_group_arns = ["${aws_lb_target_group.sandbox-target.arn}"]
  desired_capacity =  3
  min_size         =  3
  max_size         =  5
  force_delete     =  true
  vpc_zone_identifier       = ["${data.aws_subnet.private_sub1.id}"]
  
 
#Health check type is ELB for any load balancer
  health_check_type = "ELB"
  health_check_grace_period = 300
   tag {
    key = "Name"
    value = "Webservers"
    propagate_at_launch = true
  }
}

# ---------------------------------------------------------------------------------
# CREATE A LAUNCH CONFIGURATION THAT DEFINES EACH EC2 INSTANCE IN THE ASG
# ----------------------------------------------------------------------------------
 resource "aws_launch_configuration" "sandbox" {
  # AMI is using Redhat 7 - in us-east-1
  image_id = "${data.aws_ami.baseAMI.id}"
  iam_instance_profile = "${data.aws_iam_instance_profile.instance_profile.name}"
  instance_type = "t2.micro"
  security_groups = ["${data.aws_security_group.privateInstanceSG.id}"]
  key_name = "${var.aws_key_name}"

   
  # Important note: whenever using a launch configuration with an auto scaling group, you must set
  # create_before_destroy = true. However, as soon as you set create_before_destroy = true in one resource, you must
  # also set it in every resource that it depends on, or you'll get an error about cyclic dependencies (especially when
  # removing resources). 
  
  lifecycle {
    create_before_destroy = true
  }
}