# backend "s3" {
#     bucket         = "{{s3-bucket-name}}"
#     key            = "terraform.tfstate"
#     region         = "{{aws-region}}"
#     dynamodb_table = "{{dynamodb-table-name}}"
#   }


# backend "remote" {
#     organization = "devopswithlasantha"

#     workspaces {
#       name = "3tierapptf-workspace"
#     }
#   }

LockID

terraform-3-tier-project