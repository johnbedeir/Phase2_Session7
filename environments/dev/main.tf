# This directory is a root module. It configures one environment and calls the
# reusable EC2 child module with development-specific values.
module "ec2" {
  source = "../../modules/ec2"

  instance_name = "education-dev-ec2"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.this.id

  tags = {
    Environment = "Development"
  }
}
