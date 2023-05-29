# AWS 

## Prerequisites 

- AWS CLI
- AWS account and access setup
- Serverless framework
- Terraform > 1.0

## Deployment

For the application

    cd app
    serverless deploy -s dev

For the EC2 doing the load testing (Make sure the default VPC has been created)

    cd terraform
    terraform init
    terraform apply
