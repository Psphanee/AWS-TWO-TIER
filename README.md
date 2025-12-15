# AWS-TWO-TIER

Two-Tier Highly Available AWS Architecture using Terraform & GitHub Actions
📌 Project Overview

This project provisions a highly available two-tier architecture in AWS using Terraform and GitHub Actions.
The architecture consists of a web tier deployed in public subnets and a database tier deployed in private subnets within a custom VPC.

Infrastructure provisioning is automated using Terraform, with remote state management via Amazon S3 and state locking via Amazon DynamoDB.
CI is implemented using GitHub Actions, which automatically runs Terraform on every push to the main branch.

🏗 Target Architecture
High-Level Components

Custom VPC

2 Public Subnets (Web Tier – Multi-AZ)

2 Private Subnets (Database Tier – Multi-AZ)

Internet Gateway

Route Tables

EC2 instances with Apache web server

Amazon RDS (MySQL)

Security Groups

S3 backend for Terraform state

DynamoDB for state locking

GitHub Actions CI pipeline

Architecture Diagram (Logical)
Internet
   |
Internet Gateway
   |
Public Subnets (AZ-A, AZ-B)
   |
EC2 Web Servers (Apache)
   |
Security Group
   |
Private Subnets (AZ-A, AZ-B)
   |
RDS MySQL

🛠 Technology Stack
Layer	Technology
Cloud Provider	AWS
Infrastructure as Code	Terraform
Compute	Amazon EC2
Database	Amazon RDS (MySQL)
Networking	VPC, Subnets, Route Tables
State Management	S3 + DynamoDB
CI/CD	GitHub Actions
OS	Amazon Linux 2
Web Server	Apache
📁 Project Structure
.
├── backend.tf
├── provider.tf
├── variables.tf
├── vpc.tf
├── security_groups.tf
├── ec2.tf
├── rds.tf
├── outputs.tf
└── .github/
    └── workflows/
        └── terraform.yml

🔐 Terraform Remote Backend

Terraform state is stored remotely using Amazon S3 and locked using DynamoDB.

Backend Configuration
terraform {
  backend "s3" {
    bucket         = "my-tf2025-state-bucket"
    key            = "two-tier/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

Required Manual Setup (One-Time)

Terraform does not create its own backend.
You must manually create:

S3 Bucket

Name: my-tf2025-state-bucket

Region: us-west-2

Versioning: Enabled

Public Access: Blocked

DynamoDB Table

Name: terraform-locks

Partition Key: LockID (String)

Region: us-west-2

🔑 AWS Authentication
IAM User

Create an IAM user (for lab/demo purposes):

Name: terraform-user

Permissions: AdministratorAccess

GitHub Secrets

Add the following secrets to your GitHub repository:

Secret Name	Value
AWS_ACCESS_KEY_ID	IAM access key
AWS_SECRET_ACCESS_KEY	IAM secret key
AWS_REGION	us-west-2
🚀 GitHub Actions CI Pipeline

The GitHub Actions workflow automatically runs on every push to the main branch.

Workflow Responsibilities

Checkout source code

Install Terraform

Initialize Terraform backend

Validate Terraform configuration

Generate Terraform plan

Workflow File

.github/workflows/terraform.yml

name: Terraform CI

on:
  push:
    branches:
      - main

jobs:
  terraform:
    runs-on: ubuntu-latest

    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      AWS_REGION: ${{ secrets.AWS_REGION }}

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.6.6

      - name: Terraform Init
        run: terraform init -reconfigure

      - name: Terraform Validate
        run: terraform validate

      - name: Terraform Plan
        run: terraform plan

▶️ How to Run the Project
Local Execution
terraform init
terraform validate
terraform plan
terraform apply

GitHub Actions Execution
git push origin main


Monitor progress in:

GitHub → Actions → Terraform CI

📤 Outputs

After successful deployment:

Output	Description
web_public_ips	Public IPs of EC2 web servers
rds_endpoint	RDS MySQL endpoint
🧹 Cleanup (Avoid Charges)
terraform destroy
