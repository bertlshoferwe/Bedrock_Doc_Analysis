module "document_analysis_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 5.0"

  function_name = "document-analysis"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 30

  source_path = "${path.module}/lambda_code"

  environment_variables = {
    S3_BUCKET     = module.document_storage.s3_bucket_id
    BEDROCK_MODEL = "amazon.titan-text-express-v1"
     DYNAMODB_TABLE = module.document_analysis_dynamodb.dynamodb_table_id
  }

  attach_policy_statements = true
  policy_statements = [
    {
      effect    = "Allow"
      actions   = ["s3:GetObject"]
      resources = ["${module.document_storage.s3_bucket_arn}/*"]
    },
    {
      effect    = "Allow"
      actions   = ["bedrock:InvokeModel"]
      resources = ["*"]
    },
     {
      effect    = "Allow"
      actions   = ["dynamodb:PutItem"]
      resources = [module.document_analysis_dynamodb.dynamodb_table_arn]
    }
  ]
}