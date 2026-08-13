$ErrorActionPreference = "Stop"
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
terraform -chdir="$RepoRoot\terraform" fmt -check -recursive
terraform -chdir="$RepoRoot\terraform" init -backend=false
terraform -chdir="$RepoRoot\terraform" validate
checkov --directory "$RepoRoot\terraform" --config-file "$RepoRoot\security\checkov\.checkov.yml"
trivy config --exit-code 1 --severity HIGH,CRITICAL "$RepoRoot\terraform"
gitleaks detect --source "$RepoRoot" --no-banner --redact
python -m pytest -q "$RepoRoot\app"

