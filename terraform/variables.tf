variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "alert_email" {
  description = "Email address to receive infrastructure alerts"
  type        = string
}

