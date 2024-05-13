data "aws_efs_file_system" "this" {
  file_system_id = var.file_system_id
}

variable "file_system_id" {
  type        = string
  description = "ID that identifies the file system"
}
