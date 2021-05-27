resource "aws_s3_bucket" "this" {
  bucket        = "betomorrow-angular-i18n-sample"
  acl           = "private"
  force_destroy = true

  tags = local.tags
}

data "aws_iam_policy_document" "read_s3_bucket" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject"
    ]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]
    principals {
      type = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.read_s3_bucket.json
}
