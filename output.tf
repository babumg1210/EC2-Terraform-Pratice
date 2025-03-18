output "vpc_id" {
  value = module.vpc.vpc_id # Reference the VPC ID from the vpc module's output
}

// Output for subnet details
output "subnet_details" {
  value = { for k, v in var.subnet_details : k => v if v.public == false }
}
