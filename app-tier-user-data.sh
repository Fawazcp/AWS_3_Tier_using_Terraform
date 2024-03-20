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