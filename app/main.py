"""Minimal API served by the private CloudSec-Lab application tier."""

from fastapi import FastAPI

app = FastAPI(
    title="CloudSec-Lab",
    description="A deliberately small API for a secure AWS infrastructure lab.",
    version="1.0.0",
    docs_url=None,
    redoc_url=None,
)


@app.get("/")
def root() -> dict[str, str]:
    """Return a stable service identity without disclosing runtime data."""
    return {"application": "CloudSec-Lab", "status": "running"}


@app.get("/health")
def health() -> dict[str, str]:
    """Provide the load balancer health-check response."""
    return {"status": "healthy"}


@app.get("/security-info")
def security_info() -> dict[str, str | bool]:
    """Describe harmless design properties only."""
    return {
        "environment": "cloudsec-lab",
        "architecture": "private-backend",
        "secrets_in_source": False,
    }

