# Lets each root module give its EC2 instance a different name.
variable "instance_name" {
  description = "Name assigned to the EC2 instance."
  type        = string
}

# Lets each environment choose an appropriate amount of CPU and memory.
variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

# Places the instance in the subnet created by its environment root module.
variable "subnet_id" {
  description = "ID of the subnet in which to launch the EC2 instance."
  type        = string
}

# Lets each root module attach its own environment and ownership labels.
variable "tags" {
  description = "Additional tags to assign to the EC2 instance."
  type        = map(string)
  default     = {}
}
