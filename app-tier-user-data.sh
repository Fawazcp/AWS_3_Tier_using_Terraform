#!/bin/bash
sudo -su ec2-user
sudo yum install mysql -y
mysql -h database-read-replica-1.ctexymoatghm.us-west-2.rds.amazonaws.com -u admin -p
CREATE DATABASE webappdb;   
SHOW DATABASES;
USE webappdb; 

CREATE TABLE IF NOT EXISTS transactions(id INT NOT NULL
AUTO_INCREMENT, amount DECIMAL(10,2), description
VARCHAR(100), PRIMARY KEY(id));    

SHOW TABLES;    
INSERT INTO transactions (amount,description) VALUES ('400','groceries');   
SELECT * FROM transactions;

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