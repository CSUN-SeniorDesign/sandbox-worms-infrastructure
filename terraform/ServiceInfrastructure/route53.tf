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



resource "aws_route53_zone" "staging" {
  name = "staging.sandboxworms.me"

  tags {
    Environment = "staging"
  }
}
resource "aws_route53_record" "staging-ns" {
  zone_id = "${data.aws_route53_zone.sandboxworms_zone.id}"
  name    = "staging.sandboxworms.me"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.staging.name_servers.0}",
    "${aws_route53_zone.staging.name_servers.1}",
    "${aws_route53_zone.staging.name_servers.2}",
    "${aws_route53_zone.staging.name_servers.3}",
  ]
}

resource "aws_route53_record" "apex-staging" {
  zone_id = "${aws_route53_zone.staging.zone_id}"
  name    = ""
  type    = "A"
  #ttl     = "300"
    alias {
    name                   = "${aws_alb.sandbox-ALB.dns_name}"
    zone_id                = "${aws_alb.sandbox-ALB.zone_id}"
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "www-staging" {
  zone_id = "${aws_route53_zone.staging.zone_id}"
  name    = "www"
  type    = "A"
  #ttl     = "300"
    alias {
    name                   = "${aws_alb.sandbox-ALB.dns_name}"
    zone_id                = "${aws_alb.sandbox-ALB.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "blog-staging" {
  zone_id = "${aws_route53_zone.staging.zone_id}"
  name    = "blog"
  type    = "A"
  #ttl     = "300"
    alias {
    name                   = "${aws_alb.sandbox-ALB.dns_name}"
    zone_id                = "${aws_alb.sandbox-ALB.zone_id}"
    evaluate_target_health = true
  }
}