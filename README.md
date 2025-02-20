# AWS Private EC2 Access Demo

This project demonstrates two different approaches to securely access private EC2 instances (no public IP address) without bastion.

It includes two independent modules that showcase different architectural patterns:

## Architecture Overview

### PrivateLink Demo
- Fully private architecture with no Internet Gateway
- Uses AWS PrivateLink (VPC Endpoints) for AWS service access
- Instance remain completely isolated from the internet
- VPC CIDR: 10.0.0.0/20

![PrivateLink demo schema](/doc/ssm_session_privatelink.png)

### NAT Gateway Demo
- Private instances internet access
- Uses NAT Gateway for outbound connectivity
- No bastion host required
- VPC CIDR: 172.16.0.0/20

![NAT demo schema](/doc/ssm_session_nat.png)

## Prerequisites
- Appropriate AWS credentials
- IAM permissions to create required resources
- AWS CLI installed with the Session Manager plugin - see [here](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html) for the plugin
- Terraform installed (version 5.0 or higher)


## Getting Started

1. Clone this repository
2. Configure variables in `variables.tf` or create a `terraform.tfvars` file

```bash
deploy_privatelink_demo = true  # Set to false to skip PrivateLink demo
deploy_nat_demo         = true  # Set to false to skip NAT Gateway demo
```

3. Initialize and apply Terraform configuration:
```markdown
terraform init
terraform plan
terraform apply
```

## Module Configuration
### PrivateLink Demo
This module demonstrates how to access EC2 instances using AWS Systems Manager Session Manager through VPC endpoints.

Key components:
- Private subnets
- VPC Endpoints for SSM, EC2 Messages, and SSM Messages
- IAM roles and policies for Systems Manager access

### NAT Gateway Demo
This module shows how to access private EC2 instances using a NAT Gateway for outbound internet access.

Key components:
- Private subnet
- Public subnet (for NAT Gateway)
- NAT Gateway
- Internet Gateway
- Route tables for internet access

| Feature | PrivateLink | NAT Gateway |
|---------|------------|-------------|
| Internet Access | No | Yes (Outbound) |
| Security Level | Highest | High |
| Complexity | Medium | Low |
| Use Case | Strict security requirements | General purpose |

## Accessing the Instances
Use Systems Manager Session Manager
```bash
aws ssm start-session --target <instance-id>
```

## Clean Up
To avoid ongoing charges, remove all resources:

```hcl
terraform destroy
```

## Cost Considerations
This demo includes components that incur AWS charges:
- NAT Gateway
- VPC Endpoints
- EC2 instances