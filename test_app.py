import pytest
import json
from app import app

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_get_items_empty(client):
    response = client.get('/items')
    assert response.status_code == 200
    assert json.loads(response.data) == []

def test_create_item(client):
    response = client.post('/items', 
                          data=json.dumps({'name': 'Test Item', 'description': 'Test Description'}),
                          content_type='application/json')
    assert response.status_code == 201
    data = json.loads(response.data)
    assert data['name'] == 'Test Item'
    assert data['id'] == 1

def test_health_check(client):
    response = client.get('/health')
    assert response.status_code == 200
    assert json.loads(response.data)['status'] == 'healthy'
