import boto3

def restore_db_from_snapshot():
    rds = boto3.client('rds', region_name='us-west-2')

    try:
        response = rds.restore_db_cluster_from_snapshot(
            DBClusterIdentifier='<cluster_id>',
            SnapshotIdentifier='<snapshot_id>',
            Engine='aurora-postgresql',
            EngineVersion='14.6',
            DBSubnetGroupName='<subnet_group_name>',
            VpcSecurityGroupIds=[
                '<security_group_id>',
            ],
            Tags=[
                {
                    'Key': 'Name',
                    'Value': 'RestoredDBInstance'
                },
            ],
            DatabaseName='myDatabase',
            MasterUsername='myUsername',
            MasterUserPassword='myPassword',
            OptionGroupName='<option_group_name>',
            VpcSecurityGroupIds=[
                '<security_group_id>',
            ],
            DBClusterParameterGroupName='<parameter_group_name>',
            EnableIAMDatabaseAuthentication=True
        )
        print('Restoring snapshot finished')
    except Exception as error:
        print('An error occurred while restoring snapshot:')
        print(str(error))

restore_db_from_snapshot()
