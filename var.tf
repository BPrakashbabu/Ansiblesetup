variable "aws_region" {
  description = "AWS region"
  type        = string
  default = "ap-south-1"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default = "ami-019715e0d74f695be"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default = "t3.micro"
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 3
}

variable "instance_name" {
  description = "Name tag for instances"
  type        = string
  default = "my_new+instance"
}

variable "ppkfile"{
  type = string
  default = "docker"
}

