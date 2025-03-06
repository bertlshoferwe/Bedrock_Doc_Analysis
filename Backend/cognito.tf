module "cognito_user_pool" {
  source  = "terraform-aws-modules/cognito-user-pool/aws"
  version = "~> 5.0"

  name = "document-analysis-app-user-pool"

  alias_attributes         = ["email"]
  auto_verified_attributes = ["email"]

  clients = {
    document_app_client = {
      allowed_oauth_flows  = ["code"]
      allowed_oauth_scopes = ["phone", "email", "openid", "profile"]
      callback_urls        = ["http://localhost:3000/callback"] # Adjust for production
      logout_urls          = ["http://localhost:3000/logout"]
    }
  }

  password_policy = {
    minimum_length    = 8
    require_uppercase = true
    require_numbers   = true
    require_symbols   = true
  }

  lambda_config = {
    pre_sign_up = aws_lambda_function.cognito_pre_signup.arn
  }

  schema = [
    {
      name                = "email"
      required            = true
      mutable             = false
      attribute_data_type = "String"
    }
  ]

}

module "cognito_user_pool_client" {
  source  = "terraform-aws-modules/cognito/aws"
  version = "~> 2.0"

  user_pool_id = module.cognito_user_pool.user_pool_id
  name         = "document-analysis-app-client"

  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

  allowed_oauth_flows  = ["code"]
  allowed_oauth_scopes = ["phone", "email", "openid", "profile"]
  callback_urls        = ["http://localhost:3000/callback"]
  logout_urls          = ["http://localhost:3000/logout"]
}

module "cognito_identity_pool" {
  source  = "terraform-aws-modules/cognito-identity-pool/aws"
  version = "~> 2.0"

  identity_pool_name               = "document-analysis-app-identity-pool"
  allow_unauthenticated_identities = false

  cognito_identity_providers = [
    {
      provider_name = "cognito-idp.${data.aws_region.current.name}.amazonaws.com/${module.cognito_user_pool.id}"
      client_id     = module.cognito_user_pool.client_ids["document_app_client"]
    }
  ]
}

