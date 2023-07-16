# AWS RDS Instance Restoration with Ansible

This README provides the details of an Ansible playbook script that automates the process of restoring an AWS RDS instance from a snapshot.

## Requirements

To run this playbook, you will need:

- Ansible installed on your local machine or whichever machine you are running this script on.
- The AWS SDK (boto3 and botocore) installed.
- An AWS account with the necessary permissions to manage RDS instances and snapshots.
- The Ansible AWS community collections. You can install these with the following command:

  ```bash
  ansible-galaxy collection install community.aws
  ```

## Usage

The Ansible playbook (e.g., `restore_rds.yml`) can be run with the following command:

```bash
ansible-playbook restore_rds.yml
```

Before running the playbook, you need to update the variables section in the playbook:

```yaml
vars:
  region: us-west-2
  db_instance_identifier: aurora-cluster-demo
  snapshot_identifier: my-cluster-final-snapshot
  restored_db_instance_identifier: restored-instance
  db_engine: aurora-postgresql
  db_instance_class: db.r5.large
  db_username: your_username
  db_password: your_password
```

Replace the `your_username` and `your_password` with your actual master username and password for the DB instance.

## What the Script Does

The playbook runs the following tasks:

1. Ensures that a snapshot exists for the specified RDS instance (`community.aws.rds_snapshot` module).
2. Restores a DB instance from the specified snapshot (`community.aws.rds_instance` module).

## AWS Authentication

Be aware of Ansible's AWS authentication. It uses the AWS SDK, so you can use AWS CLI profiles or environment variables. You can find more information in the [Ansible AWS Guide](https://docs.ansible.com/ansible/latest/collections/amazon/aws/docsite/guide_aws.html#ansible-collections-amazon-aws-docsite-aws-intro).

## Disclaimer

Be careful while using this playbook in a production environment as it directly affects your AWS resources. Always test on a small scale or in a testing environment before applying changes at a large scale or in production. 

## Installation details on ubuntu 20,04 LTS
ansible-galaxy collection install community.aws

Starting galaxy collection install process
Process install dependency map
Starting collection install process
Downloading https://galaxy.ansible.com/download/community-aws-6.1.0.tar.gz to /home/adesoji/.ansible/tmp/ansible-local-194785ij4ipwdw/tmpi2yvjoow/community-aws-6.1.0-2akd8l7s
Installing 'community.aws:6.1.0' to '/home/adesoji/.ansible/collections/ansible_collections/community/aws'
Downloading https://galaxy.ansible.com/download/amazon-aws-6.2.0.tar.gz to /home/adesoji/.ansible/tmp/ansible-local-194785ij4ipwdw/tmpi2yvjoow/amazon-aws-6.2.0-qqj5qd3j
community.aws:6.1.0 was installed successfully
Installing 'amazon.aws:6.2.0' to '/home/adesoji/.ansible/collections/ansible_collections/amazon/aws'
amazon.aws:6.2.0 *was installed successfully*