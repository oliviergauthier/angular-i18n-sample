
locals {
  cf_alias = "angular-i18n-sample.${var.route53_zone_name}"
}

data "aws_route53_zone" "this" {
  name = var.route53_zone_name
}

data "aws_acm_certificate" "cloudfront" {
  provider    = aws.us_east_1
  domain      = data.aws_route53_zone.this.name
  most_recent = true
}

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = aws_s3_bucket.this.bucket
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.this.bucket
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [local.cf_alias]

  custom_error_response {
    error_caching_min_ttl = 300
    error_code = 404
    response_code = 200
    response_page_path = "/index.html"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.this.bucket

    forwarded_values {
      query_string = false
      headers = ["Accept-Language", "Origin"]
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0

    lambda_function_association {
      event_type = "origin-request"
      lambda_arn = aws_lambda_function.i18n_origin_request.arn
      include_body = true
    }
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.cloudfront.arn
    ssl_support_method = "sni-only"
  }

  tags = local.tags
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.id
  name = local.cf_alias
  type = "A"

  alias {
    name = aws_cloudfront_distribution.this.domain_name
    zone_id = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }
}