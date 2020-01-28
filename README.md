# AWS EFS Terraform Module
Terraform module that creates an Elastic File System on AWS along with the mount targets.  It also creates a security group that allows access to 2049 to any instance that has the security group attached to it.  

# Terraform versions
Terraform 0.12

## Usage

```hcl
module "efs-0" {
  source        = "AustinCloudGuru/efs/aws"
  version       = "0.2.2"
  vpc_id        = "vpc-0156c7c6959ba5858"
  efs_name      = "dev-efs"
  subnet_ids    = ["subnet-05b1a3ffd786709d5", "subnet-0a35212c972a2af05", "subnet-0d0e78f696428aa28"]
  tags          = {
                    Terraform = "true"
                    Environment = "development"
                  } 
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| vpc_name | The id of the VPC that EFS will be deployed to | string | | yes |
| name | A unique name (a maximum of 64 characters are allowed) used as reference when creating the Elastic File System to ensure idempotent file system creation. | string | | yes |
| security_group_ingress | Can be specified multiple times for each ingress rule. Each ingress block supports fields documented below | list(object) | | no |
| security_group_egress | Can be specified multiple times for each egress rule. Each egress block supports fields documented below | list(object) | | no |
| subnet_filter | Tag name to filter on for the EFS mount targets | string | "private" | no
| tags | A map of tags to add to all resources | map(string) | {} | no

## Outputs

| Name | Description |
|------|-------------|
| arn | EFS ARN |
| id | EFS ID | 
| dns_name | EFS DNS name |
| security_group_id | EFS Security Group ID |
| security_group_arn | EFS Security Group ARN |
| security_group_name | EFS Security Group name |
