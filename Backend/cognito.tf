module "cognito_user_pool" {
  source  = "terraform-aws-modules/cognito-user-pool/aws"
  version = "~> 5.0"

  name = "document-analysis-app-user-pool"

  alias_attributes        = ["email"]
  auto_verified_attributes = ["email"]

  clients = {
    document_app_client = {
      allowed_oauth_flows = ["code"]
      allowed_oauth_scopes = ["phone", "email", "openid", "profile"]
      callback_urls       = ["http://localhost:3000/callback"]  # Adjust for production
      logout_urls         = ["http://localhost:3000/logout"]
    }
  }
}

module "cognito_identity_pool" {
  source  = "terraform-aws-modules/cognito-identity-pool/aws"
  version = "~> 2.0"

  identity_pool_name                = "document-analysis-app-identity-pool"
  allow_unauthenticated_identities = false

  cognito_identity_providers = [
    {
      provider_name = "cognito-idp.${data.aws_region.current.name}.amazonaws.com/${module.cognito_user_pool.id}"
      client_id     = module.cognito_user_pool.client_ids["document_app_client"]
    }
  ]
}

