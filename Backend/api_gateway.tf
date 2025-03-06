module "api_gateway" {
  source  = "terraform-aws-modules/api-gateway/aws"
  version = "~> 4.0"

  name = "document-analysis-api"

  authorizers = [
    {
      name               = "cognito-authorizer"
      type               = "COGNITO_USER_POOLS"
      provider_arns      = [module.cognito_user_pool.user_pool_arn]
      identity_source    = "method.request.header.Authorization"
      rest_api_id        = module.api_gateway.rest_api_id
      authorization_type = "COGNITO_USER_POOLS"
    }
  ]

  resources = [
    {
      path          = "/documents"
      method        = "POST"
      authorization = "COGNITO_USER_POOLS"
      authorizer_id = "cognito-authorizer"
    }
  ]
}

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

resource "aws_api_gateway_method" "post_document" {
  rest_api_id   = module.api_gateway.rest_api_id
  resource_id   = module.api_gateway.resource_ids["documents"]
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = module.api_gateway.authorizers["cognito-authorizer"].authorizer_id

  request_parameters = {
    "method.request.header.Authorization" = true
  }
}