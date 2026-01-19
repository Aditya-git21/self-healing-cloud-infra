resource "aws_autoscaling_group" "self_healing_asg" {
  name                = "self-healing-asg"
  desired_capacity    = 1
  min_size            = 1
  max_size            = 2
  vpc_zone_identifier = data.aws_subnets.default.ids

  launch_template {
    id      = aws_launch_template.self_healing_lt.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 60

  tag {
    key                 = "Name"
    value               = "self-healing-ec2"
    propagate_at_launch = true
  }
}

