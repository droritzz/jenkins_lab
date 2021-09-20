variable "region" {
 description = "Default region to use"
 type        = string
 default     = "us-east-1"
}

variable "machine_type" {
 description = "Machine type to use"
 type        = string
 default     = "t2.micro"
}

variable "cidr_block" {
 description = "Cidr block for VPC"
 type        = string
 default     = "172.31.0.0/24"
}
