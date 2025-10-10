# REST API DevOps Project

A simple REST API built with Flask, containerized with Docker, and deployed using GitHub Actions CI/CD and Terraform.

## API Endpoints

- `GET /items` - Retrieve all items
- `POST /items` - Create a new item (requires JSON body with 'name' field)
- `GET /health` - Health check endpoint

## Local Development

### Prerequisites
- Python 3.9+
- Docker
- AWS CLI configured
- Terraform

### Run Locally
```bash
pip install -r requirements.txt
python app.py
```

### Run Tests
```bash
pytest test_app.py -v
```

### Build Docker Image
```bash
docker build -t rest-api .
docker run -p 5000:5000 rest-api
```

## Deployment

### GitHub Actions Setup
1. Add AWS credentials to GitHub Secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`

2. Push to main branch to trigger CI/CD pipeline

### Manual Terraform Deployment
```bash
# Generate SSH key pair
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa

# Deploy infrastructure
terraform init
terraform plan
terraform apply

# Access the API
curl http://<instance-ip>:5000/health
```

### API Usage Examples
```bash
# Get all items
curl http://localhost:5000/items

# Create an item
curl -X POST http://localhost:5000/items \
  -H "Content-Type: application/json" \
  -d '{"name": "Sample Item", "description": "A test item"}'

# Health check
curl http://localhost:5000/health
```

## Architecture

- **Application**: Flask REST API
- **Container**: Docker
- **CI/CD**: GitHub Actions
- **Infrastructure**: AWS EC2 with Terraform
- **Security**: Security groups for port 22 (SSH) and 5000 (API)