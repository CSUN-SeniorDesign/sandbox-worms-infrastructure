data "aws_vpc" "selected" {
  #id = "${var.vpc_id}"
  filter {
    name = "tag:Name"
    values = ["Project 0"]
  }
}

data "aws_security_group" "ALBSG" {
    filter {
        name = "tag:Name"
        values = ["ALBSG"]
    }
}
 
# CERTIFICATES

resource "aws_iam_server_certificate" "sandboxwormscert" {
  name      = "sandboxwormscert"
  certificate_body = "${file("certificates/www_sandboxworms_me.crt")}"
  private_key      = "${file("certificates/sandboxwormsKey.key")}"
  certificate_chain = "${file("certificates/www_sandboxworms_me.pem")}"
}

# APPLICATION LOAD BALANCER

resource "aws_alb" "sandbox-ALB" {
  name               = "sandbox-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups	=	["${data.aws_security_group.ALBSG.id}"]
  subnets		=	["${data.aws_subnet.public_sub1.id}","${data.aws_subnet.public_sub2.id}"]

#  enable_deletion_protection = true
}

# TARGET GROUPS

resource "aws_lb_target_group" "sandbox-target" {
  name     = "sandbox-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.selected.id}"
  health_check {
                path = "/index.html"
                port = "80"
                protocol = "HTTP"
                healthy_threshold = 2
                unhealthy_threshold = 2
                interval = 5
                timeout = 4
                matcher = "200-308"
        }
  
}



resource "aws_alb_target_group_attachment" "web02-assoc" {
  target_group_arn = "${aws_lb_target_group.sandbox-target.arn}"
  target_id        = "${aws_instance.web02.id}"
  port             = 80
}
resource "aws_alb_target_group_attachment" "web01-assoc" {
  target_group_arn = "${aws_lb_target_group.sandbox-target.arn}"
  target_id        = "${aws_instance.web01.id}"
  port             = 80
}



# LISTENERS

resource "aws_alb_listener" "alb_front_https" {
	load_balancer_arn	=	"${aws_alb.sandbox-ALB.arn}"
	port			=	"443"
	protocol		=	"HTTPS"
	ssl_policy		=	"ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
	certificate_arn		=	"${aws_iam_server_certificate.sandboxwormscert.arn}"
	default_action {
		target_group_arn	=	"${aws_lb_target_group.sandbox-target.arn}"
		type			=	"forward"
	}
}
/*
resource "aws_lb_listener_certificate" "www_sandboxworms_me" {
  listener_arn    = "${aws_alb_listener.alb_front_https.arn}"
  certificate_arn = "${aws_iam_server_certificate.sandboxwormscert.arn}"
}*/

resource "aws_alb_listener" "alb-front-redirect" {
	load_balancer_arn	=	"${aws_alb.sandbox-ALB.arn}"
	port			=	"80"
	protocol		=	"HTTP"
	default_action {
    type = "redirect"
    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


