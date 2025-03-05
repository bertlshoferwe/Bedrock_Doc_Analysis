module "document_storage" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket = "document-analysis-app-${random_string.suffix.result}"
  acl    = "private"

  versioning = {
    enabled = true
  }

  lifecycle_rule = [
    {
      id      = "expire_old_versions"
      enabled = true
      noncurrent_version_expiration = {
        days = 30
      }
    }
  ]

  force_destroy = true
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket_notification" "document_upload_trigger" {
  bucket = module.document_storage.s3_bucket_id

  lambda_function {
    lambda_function_arn = module.document_analysis_lambda.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
  }
}