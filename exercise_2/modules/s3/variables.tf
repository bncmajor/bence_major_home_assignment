variable "backup_uploader_role_arn" {
  description = "IAM role ARN allowed to upload to the archive bucket"
  type        = string
  default = "arn:aws:iam::123456789012:role/backup_uploader"
  validation {
    condition     = can(regex("^arn:aws:iam::\\d{12}:role/[a-zA-Z0-9-_]+$", var.backup_uploader_role_arn))
    error_message = "Must be a valid IAM role ARN."
  }
}

variable "s3_bucket_name" {
    description = "Name of the bucket"
    type        = string
    default     = "filesystem-archive-bucket"
}