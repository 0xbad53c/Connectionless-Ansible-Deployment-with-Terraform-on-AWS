// Create S3 bucket for ansible playbook sharing
locals {
  bucket_name_base = lower(replace("${var.server_name}", "_", "-"))                                       // replace _ with - and lowercase all to be accepted as bucket name
  bucket_name      = substr("${local.bucket_name_base}-${random_string.bucket_randomized.result}", 0, 63) // Add some randomization to bucket name
}

// random string to append to bucket name (prevents issues with destroy and rebuild)
resource "random_string" "bucket_randomized" {
  length  = 16
  special = false
  numeric = true
  upper   = false
}

// Create new s3 bucket
resource "aws_s3_bucket" "ansible" {
  bucket        = local.bucket_name
  force_destroy = true
}

// restrict public bucket access
resource "aws_s3_bucket_public_access_block" "ansible" {
  bucket = aws_s3_bucket.ansible.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Delete objects in bucket after 1 day
resource "aws_s3_bucket_lifecycle_configuration" "ansible" {
  bucket = aws_s3_bucket.ansible.id

  rule {
    id     = "expire-after-${tostring(var.s3_data_expiration_days)}-day"
    status = "Enabled"

    expiration {
      days = var.s3_data_expiration_days // expire bucket contents after one day
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = var.s3_data_expiration_days // if upload failed, also expire data after 1 day
    }
  }
}
