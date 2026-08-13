data "aws_availability_zones" "available" {
  state = "available"
}

check "compute_has_bootstrap_egress" {
  assert {
    condition     = !var.enable_compute || var.enable_nat_gateway
    error_message = "The demo compute bootstrap pulls packages and requires enable_nat_gateway=true. Use a private image and VPC endpoints before removing this guard."
  }
}

module "networking" {
  source = "./modules/networking"

  name_prefix         = local.name_prefix
  vpc_cidr            = var.vpc_cidr
  availability_zones  = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway  = var.enable_nat_gateway
}

module "security_groups" {
  source = "./modules/security-groups"

  name_prefix = local.name_prefix
  vpc_id      = module.networking.vpc_id
}

module "iam" {
  source = "./modules/iam"

  name_prefix      = local.name_prefix
  github_repository = var.github_repository
}

module "compute" {
  source = "./modules/compute"

  enabled               = var.enable_compute
  name_prefix           = local.name_prefix
  vpc_id                = module.networking.vpc_id
  public_subnet_ids     = module.networking.public_subnet_ids
  private_subnet_ids    = module.networking.private_subnet_ids
  alb_security_group_id = module.security_groups.alb_security_group_id
  app_security_group_id = module.security_groups.app_security_group_id
  instance_profile_name = module.iam.ec2_instance_profile_name
  instance_type         = var.instance_type
}

module "logging" {
  source = "./modules/logging"

  name_prefix      = local.name_prefix
  enable_cloudtrail = var.enable_cloudtrail
}

module "detection" {
  source = "./modules/detection"

  enable_guardduty = var.enable_guardduty
}
