terraform {
  backend "s3" {
    bucket         = "my-tf2025-state-bucket"
    key            = "two-tier/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
