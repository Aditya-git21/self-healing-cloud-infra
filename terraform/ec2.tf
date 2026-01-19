data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  owners = ["amazon"]
}

resource "aws_launch_template" "self_healing_lt" {
  name_prefix   = "self-healing-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  key_name = "aws2026"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.self_healing_sg.id]
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
yum update -y
yum install -y httpd stress -y
systemctl start httpd
systemctl enable httpd
echo "Self-Healing EC2 Instance" > /var/www/html/index.html
EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}

