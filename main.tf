terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}



resource "aws_security_group" "rest_api_sg" {
  name_prefix = "rest-api-sg"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 5000
    to_port     = 5000
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


resource "aws_instance" "rest_api_server" {
  ami                    = "ami-052064a798f08f0d3"
  instance_type          = "c7i-flex.large"
  key_name              = "rest-api-2"
  vpc_security_group_ids = [aws_security_group.rest_api_sg.id]
  
  user_data = <<-EOF
#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1


apt-get update -y


apt-get install -y docker.io
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu


curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


sleep 10


docker pull mohireddy/api-app:latest
docker run -d -p 5000:5000 --name rest-api --restart unless-stopped mohireddy/api-app:latest


cat > /home/ubuntu/update-app.sh << 'UPDATE_SCRIPT'
#!/bin/bash
echo "Updating application..."
docker pull mohireddy/api-app:latest
docker stop rest-api || true
docker rm rest-api || true
docker run -d -p 5000:5000 --name rest-api --restart unless-stopped mohireddy/api-app:latest
echo "Application updated successfully"
UPDATE_SCRIPT

chmod +x /home/ubuntu/update-app.sh
chown ubuntu:ubuntu /home/ubuntu/update-app.sh


echo "Docker container started at $(date)" > /home/ubuntu/deployment-status.txt
docker ps > /home/ubuntu/docker-status.txt
chown ubuntu:ubuntu /home/ubuntu/*.txt

echo "User data script completed successfully" >> /var/log/user-data.log
EOF
  
  tags = {
    Name = "REST-API-Server-Ubuntu"
  }
}

output "instance_public_ip" {
  value = aws_instance.rest_api_server.public_ip
}

output "api_url" {
  value = "http://${aws_instance.rest_api_server.public_ip}:5000"
}

output "ssh_command" {
  value = "ssh -i rest-api-2.pem ubuntu@${aws_instance.rest_api_server.public_ip}"
}

output "update_command" {
  value = "ssh -i rest-api-2.pem ubuntu@${aws_instance.rest_api_server.public_ip} './update-app.sh'"
}
