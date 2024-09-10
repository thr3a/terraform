# S3バケットの作成
resource "aws_s3_bucket" "storage_bucket" {
  bucket = "storage.turai.work"
}

resource "aws_s3_bucket_ownership_controls" "storage_bucket_ownership" {
  bucket = aws_s3_bucket.storage_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "storage_bucket_public_access" {
  bucket = aws_s3_bucket.storage_bucket.id

  # バケットの公開設定
  # パブリックアクセスをブロックしない
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "storage_bucket_policy" {
  bucket = aws_s3_bucket.storage_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.storage_bucket.arn}/*"
      },
    ]
  })
}

resource "aws_s3_bucket_cors_configuration" "storage" {
  bucket = aws_s3_bucket.storage_bucket.id

  cors_rule {
    allowed_methods = ["GET"] # GETメソッドを許可
    allowed_origins = ["*"]   # 任意のオリジンからアクセス可能
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_website_configuration" "storage" {
  bucket = aws_s3_bucket.storage_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
