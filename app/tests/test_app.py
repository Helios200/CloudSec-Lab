"""API contract tests."""

from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_root() -> None:
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"application": "CloudSec-Lab", "status": "running"}


def test_health() -> None:
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}


def test_security_info_discloses_only_expected_fields() -> None:
    response = client.get("/security-info")
    assert response.status_code == 200
    assert response.json() == {
        "environment": "cloudsec-lab",
        "architecture": "private-backend",
        "secrets_in_source": False,
    }


def test_documentation_endpoints_are_disabled() -> None:
    assert client.get("/docs").status_code == 404
    assert client.get("/redoc").status_code == 404
