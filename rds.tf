resource "aws_db_subnet_group" "default" {
  name       = "default_postgres_serverless_subnet_group"
  subnet_ids = [
    aws_subnet.pothole_detection_db_subnet_a.id,
    aws_subnet.pothole_detection_db_subnet_b.id
  ]
  description = "A subnet group for the PostgreSQL Serverless v2 RDS instance"
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "rds_postgres_serverless_sg_"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_service_sg.id]
  }
}

resource "aws_rds_cluster" "postgres_cluster" {
  cluster_identifier      = "my-postgres-serverless-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = "13.10"
  master_username         = "admin"
  master_password         = random_password.db_master_password.result
  db_subnet_group_name    = aws_db_subnet_group.default.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  engine_mode = "provisioned"
  
  serverlessv2_scaling_configuration {
    min_capacity = 0
    max_capacity = 2
  }
}

resource "aws_rds_cluster_instance" "postgres_cluster_instance" {
  count                = 1
  identifier           = "my-postgres-serverless-instance-${count.index}"
  engine               = "aurora-postgresql"
  instance_class       = "db.serverless"
  cluster_identifier   = aws_rds_cluster.postgres_cluster.id
  publicly_accessible  = true
}

resource "random_password" "db_master_password" {
  length           = 24
  special          = true
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
}
