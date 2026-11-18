# Reuses the account's default VPC while replacing its missing default subnets.
data "aws_vpc" "default" {
  default = true
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "this" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = cidrsubnet(data.aws_vpc.default.cidr_block, 8, 30)
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "education-prod-subnet"
    Environment = "Production"
  }
}
