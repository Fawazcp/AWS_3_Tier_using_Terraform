# Define App Tier EC2 instance with IAM instance profile
resource "aws_instance" "app-tier" {
  ami                    = "ami-0c7f9161f8491665f" # Replace with your desired AMI
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private-app-az1.id # Specify the private app subnet ID
  iam_instance_profile   = aws_iam_instance_profile.ec2-profile.name
  vpc_security_group_ids = [aws_security_group.PrivateinstanceSG.id] # Reference the security group ID

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install mysql -y
              curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
              source ~/.bashrc
              nvm install 16
              nvm use 16
              npm install -g pm2   
              cd ~/
              aws s3 cp s3://s3-bucket-for-3-tier-app/app-tier/ app-tier --recursive
              cd ~/app-tier
              npm install
              pm2 start index.js
              pm2 startup
              pm2 save
            EOF

  tags = {
    Name        = "App-Tier-EC2"
    Environment = "dev"
  }

  depends_on = [aws_iam_instance_profile.ec2-profile]
}