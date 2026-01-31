data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "main" {
    bucket = var.s3_bucket_name
    object_lock_enabled = true

    tags = {
    Name    = "Filesystem Archive Bucket"
  }
}

resource "aws_s3_bucket_versioning" "main" {
    bucket = aws_s3_bucket.main.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_object_lock_configuration" "main" {
    bucket = aws_s3_bucket.main.id

    rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 180
        }
    } 
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id
 
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "main" {
    bucket = aws_s3_bucket.main.id
    rule {
        status = "Enabled"
        id = "BackupRetention"
        transition {
            days          = 30
            storage_class = "STANDARD_IA"
        }
        transition {
            days          = 90
            storage_class = "GLACIER"
        }
        expiration {
            days = 180
        }
    }
}

data "aws_iam_policy_document" "bucket_policy" {
    statement {
        sid = "AllowUploadsFromBackupUploader"
        effect = "Allow"
        actions = ["s3:PutObject"]
        principals {
            type        = "AWS"
            identifiers = [var.backup_uploader_role_arn]
        }
        condition {
            test = "Null"
            variable = "s3:if-none-match"
            values = ["false"]
        }
        resources = ["${aws_s3_bucket.main.arn}/*"]
    }
}

resource "aws_s3_bucket_policy" "main" {
    bucket = aws_s3_bucket.main.id
    policy = data.aws_iam_policy_document.bucket_policy.json
}