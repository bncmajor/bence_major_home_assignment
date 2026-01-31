# Exercise 2: S3 Archive Bucket

This Terraform configuration provisions an S3 bucket designed for secure filesystem archiving, featuring Object Lock for compliance and automated lifecycle management.

## Key Design Decisions

### Duplicate Prevention & Versioning
To ensure efficient storage and strict retention policies, the bucket policy enforces the presence of the `If-None-Match` header during upload (`PutObject`).

- **Constraint:** The `s3:if-none-match` condition ensures that an object cannot be overwritten if it already exists (since the client typically sends the ETag or '*' to check existence).
- **Effect:** Although **S3 Versioning is enabled** (a prerequisite for S3 Object Lock), this constraint effectively prevents the creation of multiple versions of the same file.
- **Benefit:** This ensures that the **180-day retention period** applies cleanly to the single stored object. Once the retention period expires, the lifecycle rule permanently deletes the object without leaving behind older, non-compliant versions.

## Infrastructure Components

- **S3 Bucket:** `filesystem-archive-bucket` with Object Lock enabled.
- **Object Lock:**
  - Mode: `COMPLIANCE`
  - Retention: 180 days
- **Lifecycle Rules:**
  - **30 days:** Transition to `STANDARD_IA`
  - **90 days:** Transition to `GLACIER`
  - **180 days:** Expiration (Deletion)
- **Bucket Policy:**
  - Restricts uploads to the `backup_uploader` role.
  - Enforces `s3:if-none-match` to prevent overwrites.
