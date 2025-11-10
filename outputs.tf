output "db_cluster_endpoint" {
  description = "The endpoint for the RDS cluster (writer instance)"
  value       = aws_rds_cluster.postgres_cluster.endpoint
}