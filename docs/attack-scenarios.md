# Attack Scenarios

1. **Backend scan:** an attacker scans the ALB address for port 8000. The ALB SG
   exposes only 80, while EC2 has no public IP and trusts only the ALB SG.
2. **Leaked CI credential:** there is no stored AWS access key. GitHub exchanges
   an OIDC token for short-lived credentials constrained to `main`.
3. **Audit evasion:** disabling CloudTrail or changing its bucket policy creates
   management events; protected, versioned logs support investigation.
4. **Vulnerable image:** Trivy blocks high/critical fixable findings before merge;
   Dependabot and pip-audit shorten remediation time.

These are defensive tabletop exercises, not authorization to probe third-party
systems.

