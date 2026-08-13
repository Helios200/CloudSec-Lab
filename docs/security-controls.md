# Security Controls

| Security area | Control | Purpose |
|---|---|---|
| Network | Private application subnets | Remove direct Internet exposure |
| Network | SG references | Permit backend traffic only from the ALB |
| IAM | Workload role | Use temporary credentials and limit blast radius |
| Authentication | GitHub OIDC | Avoid permanent CI access keys |
| Logging | Multi-region CloudTrail | Audit management API activity |
| Detection | GuardDuty | Analyze AWS telemetry for suspicious behavior |
| Storage | S3 Public Access Block | Prevent accidental log exposure |
| Encryption | EBS and S3 encryption | Protect data at rest |
| Compute | IMDSv2 and no SSH | Reduce metadata theft and host exposure |
| IaC | Terraform modules | Reproducible, reviewable infrastructure |
| DevSecOps | Checkov and Trivy | Find IaC misconfiguration before merge |
| Containers | Non-root image and Trivy | Reduce runtime privilege and known CVEs |
| Secrets | Gitleaks | Detect credential leakage |
| CI/CD | GitHub Actions | Enforce repeatable security gates |

CloudTrail records IAM and bucket-policy changes, role assumptions, instance
launches, security-group changes, and attempts to alter logging. Log-file
validation supports integrity checks; versioning aids recovery. GuardDuty is a
separate detective layer and can identify patterns such as credential misuse,
malicious IP activity, and anomalous API calls. Neither replaces prevention.

S3 uses SSE-S3 for a cost-conscious lab. Production may use a customer-managed
KMS key for stronger separation and key auditing. Transit to S3 is forced through
TLS. Application HTTPS requires a real ACM-validated domain and is documented,
not fabricated.

