data "aws_iam_policy_document" "assume_role" {
    statement {
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["lambda.amazonaws.com"]
      }

      actions = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role" "iam_for_lambda" {
    name                = "iam_for_lambda"
    assume_role_policy  = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda" {
  type          = "zip"
  source_file   = "./app/handler.py"
  output_path   = "./lambda_layer/lambda_function_payload.zip"
}

resource "aws_lambda_function" "live_lambda_example" {
  filename      = "./lambda_layer/lambda_function_payload.zip"
  function_name = "ingest_data_from_api"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "handler.soma"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.9"
}