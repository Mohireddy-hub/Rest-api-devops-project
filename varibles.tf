variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "c7i-flex.large"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu"
  type        = string
  default     = "ami-0dee22c13ea7a9a67"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = "rest-api-2"
}

variable "docker_image" {
  description = "Docker image to deploy"
  type        = string
  default     = "mohireddy/api-app:latest"
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 5000
}
