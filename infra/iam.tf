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
    actions   = [
				"s3:PutObject",
				"s3:GetObject"
			]
    resources = ["arn:aws:s3:::*/*"]
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