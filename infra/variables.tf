variable "aws_region" {
  default = "us-east-1"
}

variable "lambda_name" {
  default = "ingest_data"
}

variable "s3_bucket_name" {
  default = "live-terraform-bucket"
}