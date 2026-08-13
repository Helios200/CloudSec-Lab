# Deployment Guide

## Prerequisites

Git, Python 3.13, Docker, Terraform 1.8+, AWS CLI, Checkov, Trivy, and Gitleaks.
Use an authorized sandbox account and verify the AWS identity yourself before any
deployment. This repository never runs AWS commands automatically.

## Local checks

```powershell
python -m pip install -r app\requirements-dev.txt
python -m pytest -q app
.\security\scripts\security-check.ps1
```

On Linux/macOS run `./security/scripts/security-check.sh`. Build the image with
`docker build -t cloudsec-lab:local app`.

## Terraform

Copy `terraform.tfvars.example` to an ignored `terraform.tfvars`, review every
toggle, then run `terraform init -backend=false`, `terraform validate`, and
`terraform plan -out=cloudsec.tfplan` from `terraform/`. Deployment is a manual,
authorized action: `terraform apply cloudsec.tfplan`. Cleanup is `terraform
destroy`; review its plan before confirming.

With NAT disabled, private instances cannot reach public package registries or
public SSM endpoints. Keep compute disabled, enable the billable NAT Gateway, or
add SSM, EC2 Messages, SSM Messages, S3, and image-registry VPC endpoints.

## State and CI authentication

Local state is ignored. Production should use a dedicated versioned, encrypted
S3 backend with restricted access and native S3 state locking (`use_lockfile =
true` on supported Terraform versions); enable bucket recovery protections.

Set `github_repository` to create a branch-scoped GitHub OIDC trust. The role has
no permissions by default: attach only plan/deploy actions needed by that repo.
CI requests short-lived STS credentials; permanent AWS keys are not recommended.

