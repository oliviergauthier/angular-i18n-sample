output "s3_bucket" {
  value = aws_s3_bucket.this.bucket
}

output "site_url" {
  value = "https://angular-spa-sample.${var.route53_zone_name}"
}