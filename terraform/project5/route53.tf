#insert route53 add record set to use cloudfront

resource "aws_route53_zone" "zone" {
  name = "sandboxworms.me"
}

resource "aws_route53_record" "apex" {
  zone_id = "${aws_route53_zone.zone.zone_id}"
  name    = "sandboxworms.me"
  type    = "A"

  alias = {
    name                   = "${aws_cloudfront_distribution.sandboxworms_distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.sandboxworms_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.zone.zone_id}"
  name    = "www.sandboxworms.me"
  type    = "A"

  alias = {
    name                   = "${aws_cloudfront_distribution.sandboxworms_distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.sandboxworms_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "blog" {
  zone_id = "${aws_route53_zone.zone.zone_id}"
  name    = "blog.sandboxworms.me"
  type    = "A"

  alias = {
    name                   = "${aws_cloudfront_distribution.sandboxworms_distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.sandboxworms_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}