# AWS EFS Terraform Module
Terraform module that creates an Elastic File System on AWS along with the mount targets.  It also creates a security group that allows access to 2049 to any instance that has the security group attached to it.  

## Usage

```hcl
module "efs-0" {
  source        = "AustinCloudGuru/efs/aws"
  version       = "0.4.0"
  vpc_id        = "vpc-0156c7c6959ba5858"
  efs_name      = "dev-efs"
  subnet_ids    = ["subnet-05b1a3ffd786709d5", "subnet-0a35212c972a2af05", "subnet-0d0e78f696428aa28"]
  tags          = {
                    Terraform = "true"
                    Environment = "development"
                  } 
}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6, < 0.14 |
| aws | >= 2.68, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.68, < 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | A unique name (a maximum of 64 characters are allowed) used as reference when creating the Elastic File System to ensure idempotent file system creation. | `string` | n/a | yes |
| security\_group\_egress | Can be specified multiple times for each egress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    self        = bool<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "self": false,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| security\_group\_ingress | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    self        = bool<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [],<br>    "from_port": 2049,<br>    "protocol": "tcp",<br>    "self": true,<br>    "to_port": 2049<br>  }<br>]</pre> | no |
| subnet\_ids | Subnet IDs for Mount Targets | `list(string)` | n/a | yes |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| vpc\_id | The name of the VPC that EFS will be deployed to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | EFS ARN |
| dns\_name | EFS DNS name |
| id | EFS ID |
| mount\_target\_ids | List of EFS mount target IDs (one per Availability Zone) |
| security\_group\_arn | EFS Security Group ARN |
| security\_group\_id | EFS Security Group ID |
| security\_group\_name | EFS Security Group name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
