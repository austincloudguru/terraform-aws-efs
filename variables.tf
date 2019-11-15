#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------
variable "vpc_name" {
  description = "The name of the VPC that EFS will be deployed to"
  type        = string
}

variable "efs_name" {
  description = "The name of the Elastic File System"
  type        = "string"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "subnet_filter" {
  description = "Tag name to filter on for the EFS mount targets"
  type        = string
}