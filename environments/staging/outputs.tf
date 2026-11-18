# Displays the instance ID returned by the reusable child module.
output "instance_id" {
  description = "ID of the staging EC2 instance."
  value       = module.ec2.instance_id
}
