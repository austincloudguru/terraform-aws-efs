#------------------------------------------------------------------------------
# Collect necessary data
#------------------------------------------------------------------------------
data "aws_caller_identity" "current" {}

data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet_ids" "this" {
  vpc_id = data.aws_vpc.this.id
  filter {
    name   = "tag:Name"
    values = ["*${var.subnet_filter}*"]
  }
}

#------------------------------------------------------------------------------
# Create EFS
#------------------------------------------------------------------------------

resource "aws_security_group" "this" {
  name        = var.efs_name
  description = "Allows for NFS traffic for ${var.efs_name}"
  vpc_id      = data.aws_vpc.this.id
  ingress {
    from_port = 2049
    protocol  = "tcp"
    to_port   = 2049
    self      = true
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  tags = merge(
    {
      "Name" = var.efs_name
    },
    var.tags
  )
}

resource "aws_efs_file_system" "this" {
  creation_token = var.efs_name

  tags = merge(
    {
      "Name" = var.efs_name
    },
    var.tags
  )
}

resource "aws_efs_mount_target" "this" {
  count          = length(data.aws_subnet_ids.this) > 0 ? length(data.aws_subnet_ids.this) : 0
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = data.aws_subnet_ids.this.ids[count.index]
  security_groups = [
    aws_security_group.this.id
  ]
}