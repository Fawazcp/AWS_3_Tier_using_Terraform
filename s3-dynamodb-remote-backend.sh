#!/bin/bash

# S3 Bucket Creation
s3bucket=$(aws s3api create-bucket --bucket terraform-3-tier-app-remote-state-file-save2 --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2 --output text)

# DynamoDB Table Creation
dynamoDB=$(aws dynamodb create-table --table-name terraform-3-tier-app-remote-db --region us-west-2 --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST --output text)

# echo "s3bucket"
# echo "dynamoDB"

