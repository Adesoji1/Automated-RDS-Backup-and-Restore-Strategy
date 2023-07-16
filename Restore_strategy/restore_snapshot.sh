#!/bin/bash

# Variables
cluster_identifier="aurora-cluster-demo"
restored_instance_identifier="restored-instance"

# Restore Snapshot
snapshot_identifier="my-cluster-final-snapshot"  # Specify the snapshot identifier
restored_instance_class="db.r5.large"  # Specify the instance class for the restored instance

# Restore the snapshot
echo "Restoring snapshot..."
aws rds restore-db-cluster-from-snapshot \
  --db-cluster-identifier $cluster_identifier \
  --snapshot-identifier $snapshot_identifier \
  --engine aurora-postgresql \
  --engine-version <engine_version> \
  --availability-zones <availability_zones> \
  --db-subnet-group-name main \
  --vpc-security-group-ids <security_group_id> \
  --db-cluster-parameter-group-name <parameter_group_name> \
  --database-name <database_name> \
  --master-username <master_username> \
  --master-user-password <master_password> \
  --no-enable-cloudwatch-logs-export-configuration \
  --iam-database-authentication-enabled \
  --deletion-protection \
  --no-enable-performance-insights \
  --no-enable-http-endpoint \
  --no-copy-tags-to-snapshot

# Modify the restored instance
echo "Modifying restored instance..."
aws rds modify-db-instance \
  --db-instance-identifier $restored_instance_identifier \
  --db-instance-class $restored_instance_class

# Wait for the restoration process to complete
echo "Waiting for restoration to complete..."
aws rds wait db-instance-available \
  --db-instance-identifier $restored_instance_identifier

echo "Snapshot restoration completed successfully."
