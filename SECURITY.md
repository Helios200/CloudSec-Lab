# Security Policy

CloudSec-Lab is an educational security project. It is not a production service
and must never contain real credentials, private keys, Terraform state, or
sensitive AWS data.

## Reporting a vulnerability

Please report security issues privately to the repository owner using GitHub's
private vulnerability reporting feature. Include the affected file or control,
the impact, and safe reproduction steps. Do not open a public issue containing
secrets or exploit details.

## Responsible testing

Only test infrastructure you own or are explicitly authorized to assess. Do not
deploy intentionally insecure examples; they are documentation-only. Revoke and
rotate any credential that is accidentally exposed, then purge it from Git
history. Never run destructive Terraform or AWS commands without confirming the
target account, region, workspace, and plan.

