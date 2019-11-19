# AWS EFS Terraform Module
Terraform module that creates an Elastic File System on AWS along with the mount targets.  It also creates a security group that allows access to 2049 to any instance that has the security group attached to it.  

# Terraform versions
Terraform 0.12

## Usage

```hcl
module "efs-0" {
  source        = "AustinCloudGuru/efs/aws"
  version       = "0.2.2"
  vpc_id        = "development"
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
| vpc_name | The name of the VPC that EFS will be deployed to | string | | yes |
| efs_name | The name of the Elastic File System | string | | yes |
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