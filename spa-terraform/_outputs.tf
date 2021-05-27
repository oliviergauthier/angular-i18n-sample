output "s3_bucket" {
  value = aws_s3_bucket.this.bucket
}

output "site_url" {
  value = "https://${local.cf_alias}"
}