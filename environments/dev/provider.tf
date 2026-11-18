# Provider configuration belongs in the root module, not the reusable child module.
provider "aws" {
  region = "us-east-1"
}
