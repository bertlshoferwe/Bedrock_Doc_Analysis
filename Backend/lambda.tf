#Grants write access to dynamodb so lambda can store analysis results
#grants S3 read access to retrieve uploaded documents
#grants bedrock acces to use the amazon titan model for document analysis
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

#get analysis results
module "get_analysis_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 5.0"

  function_name = "get-analysis-results"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 30

  source_path = "${path.module}/lambda_get_results_code"

  environment_variables = {
    DYNAMODB_TABLE = module.document_analysis_dynamodb.dynamodb_table_id
  }

  attach_policy_statements = true
  policy_statements = [
    {
      effect    = "Allow"
      actions   = ["dynamodb:Query"]
      resources = [module.document_analysis_dynamodb.dynamodb_table_arn]
    }
  ]
}