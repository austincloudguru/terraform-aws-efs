# AWS EFS Terraform Module
Terraform module that creates an Elastic File System on AWS.

# Terraform versions
Terraform 0.12

## Usage

```hcl
module "efs" {
  source        = "github.com/austincloudguru/terraform-aws-efs"
  vpc_name      = "development"
  efs_name      = "dev-efs"
  subnet_filter = "private"
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
| subnet_filter | Tag name to filter on for the EFS mount targets | string | "private" | yes
| tags | A map of tags to add to all resources | map(string) | {} | no

## Outputs

| Name | Description |
|------|-------------|
| arn | EFS ARN |
| dns_name | EFS DNS name |
| security_group_id | EFS Security Group ID |
| security_group_arn | EFS Security Group ARN |
| security_group_name | EFS Security Group name |