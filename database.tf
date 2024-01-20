# Database Subnet Group
resource "aws_db_subnet_group" "database_subnet_group" {
  name       = "database-subnet-group"
  subnet_ids = [aws_subnet.private-db-az1.id, aws_subnet.private-db-az2.id]
  tags = {
    Name        = "Database-Subnet-Group"
    Environment = "dev"
  }
}

# Aurora Mysql RDS With Read Replica
resource "aws_rds_cluster" "cluster" {
  engine             = "aurora-mysql"
  engine_mode        = "provisioned"
  engine_version     = "8.0"
  cluster_identifier = "aurora-database"
  master_username    = "admin"
  master_password    = "admin123"
  database_name      = "webappdb"

  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = [aws_security_group.database-sg.id]

  backup_retention_period = 1
  skip_final_snapshot     = true
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  identifier          = "database-1"
  count               = 1
  cluster_identifier  = aws_rds_cluster.cluster.id
  instance_class      = "db.t3.medium"
  engine              = aws_rds_cluster.cluster.engine
  engine_version      = aws_rds_cluster.cluster.engine_version
  publicly_accessible = false
}

resource "aws_rds_cluster_instance" "read_replica_instance" {
  identifier          = "database-read-replica-1"
  count               = 1
  cluster_identifier  = aws_rds_cluster.cluster.id
  instance_class      = "db.t3.medium" # Adjust as needed
  engine              = aws_rds_cluster.cluster.engine
  engine_version      = aws_rds_cluster.cluster.engine_version
  publicly_accessible = false
}