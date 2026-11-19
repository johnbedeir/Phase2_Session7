# Configures the Terraform and AWS provider versions used by the root module.
terraform {
  required_version = ">= 1.10.0"

  backend "s3" {
    bucket       = "education-dev-s3"
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
