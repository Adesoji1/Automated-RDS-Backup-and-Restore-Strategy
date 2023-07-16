output "rds_cluster_arn" {
  description = "ARN of the RDS cluster"
  value       = aws_rds_cluster.example.arn
}

output "rds_cluster_endpoint" {
  description = "Endpoint of the RDS cluster"
  value       = aws_rds_cluster.example.endpoint
}

output "rds_cluster_reader_endpoint" {
  description = "Reader endpoint of the RDS cluster"
  value       = aws_rds_cluster.example.reader_endpoint
}

output "backup_vault_arn" {
  description = "ARN of the backup vault"
  value       = aws_backup_vault.example.arn
}

output "backup_plan_arn" {
  description = "ARN of the backup plan"
  value       = aws_backup_plan.example.arn
}

output "secret_arn" {
  description = "ARN of the secret storing the RDS master password"
  value       = aws_secretsmanager_secret.db_password.arn
}
