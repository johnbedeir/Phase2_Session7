# Returns the child module's instance ID to the calling root module.
output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.this.id
}
