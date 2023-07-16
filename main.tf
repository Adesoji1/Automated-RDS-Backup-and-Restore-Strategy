provider "aws" {
  region = "us-west-2"
}

data "aws_caller_identity" "current" {}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

###############################################################################
# Supporting Resources
################################################################################

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

  tags = {
    Name = "My database subnet group"
  }
}

resource "aws_kms_key" "example" {
  description             = "KMS key for RDS cluster"
  deletion_window_in_days = 10
}

###############################################################################
# Master DB
################################################################################

resource "aws_rds_cluster" "example" {
  cluster_identifier                     = "aurora-cluster-demo"
  engine                                 = "aurora-postgresql"
  engine_version                         = var.engine_version
  availability_zones                     = ["us-west-2a", "us-west-2b"]
  database_name                          = "postgres"
  master_username                        = "postgres"
  master_password                        = aws_secretsmanager_secret_version.db_password.secret_string
  backup_retention_period                = 5
  preferred_backup_window                = "07:00-09:00"
  vpc_security_group_ids                 = [aws_security_group.example.id]
  db_subnet_group_name                   = aws_db_subnet_group.example.name
  storage_encrypted                      = true
  kms_key_id                             = aws_kms_key.example.arn
  depends_on                             = [aws_security_group.example, aws_db_subnet_group.example]
  enabled_cloudwatch_logs_exports         = ["postgresql"]
  deletion_protection                    = true
  skip_final_snapshot                    = false
  apply_immediately                      = true
  iam_database_authentication_enabled    = true
  final_snapshot_identifier  = "my-cluster-final-snapshot"
}

resource "aws_rds_cluster_instance" "example" {
  count                = 2
  identifier           = "aurora-cluster-demo-${count.index}"
  cluster_identifier   = aws_rds_cluster.example.id
  instance_class       = "db.r5.large"
  engine               = "aurora-postgresql"
  engine_version       = var.engine_version
  publicly_accessible = false
  auto_minor_version_upgrade = true
  depends_on           = [aws_rds_cluster.example]
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "DB_PASSWORD"
}



resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}

resource "aws_db_snapshot" "example" {
  db_instance_identifier = aws_rds_cluster.example.cluster_identifier
  db_snapshot_identifier = "${aws_rds_cluster.example.cluster_identifier}-snapshot"
  depends_on             = [aws_rds_cluster.example]
}


resource "aws_backup_vault" "example" {
  name = "newhot-backup-demo"
}

resource "aws_backup_plan" "example" {
  name = "automated-backup-plan"

  rule {
    rule_name         = "rds-rule"
    target_vault_name = aws_backup_vault.example.name
    schedule          = "cron(0 12 * * ? *)"
  }
}

resource "aws_backup_selection" "example" {
  name         = "automated-backup-selection"
  iam_role_arn = aws_iam_role.example.arn
  plan_id      = aws_backup_plan.example.id
  resources    = [aws_rds_cluster.example.arn]
}

resource "aws_iam_role" "example" {
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
