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

data "aws_iam_policy_document" "bucket_policy" {
    statement {
        sid = "BlockNonUploaderUploads"
        effect = "Deny"
        actions = ["s3:PutObject"]
        principals {
            type        = "AWS"
            identifiers = ["*"]
        }
        condition {
            test = "StringNotEquals"
            variable = "aws:PrincipalArn"
            values = ["arn:aws:iam::123456789012:role/backup_uploader"]
        }
        resources = ["${aws_s3_bucket.main.arn} + /*"]
    }

    statement {
        sid = "EnforceWriteOnly"
        effect = "Deny"
        actions = ["s3:PutObject"]
        principals {
            type        = "AWS"
            identifiers = ["*"]
        }
        condition {
            test = "StringNotEquals"
            variable = "s3:if-none-match"
            values = ["*"]
        }
        resources = ["${aws_s3_bucket.main.arn} + /*"]
    }

    statement {
        sid = "BlockDeletes"
        effect = "Deny"
        actions = ["s3:DeleteObject"]
        principals {
            type        = "AWS"
            identifiers = ["*"]
        }
        resources = ["${aws_s3_bucket.main.arn} + /*"]
    }
}

resource "aws_s3_bucket_policy" "main" {
    bucket = aws_s3_bucket.main.id
    policy = data.aws_iam_policy_document.bucket_policy.json
}