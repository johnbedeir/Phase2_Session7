# This directory is a root module. It configures one environment and calls the
# reusable EC2 child module with staging-specific values.
module "ec2" {
  source = "../../modules/ec2"

  instance_name = "education-staging-ec2"
  instance_type = "t3.small"
  subnet_id     = aws_subnet.this.id

  tags = {
    Environment = "Staging"
  }
}
