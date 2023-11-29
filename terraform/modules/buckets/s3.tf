locals {
  s3_bucket_ssl_policy_stmt = {
        Sid = "AllowSSLRequestsOnly"
        Action = ["s3:*"]
        Effect = "Deny"
        Resource = [
          aws_s3_bucket.bucket.arn,
          "${aws_s3_bucket.bucket.arn}/*",
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
        Principal = "*"
      }
  s3_bucket_policy_statement = local.s3_bucket_ssl_policy_stmt
}


resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.bucket.bucket

 
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = local.s3_bucket_policy_statement
  })
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    id = "Transition Current Versions to Intelligent"
    filter {}
    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }
    status = "Enabled"
  }

  rule {
    id = "Set Non Current Versions to expire after 28 days"
    filter {}
    noncurrent_version_expiration {
      noncurrent_days = 28
    }
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = var.versioning
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

