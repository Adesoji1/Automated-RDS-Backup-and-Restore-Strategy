#### To run the restore_snapshopt.sh script, follow these steps:

1. Save the script in a file with a `.sh` extension, for example, `restore_snapshot.sh`

2. Open a terminal or command prompt and navigate to the directory where you saved the script.

3. Make the script executable by running the following command:

   ```bash
   chmod +x restore_snapshot.sh
   ```

4. Set the necessary environment variables or replace the placeholders in the script with the actual values specific to your environment.

5. Run the script by executing the following command:

   ```bash
   ./restore_snapshot.sh
   ```

   This will start the snapshot restoration process and modify the restored instance as specified in the script.

6. Wait for the script to complete. It will provide feedback and notify you when the restoration process is finished.

Make sure you have the AWS CLI installed and configured with appropriate AWS credentials before running the script.

In the provided script in restore_snapshot.sh, the `restored_instance_identifier` variable is set to `restored-instance`. This identifier is used to specify the name of the restored RDS instance.

By default, the script does not create a new RDS instance. Instead, it assumes that you have an existing snapshot that you want to restore. The script uses the `aws rds restore-db-instance-from-db-snapshot` command to restore the RDS instance from the specified snapshot.

To locate the appropriate snapshot and its corresponding instance identifier, you can use the AWS Management Console, AWS CLI, or AWS SDKs. Here are a few ways to find the instance identifier:

1. AWS Management Console: Go to the Amazon RDS service in the AWS Management Console, navigate to "Snapshots," and search for the snapshot you want to restore. The snapshot's details should include the original instance identifier.

2. AWS CLI: Use the `aws rds describe-db-snapshots` command to list all available snapshots and their details, including the instance identifier. You can filter the output using flags like `--snapshot-identifier` or `--db-instance-identifier` to narrow down the results.

   Example command:
   ```bash
   aws rds describe-db-snapshots --snapshot-identifier your-snapshot-identifier
   ```

   Replace `your-snapshot-identifier` with the actual identifier of the snapshot you want to restore.

3. AWS SDKs: Utilize AWS SDKs in your preferred programming language to programmatically retrieve the details of the snapshot, including the instance identifier.

   Once you have identified the appropriate snapshot and its instance identifier, you can update the `restore_snapshot.sh` script by replacing the `restored_instance_identifier` variable value with the actual instance identifier of the restored RDS instance.

To retrieve specific information about an RDS instance using the AWS CLI, you can use the `aws rds describe-db-instances` command along with filtering options to narrow down the output. However, please note that the `master_password` field is not retrievable directly due to security reasons. The AWS CLI only provides access to a limited set of information.

Here's an example command to retrieve the information you mentioned using AWS CLI:

```bash
aws rds describe-db-instances --db-instance-identifier your-db-instance-identifier --query 'DBInstances[0].[EngineVersion, AvailabilityZones, VpcSecurityGroups[0].VpcSecurityGroupId, DBParameterGroups[0].DBParameterGroupName, DBName, MasterUsername]' --output text
```

Replace `your-db-instance-identifier` with the actual identifier of your RDS instance.

The command uses the `--query` option to specify a JMESPath query expression to filter the output. The expression `DBInstances[0].[EngineVersion, AvailabilityZones, VpcSecurityGroups[0].VpcSecurityGroupId, DBParameterGroups[0].DBParameterGroupName, DBName, MasterUsername]` selects the desired fields for the first DB instance returned by the describe command.

Note that the `master_password` field is not included in the query since it is not retrievable via the AWS CLI.

After executing the command, you will receive the values for `<engine_version>`, `<availability_zones>`, `<security_group_id>`, `<parameter_group_name>`, `<database_name>`, and `<master_username>` from the RDS instance.


#### Reference sensitive Information below

To reference sensitive information using variables in the script, you can pass the values as environment variables or through command-line arguments. Here's an example of how you can modify the script to reference sensitive information using variables:

```bash
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
  --engine-version $ENGINE_VERSION \
  --availability-zones $AVAILABILITY_ZONES \
  --db-subnet-group-name main \
  --vpc-security-group-ids $SECURITY_GROUP_ID \
  --db-cluster-parameter-group-name $PARAMETER_GROUP_NAME \
  --database-name $DATABASE_NAME \
  --master-username $MASTER_USERNAME \
  --master-user-password $MASTER_PASSWORD \
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
```
```

To add a copy icon indicator, you can use HTML and CSS. Here's an example of how you can do it:

```markdown
```bash
<div class="copy-button">
  <button class="copy-button-icon" onclick="copyToClipboard('bash-script')">Copy</button>
  <pre><code id="bash-script">
#!/bin/bash

# Your script content goes here
# ...

  </code></pre>
</div>

<script>
function copyToClipboard(elementId) {
  const copyText = document.getElementById(elementId).innerText;
  const textarea = document.createElement('textarea');
  textarea.value = copyText;
  document.body.appendChild(textarea);
  textarea.select();
  document.execCommand('copy');
  textarea.remove();
  alert('Script copied to clipboard');
}
</script>
```

In this example above, the sensitive values such as ENGINE_VERSION, AVAILABILITY_ZONES, SECURITY_GROUP_ID, PARAMETER_GROUP_NAME, DATABASE_NAME, MASTER_USERNAME, and MASTER_PASSWORD are not hardcoded in the script. Instead, you can pass them as environment variables or as command-line arguments when executing the script.

For example, you can set environment variables before running the script:

```bash
export ENGINE_VERSION="9.6.20"
export AVAILABILITY_ZONES="us-west-2a,us-west-2b"
export SECURITY_GROUP_ID="sg-xxxxxxxx"
export PARAMETER_GROUP_NAME="aurora-postgresql-9-6"
export DATABASE_NAME="mydatabase"
export MASTER_USERNAME="myusername"
export MASTER_PASSWORD="mypassword"

bash restore_snapshot.sh
```

