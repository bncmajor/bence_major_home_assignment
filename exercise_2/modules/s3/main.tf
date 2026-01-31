resource "aws_s3_bucket" "main" {
    bucket = "filesystem_archive_bucket"
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