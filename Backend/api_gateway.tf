module "document_analysis_api" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "~> 2.0"

  name          = "DocumentAnalysisAPI"
  description   = "API to fetch document analysis results"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_methods = ["GET"]
    allow_origins = ["*"]
  }

  target_arn = module.get_analysis_lambda.lambda_function_arn
}