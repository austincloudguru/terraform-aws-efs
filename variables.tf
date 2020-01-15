#------------------------------------------------------------------------------
# Variables for EFS Module
#------------------------------------------------------------------------------
variable "efs_name" {
  description = "The name of the Elastic File System"
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
