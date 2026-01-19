data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "self_healing_lambda" {
  function_name = "self-healing-handler"
  role          = aws_iam_role.lambda_role.arn
  handler       = "heal.lambda_handler"
  runtime       = "python3.9"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      ASG_NAME = aws_autoscaling_group.self_healing_asg.name
    }
  }

}

