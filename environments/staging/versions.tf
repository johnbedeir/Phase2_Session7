# Defines the Terraform and AWS provider versions for this root module.
terraform {
  required_version = ">= 1.10.0"

  backend "s3" {
    bucket       = "education-staging-s3"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
