output "ec2_role_name" {
  value = aws_iam_role.ec2_role.name
}

output "lambda_role_name" {
  value = aws_iam_role.lambda_role.name
}

