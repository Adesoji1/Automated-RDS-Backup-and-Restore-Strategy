provider "aws" {
  region     = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "secondary" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
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
}

resource "aws_rds_cluster" "example" {
  cluster_identifier      = "aurora-cluster-demo"
  engine                  = "aurora-postgresql"
  engine_version          = "13.7"
  availability_zones      = ["us-west-2a", "us-west-2b"]
  database_name           = "postgres"
  master_username         = "postgres"
  master_password         = aws_secretsmanager_secret_version.db_password.secret_string 
  preferred_backup_window = "07:00-09:00"
  vpc_security_group_ids  = [aws_security_group.example.id]
  db_subnet_group_name    = aws_db_subnet_group.example.name
}

resource "aws_db_subnet_group" "example" {
  name       = "main"
  subnet_ids = [aws_subnet.main.id, aws_subnet.secondary.id]

  tags = {
    Name = "My database subnet group"
  }
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "aurora-cluster-demo-${count.index}"
  cluster_identifier = aws_rds_cluster.example.id
  instance_class     = "db.r4.large"
  engine             = "aurora-postgresql"
  engine_version     = "13.7"
  publicly_accessible = false
}

resource "aws_secretsmanager_secret" "db_password" {
  name        = "DB_PASSWORD"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}

resource "aws_backup_vault" "example" {
  name = "my-backup-vault"
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
