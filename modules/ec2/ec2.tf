# This directory is a reusable child module. It defines an EC2 instance but
# receives environment-specific values from a root module.
resource "aws_instance" "this" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
  }

  tags = merge(var.tags, {
    Name = var.instance_name
  })
}
