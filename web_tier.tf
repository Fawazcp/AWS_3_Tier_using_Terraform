# Define Web Tier EC2 instance with IAM instance profile
resource "aws_instance" "web-tier" {
  ami                         = "ami-0eb5115914ccc4bc2" # Replace with your desired AMI
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-web-az1.id # Specify the private app subnet ID
  iam_instance_profile        = aws_iam_instance_profile.ec2-profile.name
  vpc_security_group_ids      = [aws_security_group.WebTierSG.id] # Reference the security group ID
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
              source ~/.bashrc
              nvm install 16
              nvm use 16
              cd ~/
              aws s3 cp s3://s3-bucket-for-3-tier-app/web-tier/ web-tier --recursive
              cd ~/web-tier
              npm install 
              npm run build
              sudo amazon-linux-extras install nginx1 -y
              cd /etc/nginx
              ls
              sudo rm nginx.conf
              sudo aws s3 cp s3://s3-bucket-for-3-tier-app/nginx.conf .
              sudo service nginx restart
              chmod -R 755 /home/ec2-user
              sudo chkconfig nginx on
            EOF

  tags = {
    Name        = "Web-Tier-EC2"
    Environment = "dev"
  }

  depends_on = [aws_iam_instance_profile.ec2-profile]
}