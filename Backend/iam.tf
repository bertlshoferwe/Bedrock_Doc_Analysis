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
      "${module.document_storage.s3_bucket_arn}/private/\${cognito-identity.amazonaws.com:sub}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [module.cognito_auth_roles.iam_role_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:userid"
      values   = ["\${cognito-identity.amazonaws.com:sub}"]
    }
  }
}

resource "aws_s3_bucket_policy" "document_storage_policy" {
  bucket = module.document_storage.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_access_policy.json
}