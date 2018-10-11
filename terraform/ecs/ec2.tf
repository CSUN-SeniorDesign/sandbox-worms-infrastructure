data "aws_subnet" "private_sub1"{
    filter {
        name = "tag:Name"
        values = ["private1"]
    }
}

data "aws_subnet" "private_sub2"{
    filter {
        name = "tag:Name"
        values = ["private2"]
    }
}

data "aws_security_group" "privateInstanceSG" {
    filter {
        name = "tag:Name"
        values = ["privateInstanceSG"]
    }
}

#https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html#

resource "aws_launch_configuration" "sbw-ecs-launch-configuration" {
    name = "sbw-ecs-launch-configuration"
    image_id = "${var.ecs_ami}"
    instance_type = "${var.ecs_instance_type}"
    iam_instance_profile = "${data.aws_iam_instance_profile.ecs-instance-profile.name}"

    root_block_device {
        volume_type = "standard"
        volume_size = 100
        delete_on_termination = true
    }

    lifecycle {
        create_before_destroy = true    
    }
    security_groups = ["${data.aws_security_group.privateInstanceSG.id}"]
    associate_public_ip_address = "false"
    key_name = "${var.aws_key_name}"
    user_data = <<EOF
                #!/bin/bash
                echo ECS_CLUSTER=${var.ecs_cluster} >> /etc/ecs/ecs.config
                EOF
}

resource "aws_autoscaling_group" "sbw-ecs-autoscaling-group" {
    name = "sbw-ecs-autoscaling-group"
    max_size = "4"
    min_size = "1"
    desired_capacity = "2"
    vpc_zone_identifier = ["${data.aws_subnet.private_sub1.id}", "${data.aws_subnet.private_sub2.id}"]
    launch_configuration = "${aws_launch_configuration.sbw-ecs-launch-configuration.name}"
    health_check_type = "ELB"

    tag {
        key = "Name"
        value = "sbw-ecs-cluster"
        propagate_at_launch = true
        }
    }

    resource "aws_ecs_cluster" "sbw-ecs-cluster" {
    name = "${var.ecs_cluster}"
}
    