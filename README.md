# REST API DevOps Project

A complete DevOps implementation of a Flask REST API with containerization, CI/CD pipeline, and infrastructure as code. This project demonstrates modern DevOps practices including automated testing, containerization, continuous deployment, and cloud infrastructure management.

## Project Overview

This project showcases a full DevOps lifecycle:
- **Application**: Simple Flask REST API for item management
- **Containerization**: Docker for consistent deployment
- **CI/CD**: GitHub Actions for automated testing and deployment
- **Infrastructure**: Terraform for AWS resource management
- **Monitoring**: Health check endpoints for application monitoring

## API Endpoints

- `GET /items` - Retrieve all items
- `POST /additems` - Create a new item (requires JSON body with 'name' field)
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

### Development Environment
#### GitHub Actions Setup
1. Add AWS credentials to GitHub Secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`

2. Push to main branch to trigger CI/CD pipeline

#### Manual Terraform Deployment

# Deploy infrastructure
terraform init
terraform plan
terraform apply

# Access the API
curl http://<instance-ip>:5000/health
```

### Production Environment
#### AWS ECS Fargate (Recommended for Production)
For production workloads, consider using AWS ECS Fargate for:
- **Serverless containers**: No EC2 instance management
- **Auto-scaling**: Automatic scaling based on demand
- **High availability**: Multi-AZ deployment
- **Cost optimization**: Pay only for resources used
- **Security**: Enhanced isolation and security

```bash
# Deploy with ECS Fargate
terraform workspace new production
terraform apply -var="deployment_type=fargate"
```

### API Usage Examples
```bash
# Get all items
curl http://localhost:5000/items

# Create an item
curl -X POST http://localhost:5000/additems \
  -H "Content-Type: application/json" \
  -d '{"name": "Sample Item", "description": "A test item"}'

# Health check
curl http://localhost:5000/health
```

## Architecture

### Development Architecture
- **Application**: Flask REST API with in-memory storage
- **Container**: Docker for consistent deployment
- **CI/CD**: GitHub Actions with automated testing
- **Infrastructure**: AWS EC2 with Terraform
- **Security**: Security groups for SSH (22) and API (5000)

### Production Architecture (ECS Fargate)
- **Compute**: AWS ECS Fargate for serverless containers
- **Load Balancing**: Application Load Balancer
- **Database**: Amazon RDS for persistent storage
- **Monitoring**: CloudWatch for logging and metrics
- **Security**: VPC, private subnets, and IAM roles

## Project Structure
```
Rest_api-project-devops/
├── app.py              # Flask application
├── requirements.txt    # Python dependencies
├── Dockerfile         # Container configuration
├── test_app.py        # Unit tests
├── main.tf           # Terraform main configuration
├── variables.tf      # Terraform variables
├── outputs.tf        # Terraform outputs
├── .github/workflows/ # CI/CD pipeline
└── README.md         # Project documentation
```

## Features

- **RESTful API**: Clean REST endpoints for item management
- **Containerized**: Docker for consistent deployment across environments
- **Automated Testing**: Unit tests with pytest
- **CI/CD Pipeline**: Automated build, test, and deployment
- **Infrastructure as Code**: Terraform for reproducible infrastructure
- **Health Monitoring**: Built-in health check endpoint
- **Production Ready**: ECS Fargate option for scalable production deployment

