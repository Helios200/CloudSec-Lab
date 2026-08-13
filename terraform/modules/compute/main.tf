data "aws_ami" "amazon_linux" {
  count       = var.enabled ? 1 : 0
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_lb" "this" {
  count = var.enabled ? 1 : 0

  name                       = substr("${var.name_prefix}-alb", 0, 32)
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.alb_security_group_id]
  subnets                    = var.public_subnet_ids
  drop_invalid_header_fields = true
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "app" {
  count = var.enabled ? 1 : 0

  name        = substr("${var.name_prefix}-app-tg", 0, 32)
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/health"
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "http" {
  count = var.enabled ? 1 : 0

  load_balancer_arn = aws_lb.this[0].arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app[0].arn
  }
}

resource "aws_instance" "app" {
  count = var.enabled ? 2 : 0

  ami                         = data.aws_ami.amazon_linux[0].id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_ids[count.index]
  vpc_security_group_ids      = [var.app_security_group_id]
  associate_public_ip_address = false
  iam_instance_profile        = var.instance_profile_name
  monitoring                  = true
  ebs_optimized               = true
  user_data_replace_on_change = true
  user_data = <<-USERDATA
    #!/bin/bash
    set -euo pipefail
    dnf install -y docker
    systemctl enable --now docker
    install -d -m 0755 /opt/cloudsec-lab
    cat > /opt/cloudsec-lab/main.py <<'PYTHON'
    from fastapi import FastAPI
    app = FastAPI(docs_url=None, redoc_url=None)
    @app.get("/")
    def root(): return {"application": "CloudSec-Lab", "status": "running"}
    @app.get("/health")
    def health(): return {"status": "healthy"}
    @app.get("/security-info")
    def security_info(): return {"environment": "cloudsec-lab", "architecture": "private-backend", "secrets_in_source": False}
    PYTHON
    cat > /opt/cloudsec-lab/Dockerfile <<'DOCKERFILE'
    FROM python:3.13.7-slim-bookworm
    RUN groupadd --system --gid 10001 cloudsec && useradd --system --uid 10001 --gid cloudsec --no-create-home cloudsec
    WORKDIR /app
    RUN pip install --no-cache-dir fastapi==0.116.1 uvicorn==0.35.0
    COPY --chown=cloudsec:cloudsec main.py .
    USER 10001:10001
    CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--no-server-header"]
    DOCKERFILE
    docker build --tag cloudsec-lab:local /opt/cloudsec-lab
    docker run --detach --restart unless-stopped --name cloudsec-lab --publish 8000:8000 cloudsec-lab:local
  USERDATA
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "disabled"
  }
  root_block_device {
    encrypted             = true
    volume_type           = "gp3"
    volume_size           = 8
    delete_on_termination = true
  }
  tags = { Name = "${var.name_prefix}-app-${count.index + 1}" }
}

resource "aws_lb_target_group_attachment" "app" {
  count = var.enabled ? 2 : 0

  target_group_arn = aws_lb_target_group.app[0].arn
  target_id        = aws_instance.app[count.index].id
  port             = 8000
}
