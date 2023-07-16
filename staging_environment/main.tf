variable "engine_version" {}
variable "db_password" {}

provider "aws" {
  region = "us-west-2"
}

data "aws_caller_identity" "current" {}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "secondary" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
}

resource "aws_security_group" "example" {
  name        = "example"
  description = "Example security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "example" {
  name       = "main"
  subnet_ids = [aws_subnet.main.id, aws_subnet.secondary.id]
}

resource "aws_kms_key" "example" {
  description             = "KMS key for RDS cluster"
  deletion_window_in_days = 10
}

data "aws_db_snapshot" "latest" {
  most_recent = true
  db_instance_identifier = "aurora-cluster-demo"
}

resource "aws_rds_cluster" "example" {
  cluster_identifier          = "aurora-cluster-demo"
  snapshot_identifier         = data.aws_db_snapshot.latest.id
  engine                      = "aurora-postgresql"
  engine_version              = var.engine_version
  availability_zones          = ["us-west-2a", "us-west-2b"]
  backup_retention_period     = 5
  vpc_security_group_ids      = [aws_security_group.example.id]
  db_subnet_group_name        = aws_db_subnet_group.example.name
  storage_encrypted           = true
  kms_key_id                  = aws_kms_key.example.arn
  enabled_cloudwatch_logs_exports  = ["postgresql"]
  deletion_protection         = true
  apply_immediately           = true
  iam_database_authentication_enabled  = true
  final_snapshot_identifier   = "my-cluster-final-snapshot"
}

resource "aws_rds_cluster_instance" "example" {
  count                = 2
  identifier           = "aurora-cluster-demo-${count.index}"
  cluster_identifier   = aws_rds_cluster.example.id
  instance_class       = "db.r5.large"
  engine               = "aurora-postgresql"
  engine_version       = var.engine_version
  publicly_accessible  = false
  auto_minor_version_upgrade = true
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "DB_PASSWORD"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}

resource "aws_iam_role" "example" { ##Take note: should you receive any error iam role and policy attachments exist, just rename,delete or create a new one.
  name = "backup-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "backup.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "example" {
  role       = aws_iam_role.example.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

