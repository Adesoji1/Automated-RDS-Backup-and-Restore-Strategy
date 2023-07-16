output "aws_vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "aws_subnet_ids" {
  description = "The IDs of the Subnets"
  value       = [aws_subnet.main.id, aws_subnet.secondary.id]
}

output "aws_security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.example.id
}

output "aws_db_subnet_group_name" {
  description = "The name of the database subnet group"
  value       = aws_db_subnet_group.example.name
}

output "aws_rds_cluster_id" {
  description = "The ID of the RDS Cluster"
  value       = aws_rds_cluster.example.id
}

output "aws_rds_cluster_instances" {
  description = "The identifiers of the RDS Cluster instances"
  value       = aws_rds_cluster_instance.example[*].id
}

output "aws_rds_cluster_endpoint" {
  description = "The connection endpoint for the RDS Cluster"
  value       = aws_rds_cluster.example.endpoint
}

output "aws_db_snapshot_id" {
  description = "The ID of the RDS DB Snapshot"
  value       = aws_db_snapshot.example.id
}

output "aws_backup_vault_arn" {
  description = "The ARN of the backup vault"
  value       = aws_backup_vault.example.arn
}

output "aws_backup_plan_id" {
  description = "The ID of the backup plan"
  value       = aws_backup_plan.example.id
}

output "aws_backup_selection_id" {
  description = "The ID of the backup selection"
  value       = aws_backup_selection.example.id
}

output "aws_iam_role_arn" {
  description = "The ARN of the IAM role for the backup service"
  value       = aws_iam_role.example.arn
}


output "db_password_secret_arn" {
  description = "The ARN of the secret holding DB password"
  value       = aws_secretsmanager_secret.db_password.arn
}


output "iam_role_name" {
  description = "The name of the IAM role used for backups"
  value       = aws_iam_role.example.name
}
