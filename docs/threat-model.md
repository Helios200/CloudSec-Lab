# Threat Model

This lightweight STRIDE-inspired model covers the AWS account, IAM identities,
private application hosts, CI workflow, source repository, container image,
Terraform state, audit trail, and log bucket.

| Threat | Category | Asset/impact | Primary controls | Residual risk |
|---|---|---|---|---|
| Stolen long-lived AWS key | Spoofing | AWS account takeover | IAM roles, GitHub OIDC, no keys in source, Gitleaks | Compromised trusted identity |
| Excessive permissions | Elevation | Large blast radius | workload role has SSM only; scoped OIDC trust | AWS-managed policy changes |
| Direct backend probing | Tampering/DoS | Application host | no public IP, ALB-only SG ingress, IMDSv2 | ALB-layer attack |
| Malicious dependency/image | Tampering | CI and runtime | pinned direct dependencies, Dependabot, pip-audit, Trivy, Bandit | zero-day or compromised upstream |
| CI workflow compromise | Elevation | Source and AWS | minimal workflow permissions, branch-bound OIDC, review gate | trusted action compromise; pin SHAs in production |
| Secret committed to Git | Information disclosure | credentials | ignore rules, Gitleaks, no runtime-data endpoint | history retains secret until purged |
| Audit logs deleted | Repudiation | investigation evidence | separate bucket, no app access, versioning, TLS-only policy, validation | account admin can still disable controls |
| Bucket made public | Information disclosure | audit data | all four Public Access Block settings, owner enforcement | privileged policy change |
| Unauthorized IaC change | Tampering | infrastructure | PR scans, plan review, CloudTrail | malicious approved change |
| State disclosure | Information disclosure | resource metadata/secrets | state ignored; encrypted remote backend design | local state mishandling |

Trust boundaries exist at Internet→ALB, ALB→application, GitHub→AWS STS, and
CloudTrail→S3/CloudWatch. Controls are preventive where possible and detective
where privileged account actions cannot be technically prevented by this lab.

