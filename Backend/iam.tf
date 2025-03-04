module "cognito_auth_roles" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 5.0"

  trusted_role_services = ["cognito-identity.amazonaws.com"]

  role_name = "document-analysis-app-authenticated-role"
  
  role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
}