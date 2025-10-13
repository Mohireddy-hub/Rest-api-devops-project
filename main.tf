terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


# Security Group
resource "aws_security_group" "rest_api_sg" {
  name_prefix = "rest-api-sg"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance - Ubuntu
resource "aws_instance" "rest_api_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name              = var.key_name
  vpc_security_group_ids = [aws_security_group.rest_api_sg.id]
  
  user_data = <<-EOF
#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Update system
apt-get update -y

# Install Docker
apt-get install -y docker.io
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Wait for Docker to be ready
sleep 10

# Pull and run the Docker image from Docker Hub
docker pull ${var.docker_image}
docker run -d -p ${var.app_port}:${var.app_port} --name rest-api --restart unless-stopped ${var.docker_image}

# Create deployment script for CI/CD updates
cat > /home/ubuntu/update-app.sh << 'UPDATE_SCRIPT'
#!/bin/bash
echo "Updating application..."
docker pull ${var.docker_image}
docker stop rest-api || true
docker rm rest-api || true
docker run -d -p ${var.app_port}:${var.app_port} --name rest-api --restart unless-stopped ${var.docker_image}
echo "Application updated successfully"
UPDATE_SCRIPT

chmod +x /home/ubuntu/update-app.sh
chown ubuntu:ubuntu /home/ubuntu/update-app.sh

# Create status files
echo "Docker container started at $(date)" > /home/ubuntu/deployment-status.txt
docker ps > /home/ubuntu/docker-status.txt
chown ubuntu:ubuntu /home/ubuntu/*.txt

echo "User data script completed successfully" >> /var/log/user-data.log
EOF
  
  tags = {
    Name = "REST-API-Server-Ubuntu"
  }
}

