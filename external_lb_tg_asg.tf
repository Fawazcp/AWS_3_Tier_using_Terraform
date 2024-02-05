# AWS LB Target Group for External LB
resource "aws_lb_target_group" "external-lb-tg" {
  name     = "external-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.aws-vpc.id

  health_check {
    path = "/health"
  }
  depends_on = [aws_vpc.aws-vpc]
}

# AWS Load Balancer
resource "aws_lb" "external-lb" {
  name               = "web-tier-external-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internet_facing_lb_sg.id]
  subnets            = [aws_subnet.public-web-az1.id, aws_subnet.public-web-az2.id]

  tags = {
    Environment = "dev"
  }

}

resource "aws_lb_listener" "external-lb-tg-listener" {
  load_balancer_arn = aws_lb.external-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external-lb-tg.arn
  }
}

# Web Tier Launch Template
resource "aws_launch_template" "web-tier-launch-template" {
  name                   = "web-tier-launch-template"
  description            = "Web Tier Launch Template Description"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.WebTierSG.id]
  image_id               = aws_ami_from_instance.webtier-ami.id

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2-profile.name
  }

  depends_on = [
    aws_iam_instance_profile.ec2-profile,
    aws_security_group.WebTierSG,
  ]

}

# Web Tier Auto Scaling Group
resource "aws_autoscaling_group" "web-tier-auto-scalling-group" {
  name                      = "Web-Tier-ASG"
  max_size                  = 2
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.public-web-az1.id, aws_subnet.public-web-az2.id]
  # load_balancers            = [aws_lb.external-lb.id]
  target_group_arns = [aws_lb_target_group.external-lb-tg.arn]

  launch_template {
    id      = aws_launch_template.web-tier-launch-template.id
    version = "$Latest"
  }
}