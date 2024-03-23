# Define Web Tier EC2 instance with IAM instance profile
resource "aws_instance" "web-tier" {
  ami                         = "ami-0c7843ce70e666e51" # Replace with your desired AMI
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-web-az1.id # Specify the private app subnet ID
  iam_instance_profile        = aws_iam_instance_profile.ec2-profile.name
  vpc_security_group_ids      = [aws_security_group.WebTierSG.id] # Reference the security group ID
  associate_public_ip_address = true

  tags = {
    Name        = "Web-Tier-EC2"
    Environment = "dev"
  }

  depends_on = [aws_iam_instance_profile.ec2-profile]
}