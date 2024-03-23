#!/bin/bash

sudo yum update -y 
sudo yum install -y mariadb-server
sudo systemctl enable mariadb
sudo systemctl start mariadb
sudo mysql_secure_installation