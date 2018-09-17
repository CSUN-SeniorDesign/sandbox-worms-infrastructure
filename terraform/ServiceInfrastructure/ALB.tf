# CERTIFICATES

resource "aws_iam_server_certificate" "sandboxwormscert" {
  name      = "sandboxwormscert"
  certificate_body = "${file("certificates/www_sandboxworms_me.crt")}"
  private_key      = "${file("certificates/sandboxwormsKey.key")}"
}

# APPLICATION LOAD BALANCER

resource "aws_lb" "sandbox-ALB" {
  name               = "sandbox-ALB"
  internal           = false
  load_balancer_type = "application"
#  security_groups    = ["${aws_security_group.lb_sg.id}"]
  subnets            = ["subnet-047a3c4852741bde2"]

  enable_deletion_protection = true
}

# TARGET GROUPS

resource "aws_lb_target_group" "targ" {
  name     = "Sandbox_Target"
  port     = 80
  protocol = "HTTPS"
  vpc_id   = "vpc-02a9e259e7acb0d5f | Project 0"
}


/*
resource "aws_alb_target_group_attachment" "web02-assoc" {
  target_group_arn = "${aws_alb_target_group.targ.arn}"
  target_id        = "${aws_instance.web02.id}"
  port             = 80
}
resource "aws_alb_target_group_attachment" "web01-assoc" {
  target_group_arn = "${aws_alb_target_group.targ.arn}"
  target_id        = "${aws_instance.web01.id}"
  port             = 80
}
*/


# LISTENERS
/*
resource "aws_alb_listener" "alb-listener" {
	load_balancer_arn	=	"${aws_alb.sandbox-ALB.arn}"
	port			=	"443"
	protocol		=	"HTTPS"
	ssl_policy		=	"ELBSecurityPolicy-2016-08"
	certificate_arn		=	"${aws_iam_server_certificate.sandboxwormscert.arn}"
	default_action {
		target_group_arn	=	"${aws_alb_target_group.targ.arn}"
		type			=	"forward"
	}
}
*/
