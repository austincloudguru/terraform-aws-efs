output "efs_arn" {
  value = module.efs.arn
}

output "efs_id" {
  value = module.efs.id
}

output "efs_dns_name" {
  value = module.efs.dns_name
}

output "efs_mount_target_ids" {
  value = module.efs.mount_target_ids
}

output "sg_arn" {
  value = module.efs.security_group_arn
}

output "sg_id" {
  value = module.efs.security_group_id
}

output "sg_name" {
  value = module.efs.security_group_name
}
