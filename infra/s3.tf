resource "aws_s3_bucket" "this" {
  bucket = "landing"

  tags = {
    Name = "live-terraform-bucket"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
    bucket = aws_s3_bucket.this.id

    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
    bucket                  = aws_s3_bucket.this.id
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}