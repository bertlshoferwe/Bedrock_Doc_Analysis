module "cognito_auth_roles" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 5.0"

  trusted_role_services = ["cognito-identity.amazonaws.com"]

  role_name = "document-analysis-app-authenticated-role"

  role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
}

data "aws_iam_policy_document" "s3_access_policy" {
  statement {
    actions = ["s3:PutObject", "s3:GetObject"]
    resources = [
      "${module.document_storage.s3_bucket_arn}/private/$${cognito-identity.amazonaws.com:sub}/*"

    ]

    principals {
      type        = "AWS"
      identifiers = [module.cognito_auth_roles.iam_role_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:userid"
      values   = ["$${cognito-identity.amazonaws.com:sub}"]
    }
  }
}

resource "aws_s3_bucket_policy" "document_storage_policy" {
  bucket = module.document_storage.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_access_policy.json
}

module "api_gateway_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "~> 4.0"

  name = "document-analysis-api-gateway-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

module "api_gateway_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 4.0"

  name        = "document-analysis-api-policy"
  description = "API Gateway policy to invoke Lambda function"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "lambda:InvokeFunction"
        Resource = module.lambda_function.arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "api_gateway_policy_attachment" {
  role       = module.api_gateway_role.name
  policy_arn = module.api_gateway_policy.arn
}

module "lambda_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "~> 4.0"

  name = "document-analysis-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect   = "Allow"
        Sid      = ""
      }
    ]
  })
}

module "lambda_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 4.0"

  name        = "document-analysis-lambda-policy"
  description = "Lambda policy to access S3 and DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:GetObject"]
        Resource = "arn:aws:s3:::your-s3-bucket-name/*"
      },
      {
        Effect   = "Allow"
        Action   = ["dynamodb:PutItem", "dynamodb:GetItem"]
        Resource = "arn:aws:dynamodb:your-region:your-account-id:table/your-table-name"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = module.lambda_role.name
  policy_arn = module.lambda_policy.arn
}