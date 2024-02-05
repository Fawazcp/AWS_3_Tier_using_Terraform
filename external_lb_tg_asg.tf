# AWS LB Target Group for Internal LB
resource "aws_lb_target_group" "internal-lb-tg" {
  name     = "internal-lb-tg"
  port     = 4000
  protocol = "HTTP"
  vpc_id   = aws_vpc.aws-vpc.id

  health_check {
    path = "/health"
  }
  depends_on = [aws_vpc.aws-vpc]
}

# AWS Load Balancer
resource "aws_lb" "internal-lb" {
  name               = "app-tier-internal-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internal-lb-sg.id]
  subnets            = [aws_subnet.private-app-az1.id, aws_subnet.private-app-az2.id]

  tags = {
    Environment = "dev"
  }

}

resource "aws_lb_listener" "internal-lb-tg-listener" {
  load_balancer_arn = aws_lb.internal-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal-lb-tg.arn
  }
}

# App Tier Launch Template
resource "aws_launch_template" "app-tier-launch-template" {
  name                   = "app-tier-launch-template"
  description            = "App Tier Launch Template Description"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.PrivateinstanceSG.id]
  image_id               = aws_ami_from_instance.apptier-ami.id

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2-profile.name
  }

  depends_on = [
    aws_iam_instance_profile.ec2-profile,
    aws_security_group.PrivateinstanceSG,
  ]

}

# App Tier Auto Scaling Group
resource "aws_autoscaling_group" "app-tier-auto-scalling-group" {
  name                      = "App-Tier-ASG"
  max_size                  = 2
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.private-app-az1.id, aws_subnet.private-app-az2.id]
  #   load_balancers            = [aws_lb.internal-lb.id]
  target_group_arns = [aws_lb_target_group.internal-lb-tg.arn]

  launch_template {
    id      = aws_launch_template.app-tier-launch-template.id
    version = "$Latest"
  }
}