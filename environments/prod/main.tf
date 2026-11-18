# This directory is a root module. It configures one environment and calls the
# reusable EC2 child module with production-specific values.
module "ec2" {
  source = "../../modules/ec2"

  instance_name = "education-prod-ec2"
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.this.id

  tags = {
    Environment = "Production"
  }
}
