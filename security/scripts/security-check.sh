#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
terraform -chdir="$repo_root/terraform" fmt -check -recursive
terraform -chdir="$repo_root/terraform" init -backend=false
terraform -chdir="$repo_root/terraform" validate
checkov --directory "$repo_root/terraform" --config-file "$repo_root/security/checkov/.checkov.yml"
trivy config --exit-code 1 --severity HIGH,CRITICAL "$repo_root/terraform"
gitleaks detect --source "$repo_root" --no-banner --redact
python -m pytest -q "$repo_root/app"

