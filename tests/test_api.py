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

def test_loads_as_json(client):
    response = client.get("/courses")
    assert response.status_code == 200
    json_data = json.loads(response.data)
    assert json_data[0]["name"] == "women_in_tech"
    assert json_data[0]["location"] == "Manchester"
    assert json_data[1]["location"] == "London"

def test_add_course(client):
    payload = {
        "name": "test course",
        "location": "Manchester",
        "delivery_method": "In person"
    }
    response = client.post("/courses", json=payload)
    assert response.status_code == 201
    json_data = json.loads(response.data)
    assert json_data["name"] == "test course"
