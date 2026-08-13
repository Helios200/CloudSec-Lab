# Cost Estimation

Exact charges vary by region and usage; check the current AWS Pricing Calculator
before deployment. The ALB, EC2 instances, public IPv4 address use, CloudWatch
logs, S3 storage/requests, GuardDuty analysis, CloudTrail data events (if later
added), and especially a NAT Gateway can incur charges. NAT and compute are off
by default. CloudTrail's first management-event trail may have favorable pricing,
but S3 and CloudWatch ingestion/storage remain billable.

Cost controls include `t3.micro`, an 8 GiB gp3 root disk, one optional NAT rather
than one per AZ (less resilient), 90-day CloudWatch retention, S3 lifecycle rules,
and optional service toggles. `terraform destroy` removes managed infrastructure,
but the protected non-empty log bucket may require an intentional retention or
emptying decision first.

