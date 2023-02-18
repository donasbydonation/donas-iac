output "AWS_RDS_HOST" {
  value = module.rds.db_instance_address
}

output "AWS_ASG_NAME" {
  value = module.asg.autoscaling_group_name
}
