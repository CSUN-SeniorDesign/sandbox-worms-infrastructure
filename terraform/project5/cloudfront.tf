##insert cloudfront config
terraform {
  backend "s3" {
    bucket         = "sandboxworms-rstate-0911218-24"
    region         = "us-east-1"
    dynamodb_table = "sandboxworms-lockdb-09112018-24"
    key            = "terraformPROJ5.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "s3" {
  backend = "s3"

  config {
    bucket = "sandboxworms-rstate-0911218-24"
    region = "us-east-1"
    key    = "S3/s3.tfstate"
    name   = "S3/s3.tfstate"
  }
}

data "terraform_remote_state" "cert" {
  backend = "s3"
  config {
    bucket = "sandboxworms-rstate-0911218-24"
    region = "us-east-1"
    key    = "acm/state.tfstate"
    name   = "acm/state.tfstate"
  }
}

resource "aws_cloudfront_distribution" "sandboxworms_distribution" {
  origin {
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }

    domain_name = "${data.terraform_remote_state.s3.sandboxworms-web-endpoint}"
    origin_id   = "sandboxworms.me"
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "sandboxworms.me"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31546000

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  aliases = ["sandboxworms.me","www.sandboxworms.me","blog.sandboxworms.me"]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${data.terraform_remote_state.cert.cert-arn}"
    ssl_support_method  = "sni-only"
  }
}