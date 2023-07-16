output "rds_cluster_arn" {
  description = "The Amazon Resource Name of the RDS Cluster"
  value       = aws_rds_cluster.example.arn
}

output "rds_cluster_endpoint" {
  description = "The DNS address of the RDS instance"
  value       = aws_rds_cluster.example.endpoint
}

output "rds_cluster_master_username" {
  description = "The master username for the RDS instance"
  value       = aws_rds_cluster.example.master_username
}

output "rds_cluster_database_name" {
  description = "The database name of the RDS instance"
  value       = aws_rds_cluster.example.database_name
}