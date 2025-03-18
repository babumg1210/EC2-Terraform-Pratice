variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "subnet_details" {
  description = "A map of subnet details with CIDR blocks, public/private status, and availability zones"
  type = map(object({
    cidr   = string
    public = bool
    az     = string
  }))
}

variable "services_map" {
  description = "A map of services with configurations"
  type = map(object({
    instance_count = number
    instance_type  = string
    memory         = string
    vcpu           = number
    storage        = string
    #subnet_id         = string
    #security_group_ids = list(string)
  }))
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "affiliate-service"
  }
}