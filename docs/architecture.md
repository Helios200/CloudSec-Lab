# Architecture

The Internet-facing ALB spans two public subnets. Two optional EC2 instances sit
in separate private subnets with no public IP and accept port 8000 only from the
ALB security group. There is no SSH rule; Session Manager uses the instance role.

**Why:** the load balancer is the only public entry point. This reduces direct
probing and exploitation of hosts. **Trade-off:** private hosts need NAT or VPC
endpoints to reach SSM and retrieve dependencies. NAT is off by default because
it has a continuous cost; compute is also off until an image/bootstrap strategy
and egress are chosen.

HTTP is retained for a domain-free lab. Production should attach an ACM
certificate to a port 443 listener and redirect port 80 to HTTPS. The backend can
also use TLS where end-to-end encryption is required.

See [the source diagram](../diagrams/architecture.mmd).

