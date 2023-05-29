# GCP 

## Prerequisites 

- gcloud
- GCP account setup
- Serverless framework
- Terraform > 1.0

## Authentication

    gcloud auth application-default login

## Deployment

For the application

    cd app
    serverless deploy -s dev

For the EC2 doing the load testing (Make sure the default VPC has been created)

    cd terraform
    terraform init
    terraform apply
