resource "aws_cloudwatch_event_rule" "alarm_rule" {
  name        = "self-healing-alarm-rule"
  description = "Trigger Lambda on CloudWatch alarm"

  event_pattern = jsonencode({
    source = ["aws.cloudwatch"],
    detail-type = ["CloudWatch Alarm State Change"],
    detail = {
      state = {
        value = ["ALARM"]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.alarm_rule.name
  target_id = "self-healing-lambda"
  arn       = aws_lambda_function.self_healing_lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.self_healing_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.alarm_rule.arn
}

