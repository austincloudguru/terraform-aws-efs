#------------------------------------------------------------------------------
# Variables for EFS Module
#------------------------------------------------------------------------------
variable "security_group_ingress" {
  description = "Can be specified multiple times for each ingress rule. "
  type = map(object({
    description = string
    from_port   = number
    protocol    = string
    to_port     = number
    self        = bool
    cidr_blocks = list(string)
  }))
  default = {
    default = {
      description = "NFS Inbound"
      from_port   = 2049
      protocol    = "tcp"
      to_port     = 2049
      self        = true
      cidr_blocks = null
    }
  }
}

variable "security_group_egress" {
  description = "Can be specified multiple times for each egress rule. "
  type = map(object({
    description = string
    from_port   = number
    protocol    = string
    to_port     = number
    self        = bool
    cidr_blocks = list(string)
  }))
  default = {
    default = {
      description = "Allow All Outbound"
      from_port   = 0
      protocol    = "-1"
      to_port     = 0
      self        = false
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

variable "name" {
  description = "A unique name (a maximum of 64 characters are allowed) used as reference when creating the Elastic File System to ensure idempotent file system creation."
  type        = string
}

variable "vpc_id" {
  description = "The name of the VPC that EFS will be deployed to"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for Mount Targets"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "encrypted" {
  description = "If true, the file system will be encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "If set, use a specific KMS key"
  type        = string
  default     = null
}

variable "lifecycle_policy" {
  description = "Lifecycle Policy for the EFS Filesystem"
  type = list(object({
    transition_to_ia = string
  }))
  default = []
}

variable "performance_mode" {
  description = "The file system performance mode."
  type        = string
  default     = null
}

variable "throughput_mode" {
  description = "Throughput mode for the file system."
  type        = string
  default     = null
}

variable "provisioned_throughput_in_mibps" {
  description = "The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with throughput_mode set to provisioned."
  type        = string
  default     = null
}

variable "backup_policy_status" {
  description = "Enable/disable backup for EFS Filesystem.  Value should be ENABLE/DISABLED.  Defaults to DISABLED"
  type        = string
  default     = "DISABLED"
  validation {
    condition     = var.backup_policy_status == "ENABLED" || var.backup_policy_status == "DISABLED"
    error_message = "Sorry, value must be either 'ENABLED' or 'DISABLED'."
  }
}
