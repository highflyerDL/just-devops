# Output variable definitions

output "vpc_public_subnets" {
  description = "IDs of the VPC's public subnets"
  value       = module.vpc.public_subnets
}

output "master_public_ips" {
  description = "Public IP addresses of EC2 instances"
  value       = module.master_ec2s
}

output "worker_public_ips" {
  description = "Public IP addresses of EC2 instances"
  value       = module.worker_ec2s
}
