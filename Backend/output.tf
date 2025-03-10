output "user_pool_id" {
  value = module.cognito_user_pool.id
}

output "user_pool_client_id" {
  value = module.cognito_user_pool.client_ids["document_app_client"]
}

output "identity_pool_id" {
  value = module.cognito_identity_pool.id
}

output "authenticated_role_arn" {
  value = module.cognito_auth_roles.iam_role_arn
}

output "s3_bucket_name" {
  value = module.document_storage.s3_bucket_id
}

output "dynamodb_table_name" {
  value = module.document_analysis_dynamodb.dynamodb_table_id
}