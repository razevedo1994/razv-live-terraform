# Lambda section
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

resource "aws_iam_role" "role" {
    name                = "role_live_terraform"
    assume_role_policy  = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "policy_document" {
  statement {
    effect    = "Allow"
    actions   = ["s3-object-lambda:PutObject"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "policy" {
  name        = "policy_live_terraform"
  description = "Policy for lambda function"
  policy      = data.aws_iam_policy_document.policy_document.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

data "archive_file" "lambda" {
  type          = "zip"
  source_file   = "./app/handler.py"
  output_path   = "./lambda_layer/lambda_function_payload.zip"
}

resource "aws_lambda_function" "live_lambda_example" {
  filename      = "./lambda_layer/lambda_function_payload.zip"
  function_name = "ingest_data_from_api"
  handler       = "handler.soma"
  role          = aws_iam_role.role.arn

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.9"

  depends_on = [ 
    aws_iam_role_policy_attachment.attach
   ]
}

# 