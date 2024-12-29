# Variables
variable "region" {
  description = "AWS region to deploy resources"
  default     = "ap-south-1"
}

#VPC
variable "vpc_cidr" {
 type = string
 default = "10.0.0.0/25"
}

variable "vpc_instance_tenancy" {
  type = string
  default = "default"
}

variable "vpc_name" {
  type = string
  default = "OTMicro-Dev-VPC"
}

# Subnet 

variable "availability_zone_1" {
  description = "Primary availability zone"
  default     = "ap-south-1a"
}

variable "availability_zone_2" {
  description = "Secondary availability zone"
  default     = "ap-south-1b"
}

variable "dev_public_subnet_01_cidr" {
  type = string
  description = "CIDR block for dev public subnet 01"
  default     = "10.0.0.0/27"
}

variable "dev_public_subnet_01_Name" {
  type = string
  default = "dev-public-subnet-01"
}

variable "dev_private_frontend_subnet_cidr" {
  type = string
  description = "CIDR block for dev private frontend subnet"
  default     = "10.0.0.64/27"
}

variable "dev_private_frontend_subnet_Name" {
  type = string
  default = "dev-private-frontend-subnet"
}

variable "dev_private_backend_subnet_cidr" {
  type = string
  description = "CIDR block for dev private backend subnet"
  default     = "10.0.0.96/28"
}

variable "dev_private_backend_subnet_Name" {
  type = string
  default = "dev-private-backend-subnet"
}


variable "dev_private_database_subnet_cidr" {
  type = string
  description = "CIDR block for dev private database subnet"
  default     = "10.0.0.112/28"
}

variable "dev_private_database_subnet_Name" {
  type = string
  default = "dev-private-database-subnet"
}

variable "dev_public_subnet_02_cidr" {
  type = string
  description = "CIDR block for dev public subnet 02"
  default     = "10.0.0.32/27"
}

variable "dev_public_subnet_02_Name" {
  type = string
  default = "dev-public-subnet-02"
}

# Internet Gateway

variable "aws_internet_gateway_Name" {
  type = string
  default = "OTMicro-Dev-Internet-Gateway"
}

# Elastic IP for NAT Gateway

variable "aws_eip_domain" {
  type = string
  default = "vpc"
}

variable "aws_eip_name" {
  type = string
  default = "OTMicro-Dev-NAT-EIP"
}

# NAT Gateway

variable "aws_nat_gateway_name" {
  type = string
  default = "OTMicro-Dev-NAT-Gateway"
}

# Public Route Table

variable "aws_public_route_table_cidr_block" {
  type = string
  default = "0.0.0.0/0"
}

variable "aws_public_route_table_name" {
  type = string
  default = "OTMicro-Dev-Public-Route-Table"
}

# Private Route Table

variable "aws_private_route_table_cidr_block" {
  type = string
  default = "0.0.0.0/0"
}

variable "aws_private_route_table_name" {
  type = string
  default = "OTMicro-Dev-Private-Route-Table"
}

#NCAL
# Public NACL for dev-public-subnet-01

variable "aws_public_01_network_acl" {
  type = string
  default = "Public-NACL-01"
}

variable "cidr_block_public" {
  description = "CIDR block for public NACL rules"
  default     = "0.0.0.0/0"
}

variable "private_cidr_block_backend" {
  description = "CIDR block for private backend subnet"
  default     = "10.0.0.112/28"
}

variable "cidr_block_private" {
  description = "CIDR block for private NACL rules"
  default     = "10.0.0.0/27"
}

variable "rule_action" {
  description = "Default rule action for NACL rules"
  default     = "allow"
}

variable "protocol_tcp" {
  description = "Protocol for TCP rules"
  default     = "tcp"
}

variable "protocol_all" {
  description = "Protocol for allowing all traffic"
  default     = "-1"
}

variable "egress_default" {
  description = "Default egress setting for NACL rules"
  default     = false
}

# target group 
variable "OtMicro-TG" {
  type = string
  default = "OT-micro-dev-TG"
}

variable "Port-number-Tg" {
  type = string
  default = "80"
}

variable "protocol_type" {
  type = string
  default = "HTTP"
}

variable "interval" {
  type = string
  default = "30"
}

variable "timeout" {
  type = string
  default = "5"
}

variable "healthy_threshold" {
  type = string
  default = "5"
}

variable "unhealthy_threshold" {
  type = string
  default = "2"
}

variable "path" {
  type = string
  default = "/"
}


# ALB SG

variable "HTTP_port" {
  type = string
  default = "80"
}

variable "sg_cidr_range" {
  type = string
  default = "0.0.0.0/0"
}

variable "allow_port" {
  type = string
  default = "0"
}

variable "protocol_01" {
   type = string
  default = "-1"
}

variable "ALB_SG" {
  type = string
  default = "ALB-SG"
}


# ALB Variable

variable "Load_balancer_name" {
  type = string
  default = "Ot-micro-ALB"
}

variable "internal_value" {
  type = bool
  default = false
}

variable "ALB_type" {
  type = string
  default = "application"
}


# Route 53 hosted zone

variable "domain-name" {
  type = string
  default = "teckwithpratham.click"
}

variable "cname" {
  type = string
  default = "employee-portal.teckwithpratham.click"
}
