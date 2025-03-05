module "document_analysis_dynamodb" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 2.0"

  name         = "DocumentAnalysisResults"
  hash_key     = "document_id"
  billing_mode = "PAY_PER_REQUEST"

  attributes = [
    { name = "document_id", type = "S" },
    { name = "user_id", type = "S" }
  ]

  global_secondary_indexes = [
    {
      name            = "UserIndex"
      hash_key        = "user_id"
      projection_type = "ALL"
    }
  ]
}