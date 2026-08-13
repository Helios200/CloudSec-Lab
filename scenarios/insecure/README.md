# Insecure patterns (documentation only)

Do not deploy: SSH or application ports open to `0.0.0.0/0`, a public S3 bucket,
public EC2, unencrypted EBS, disabled CloudTrail, embedded credentials, or
`AdministratorAccess`. These expand attack surface, remove evidence, and turn a
single credential compromise into account compromise.

