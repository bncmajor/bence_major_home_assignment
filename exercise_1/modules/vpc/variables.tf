variable "region" {
    description = "AWS region for the VPC. Defaults to us-east-1"
    type = string
    default = "us-east-1"
}

variable "vpc_cidr_block" {
    description = "VPC CIDR block"
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnets" {
    description = "Map of Public Subnets with subnet CIDR blocks and AZs"
    type = map(object({
        cidr_block        = string
    }))
    default = {
      "a" = {cidr_block = "10.0.0.0/24"}
      "b" = {cidr_block = "10.0.1.0/24"}
    }
}

variable "private_subnets" {
    description = "Map of Private Subnets with subnet CIDR blocks and AZs"
    type = map(object({
        cidr_block        = string
    }))
    default = {
      "a" = {cidr_block = "10.0.2.0/24"}
      "b" = {cidr_block = "10.0.3.0/24"}
    }
}