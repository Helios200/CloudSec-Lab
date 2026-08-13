variable "aws_region" {
  description = "AWS region in which to create the lab."
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Project tag and resource-name prefix."
  type        = string
  default     = "CloudSec-Lab"
}

variable "environment" {
  description = "Deployment environment tag."
  type        = string
  default     = "lab"
}

variable "vpc_cidr" {
  description = "IPv4 CIDR for the VPC."
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDRs for the two public ALB subnets."
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Exactly two public subnet CIDRs are required."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDRs for the two private application subnets."
  type        = list(string)
  default     = ["10.10.10.0/24", "10.10.20.0/24"]
  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "Exactly two private subnet CIDRs are required."
  }
}

variable "instance_type" {
  description = "EC2 instance type for the lab application."
  type        = string
  default     = "t3.micro"
}

variable "enable_nat_gateway" {
  description = "Create one NAT Gateway for private subnet egress (billable)."
  type        = bool
  default     = false
}

variable "enable_cloudtrail" {
  description = "Enable the account audit trail and CloudWatch integration."
  type        = bool
  default     = true
}

variable "enable_guardduty" {
  description = "Enable the regional GuardDuty detector (usage charges apply)."
  type        = bool
  default     = true
}

variable "enable_compute" {
  description = "Launch the private EC2 application tier. Requires outbound access to bootstrap."
  type        = bool
  default     = false
}

variable "github_repository" {
  description = "Optional GitHub repository in owner/name form. Empty disables OIDC resources."
  type        = string
  default     = ""
}

