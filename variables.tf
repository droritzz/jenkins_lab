variable "region" {
 description = "Default region to use"
 type        = string
 default     = "us-east-1"
}

variable "subnet_zone"{
    description = "Default subnet zone to use"
    type = string
    default = "us-east-1a"
}

variable "machine_type" {
 description = "Machine type to use"
 type        = string
 default     = "t2.micro"
}

variable "cidr_block" {
 description = "cidr block for VPC"
 type        = string
 default     = "172.31.0.0/24"
}

variable "key_name" {
    description = "Key name for AWS"
    type = string
    default = "otomato"
}

variable "ami" {
    description = "instance image"
    type = string
    default = "ami-09e67e426f25ce0d7"
}