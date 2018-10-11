data "aws_alb" "sbw-alb" {
    name = "sandbox-ALB"
}
data "aws_alb_listener" "sbw-alb-listener" {
    load_balancer_arn = "${data.aws_alb.sbw-alb.arn}"
    port = 443
}
data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = ["Project 0"]
  }
}
resource "aws_alb_target_group" "sbw-ecs-target-group" {
    name                = "sbw-ecs-target-group"
    port                = "80"
    protocol            = "HTTP"
    vpc_id   = "${data.aws_vpc.selected.id}"

    health_check {
        healthy_threshold   = "5"
        unhealthy_threshold = "2"
        interval            = "30"
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "5"
    }

    tags {
      Name = "sbw-ecs-target-group"
    }
}

#configure listener rule to forward traffic to the containers
resource "aws_alb_listener_rule" "sbw-forward-containers" {
    listener_arn = "${data.aws_alb_listener.sbw-alb-listener.arn}"
    priority = 99
    action {
        type = "forward"
        target_group_arn = "${aws_alb_target_group.sbw-ecs-target-group.arn}"
    }
    condition {
        field = "host-header"
        values = ["www.sandboxworms.me"]
    }
}