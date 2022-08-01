#------------------------------------------------------------------------------
# Create EFS
#------------------------------------------------------------------------------

resource "aws_security_group" "this" {
  name        = var.name
  description = "EFS Security Group for ${var.name}"
  vpc_id      = var.vpc_id
  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_security_group_rule" "this_ingress" {
  for_each          = var.security_group_ingress
  security_group_id = aws_security_group.this.id
  type              = "ingress"
  description       = lookup(each.value, "description", null)
  from_port         = lookup(each.value, "from_port", null)
  protocol          = lookup(each.value, "protocol", null)
  to_port           = lookup(each.value, "to_port", null)
  self              = lookup(each.value, "self", null) == false ? null : each.value.self
  cidr_blocks       = lookup(each.value, "cidr_blocks", null)
}

resource "aws_security_group_rule" "this_egress" {
  for_each          = var.security_group_egress
  security_group_id = aws_security_group.this.id
  type              = "egress"
  description       = lookup(each.value, "description", null)
  from_port         = lookup(each.value, "from_port", null)
  protocol          = lookup(each.value, "protocol", null)
  to_port           = lookup(each.value, "to_port", null)
  self              = lookup(each.value, "self", null) == false ? null : each.value.self
  cidr_blocks       = lookup(each.value, "cidr_blocks", null)
}

resource "aws_efs_file_system" "this" {
  creation_token                  = var.name
  encrypted                       = var.encrypted
  kms_key_id                      = var.kms_key_id
  performance_mode                = var.performance_mode
  throughput_mode                 = var.throughput_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps

  dynamic "lifecycle_policy" {
    for_each = var.lifecycle_policy
    content {
      transition_to_ia = lookup(lifecycle_policy.value, "transition_to_ia", null)
    }
  }

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_efs_mount_target" "this" {
  count          = length(var.subnet_ids) > 0 ? length(var.subnet_ids) : 0
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = var.subnet_ids[count.index]
  security_groups = [
    aws_security_group.this.id
  ]
}

resource "aws_efs_backup_policy" "this" {
  file_system_id = aws_efs_file_system.this.id

  backup_policy {
    status = var.backup_policy_status
  }
}
