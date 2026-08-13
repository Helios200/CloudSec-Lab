output "vpc_id" { value = module.networking.vpc_id }
output "public_subnet_ids" { value = module.networking.public_subnet_ids }
output "private_subnet_ids" { value = module.networking.private_subnet_ids }
output "load_balancer_dns_name" { value = module.compute.load_balancer_dns_name }
output "cloudtrail_bucket_name" { value = module.logging.log_bucket_name }
output "guardduty_detector_id" { value = module.detection.detector_id }
output "github_actions_role_arn" { value = module.iam.github_actions_role_arn }

