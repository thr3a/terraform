output "s3_bucket_url" {
  value       = aws_s3_bucket.storage_bucket.website_endpoint
  description = "The URL of the S3 bucket"
}

output "s3_bucket_regional_domain_name" {
  value       = aws_s3_bucket.storage_bucket.bucket_regional_domain_name
  description = "Regional S3 endpoint (use as Cloudflareオリジン)"
}
