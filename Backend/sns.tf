module "sns_topic" {
  source = "terraform-aws-modules/sns/aws"

  name = "cloudwatch-alerts"

  subscriptions = [
    {
      protocol = "email"
      endpoint = "your-email@example.com"
    }
  ]
}