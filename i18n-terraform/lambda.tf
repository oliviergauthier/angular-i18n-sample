
// Origin Request
resource "aws_lambda_function" "i18n_origin_request" {
  provider = aws.us_east_1
  filename = data.archive_file.i18n_origin_request_lambda_file.output_path
  source_code_hash = data.archive_file.i18n_origin_request_lambda_file.output_base64sha256
  function_name = "i18n-origin-request-lambda"
  handler = "i18n-origin-request-lambda.handler"
  role = aws_iam_role.i18n_lambda.arn
  runtime = "nodejs10.x"
  publish = true
}

data "archive_file" "i18n_origin_request_lambda_file" {
  type = "zip"
  output_path = "${path.module}/build/i18n-origin-request-lambda.zip"

  source {
    content = templatefile("${path.module}/lambdas/i18n-origin-request-lambda.js", { domain : local.cf_alias })
    filename = "i18n-origin-request-lambda.js"
  }
}

// Roles
resource "aws_iam_role" "i18n_lambda" {
  name_prefix = "i18n-lambda-"
  assume_role_policy = data.aws_iam_policy_document.all_lambdas.json
}

data "aws_iam_policy_document" "all_lambdas" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "language_lambda_logs" {
  role = aws_iam_role.i18n_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}