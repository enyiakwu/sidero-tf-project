/* resource "aws_s3_bucket" "terraform-state-storage-s3-witcher" {
  bucket = "my-terraform-state-s3-witcher"
  versioning {
    # enable with caution, makes deleting S3 buckets tricky
    enabled = false
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    name = "S3 Remote Terraform State Store"
  }
}

*/

resource "aws_s3_bucket" "sid_bucket_artifacts" {
  bucket = var.artifacts_bucket_name
  force_destroy = true

  tags = {
    name = "S3 Remote Terraform State Store"
  }

}

resource "aws_s3_bucket_acl" "artifact_bucket_acl" {
  bucket = aws_s3_bucket.sid_bucket_artifacts.id
  acl    = "private"

}

resource "aws_s3_bucket_versioning" "artifact_bucket_versioning" {
  bucket = aws_s3_bucket.sid_bucket_artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}