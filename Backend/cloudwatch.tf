resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name              = "/aws/api-gateway/${aws_api_gateway_rest_api.api.name}"
  retention_in_days = 7
}

module "lambda_logs" {
  source = "terraform-aws-modules/cloudwatch/aws"

  log_groups = {
    lambda = {
      name              = "/aws/lambda/${module.lambda.lambda_function_name}"
      retention_in_days = 7
    }
  }
}

module "api_gateway_logs" {
  source = "terraform-aws-modules/cloudwatch/aws"

  log_groups = {
    api_gateway = {
      name              = "/aws/api-gateway/${module.api_gateway.api_name}"
      retention_in_days = 7
    }
  }
}

module "cloudwatch_alarms" {
  source = "terraform-aws-modules/cloudwatch/aws"

  alarms = {
    lambda_errors = {
      alarm_name          = "lambda-errors"
      metric_name         = "Errors"
      namespace           = "AWS/Lambda"
      statistic           = "Sum"
      threshold           = 5
      period              = 60
      evaluation_periods  = 1
      comparison_operator = "GreaterThanOrEqualToThreshold"
      alarm_description   = "Triggers when Lambda fails 5+ times in a minute."
      alarm_actions       = [module.sns_topic.sns_topic_arn]
    }

    api_gateway_5xx = {
      alarm_name          = "api-gateway-5xx-errors"
      metric_name         = "5XXError"
      namespace           = "AWS/ApiGateway"
      statistic           = "Sum"
      threshold           = 3
      period              = 60
      evaluation_periods  = 1
      comparison_operator = "GreaterThanOrEqualToThreshold"
      alarm_description   = "Triggers when API Gateway returns 3+ server errors in a minute."
      alarm_actions       = [module.sns_topic.sns_topic_arn]
    }

    lambda_duration = {
      alarm_name          = "lambda-duration-high"
      metric_name         = "Duration"
      namespace           = "AWS/Lambda"
      statistic           = "Average"
      threshold           = 5000
      period              = 60
      evaluation_periods  = 1
      comparison_operator = "GreaterThanOrEqualToThreshold"
      alarm_description   = "Triggers when Lambda execution takes longer than 5 seconds."
      alarm_actions       = [module.sns_topic.sns_topic_arn]
    }
  }
}