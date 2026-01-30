# Exercise 1: AWS VPC Infrastructure

This Terraform configuration sets up a basic AWS network infrastructure consisting of a Virtual Private Cloud (VPC) with public and private subnets, routing, and security groups.

## Infrastructure Components

- **VPC:** Created with a customizable CIDR block (default: `10.0.0.0/16`).
- **Subnets:**
  - **Public Subnets:** 2 subnets (default) with direct Internet access via an Internet Gateway.
  - **Private Subnets:** 2 subnets (default) for internal workloads.
- **Gateways & Routing:**
  - **Internet Gateway (IGW):** Attached to the VPC for public subnet connectivity.
  - **NAT Gateways:** Provisioned for each private subnet to allow outbound internet access. Each NAT Gateway is allocated a dedicated Elastic IP (EIP).
  - **Route Tables:**
    - Public Route Table: Routes `0.0.0.0/0` to the IGW.
    - Private Route Tables: Route `0.0.0.0/0` to the respective NAT Gateway.
  - **VPC Endpoint:** Gateway Endpoint for S3 associated with private route tables.
- **Security Groups:**
  - **Load Balancer SG (`load_balancer_sg`):** Allows inbound traffic on ports 80 (HTTP) and 443 (HTTPS) from anywhere.
  - **App Server SG (`app_server_sg`):** Allows inbound traffic on port 80 only from the Load Balancer Security Group.

## Usage

### Prerequisites
- Terraform installed (v1.x recommended)
- AWS Credentials configured

### Inputs (Variables)

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `region` | AWS Region | string | `us-east-1` |
| `vpc_cidr_block` | CIDR block for the VPC | string | `10.0.0.0/16` |
| `public_subnets` | Map of public subnets with CIDR blocks | map | (See `variables.tf`) |
| `private_subnets` | Map of private subnets with CIDR blocks | map | (See `variables.tf`) |

### Deployment

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the plan:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

## Modules

- **vpc:** The core networking logic is encapsulated in the `./modules/vpc` local module.
