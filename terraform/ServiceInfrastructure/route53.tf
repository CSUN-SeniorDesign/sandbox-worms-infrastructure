data "aws_route53_zone" "sandboxworms_zone"{
   name = "sandboxworms.me."
}
resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.sandboxworms_zone.id}"
  name    = "www"
  type    = "A"
  #ttl     = "300"
    alias {
    name                   = "${aws_alb.sandbox-ALB.dns_name}"
    zone_id                = "${aws_alb.sandbox-ALB.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "apex" {
  zone_id = "${data.aws_route53_zone.sandboxworms_zone.id}"
  name    = ""
  type    = "A"
  #ttl     = "300"
    alias {
    name                   = "${aws_alb.sandbox-ALB.dns_name}"
    zone_id                = "${aws_alb.sandbox-ALB.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "blog" {
  zone_id = "${data.aws_route53_zone.sandboxworms_zone.id}"
  name    = "blog"
  type    = "A"
  #ttl     = "300"
    alias {
    name                   = "${aws_alb.sandbox-ALB.dns_name}"
    zone_id                = "${aws_alb.sandbox-ALB.zone_id}"
    evaluate_target_health = true
  }
}