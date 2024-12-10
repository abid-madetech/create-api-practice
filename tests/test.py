import pytest
import json
from app import app

@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client

def test_request_example(client):
    response = client.get("/")
    assert response.status_code == 200

def test_test(client):
    response = client.get("/courses")
    assert response.status_code == 200
    json_data = json.loads(response.data)
    assert json_data["women_in_tech"]["location"] == "Manchester"

