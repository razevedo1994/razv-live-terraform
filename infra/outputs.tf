output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_id" {
  value = aws_subnet.this.id
}

output "security_group_ids" {
  value = aws_security_group.this.id
}

output "bucket_name" {
  value = aws_s3_bucket.this.arn
}