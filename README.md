# AWS EFS Terraform Module
Terraform module that creates an Elastic File System on AWS along with the mount targets.  It also creates a security group that allows access to 2049 to any instance that has the security group attached to it.  

## Usage

```hcl
module "efs-0" {
  source                 = "AustinCloudGuru/efs/aws"
  version                = "0.7.0"
  vpc_id                 = "vpc-0156c7c6959ba5858"
  name                   = "dev-efs"
  subnet_ids             = ["subnet-05b1a3ffd786709d5", "subnet-0a35212c972a2af05", "subnet-0d0e78f696428aa28"]
  security_group_ingress = {
                             default = {
                               description = "NFS Inbound"
                               from_port   = 2049
                               protocol    = "tcp"
                               to_port     = 2049
                               self        = true
                               cidr_blocks = []
                             },
                             ssh = {
                               description = "ssh"
                               from_port   = 22
                               protocol    = "tcp"
                               to_port     = 22
                               self        = true
                               cidr_blocks = []
                             }
                           }
  lifecycle_policy = [{
                        "transition_to_ia" = "AFTER_30_DAYS"
                     }]
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
| terraform | >= 0.12.6, < 0.15 |
| aws | >= 2.68, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.68, < 4.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_efs_file_system](https://registry.terraform.io/providers/hashicorp/aws/4.0/docs/resources/efs_file_system) |
| [aws_efs_mount_target](https://registry.terraform.io/providers/hashicorp/aws/4.0/docs/resources/efs_mount_target) |
| [aws_security_group_rule](https://registry.terraform.io/providers/hashicorp/aws/4.0/docs/resources/security_group_rule) |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/4.0/docs/resources/security_group) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| encrypted | If true, the file system will be encrypted | `bool` | `false` | no |
| kms\_key\_id | If set, use a specific KMS key | `string` | `null` | no |
| lifecycle\_policy | Lifecycle Policy for the EFS Filesystem | <pre>list(object({<br>    transition_to_ia = string<br>  }))</pre> | `[]` | no |
| name | A unique name (a maximum of 64 characters are allowed) used as reference when creating the Elastic File System to ensure idempotent file system creation. | `string` | n/a | yes |
| performance\_mode | The file system performance mode. | `string` | `null` | no |
| provisioned\_throughput\_in\_mibps | The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with throughput\_mode set to provisioned. | `string` | `null` | no |
| security\_group\_egress | Can be specified multiple times for each egress rule. | <pre>map(object({<br>    description = string<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    self        = bool<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>{<br>  "default": {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Allow All Outbound",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "self": false,<br>    "to_port": 0<br>  }<br>}</pre> | no |
| security\_group\_ingress | Can be specified multiple times for each ingress rule. | <pre>map(object({<br>    description = string<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    self        = bool<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>{<br>  "default": {<br>    "cidr_blocks": [],<br>    "description": "NFS Inbound",<br>    "from_port": 2049,<br>    "protocol": "tcp",<br>    "self": true,<br>    "to_port": 2049<br>  }<br>}</pre> | no |
| subnet\_ids | Subnet IDs for Mount Targets | `list(string)` | n/a | yes |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| throughput\_mode | Throughput mode for the file system. | `string` | `null` | no |
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
