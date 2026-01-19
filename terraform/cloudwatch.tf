resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "self-healing-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 30
  statistic           = "Average"
  threshold           = 40

  alarm_description = "Alarm when ASG EC2 CPU exceeds 40%"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.self_healing_asg.name
  }

  treat_missing_data = "notBreaching"
}

