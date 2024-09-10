output "s3_bucket_url" {
  value       = aws_s3_bucket.storage_bucket.website_endpoint
  description = "The URL of the S3 bucket"
}
