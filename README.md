# AWS EFS Terraform Module
[![Terratest](https://github.com/austincloudguru/terraform-aws-efs/workflows/Terratest/badge.svg?event=push)](https://github.com/austincloudguru/terraform-aws-efs/actions?query=workflow%3ATerratest)
![Latest Version](https://img.shields.io/github/v/tag/austincloudguru/terraform-aws-efs?sort=semver&label=Latest%20Version)
[![License](https://img.shields.io/github/license/austincloudguru/terraform-aws-efs)](https://github.com/austincloudguru/terraform-aws-efs/blob/master/LICENSE)

Terraform module that creates an Elastic File System on AWS along with the mount targets.  It also creates a security group that allows access to 2049 to any instance that has the security group attached to it.  

## Usage

```hcl
module "efs-0" {
  source                 = "AustinCloudGuru/efs/aws"
  # You should pin the module to a specific version
  # version              = "x.x.x"
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_efs_backup_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_backup_policy) | resource |
| [aws_efs_file_system.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.this_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.this_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_policy_status"></a> [backup\_policy\_status](#input\_backup\_policy\_status) | Enable/disable backup for EFS Filesystem.  Value should be ENABLE/DISABLED.  Defaults to DISABLED | `string` | `"DISABLED"` | no |
| <a name="input_encrypted"></a> [encrypted](#input\_encrypted) | If true, the file system will be encrypted | `bool` | `true` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | If set, use a specific KMS key | `string` | `null` | no |
| <a name="input_lifecycle_policy"></a> [lifecycle\_policy](#input\_lifecycle\_policy) | Lifecycle Policy for the EFS Filesystem | <pre>list(object({<br>    transition_to_ia = string<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | A unique name (a maximum of 64 characters are allowed) used as reference when creating the Elastic File System to ensure idempotent file system creation. | `string` | n/a | yes |
| <a name="input_performance_mode"></a> [performance\_mode](#input\_performance\_mode) | The file system performance mode. | `string` | `null` | no |
| <a name="input_provisioned_throughput_in_mibps"></a> [provisioned\_throughput\_in\_mibps](#input\_provisioned\_throughput\_in\_mibps) | The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with throughput\_mode set to provisioned. | `string` | `null` | no |
| <a name="input_security_group_egress"></a> [security\_group\_egress](#input\_security\_group\_egress) | Can be specified multiple times for each egress rule. | <pre>map(object({<br>    description = string<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    self        = bool<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>{<br>  "default": {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Allow All Outbound",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "self": false,<br>    "to_port": 0<br>  }<br>}</pre> | no |
| <a name="input_security_group_ingress"></a> [security\_group\_ingress](#input\_security\_group\_ingress) | Can be specified multiple times for each ingress rule. | <pre>map(object({<br>    description = string<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    self        = bool<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>{<br>  "default": {<br>    "cidr_blocks": null,<br>    "description": "NFS Inbound",<br>    "from_port": 2049,<br>    "protocol": "tcp",<br>    "self": true,<br>    "to_port": 2049<br>  }<br>}</pre> | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs for Mount Targets | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_throughput_mode"></a> [throughput\_mode](#input\_throughput\_mode) | Throughput mode for the file system. | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The name of the VPC that EFS will be deployed to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | EFS ARN |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | EFS DNS name |
| <a name="output_id"></a> [id](#output\_id) | EFS ID |
| <a name="output_mount_target_ids"></a> [mount\_target\_ids](#output\_mount\_target\_ids) | List of EFS mount target IDs (one per Availability Zone) |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | EFS Security Group ARN |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | EFS Security Group ID |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | EFS Security Group name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
