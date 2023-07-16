#### This section contains installation instructions for both restore_stratgy.py and execute_s3_script.sh located at Restore_strategy/ 

#### Instructions for restore_strategy.py script

In this restore_strategy.py script, we first create a client to interact with AWS RDS using the boto3 library. Then, we call the restore_db_cluster_from_snapshot method to create a new RDS DB instance from a DB snapshot.

Before you can run this script, make sure you have python installed and make sure you have installed the boto3 package by running the command pip install boto3 in your terminal.

Also, you need to configure your AWS credentials either by setting AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and AWS_SESSION_TOKEN environment variables, or by using the AWS CLI's aws configure command. 

These credentials will be used to authenticate your requests to AWS.


You can run the script in any environment where Python and boto3 are installed, such as a local development environment on your machine, a server, or even a cloud-based environment like AWS Lambda.

To schedule the script to run automatically, you have a couple of options:

1. **Cron Jobs (Linux/macOS)**: If you are using a Linux or macOS machine, you can use cron jobs to schedule tasks. Open your terminal and type `crontab -e` to edit the crontab file. Add a line like this to run the script every day at 2AM:

```cron
0 2 * * * /usr/bin/python3 /path/to/your/script.py
```

Make sure to replace `/usr/bin/python3` with the actual path to your Python interpreter (you can get it by running `which python3`), and `/path/to/your/script.py` with the path to your Python script.

2. **Task Scheduler (Windows)**: If you are using a Windows machine, you can use the Task Scheduler. You can create a new basic task, and set the trigger to daily and the action to start a program. The program/script would be the path to your Python interpreter, and the argument would be the path to your script.

3. **AWS CloudWatch Events (AWS)**: If you are using AWS, you can run your script as a Lambda function and trigger it with CloudWatch Events. You would need to create a new rule, set the schedule to a fixed rate of 1 day, and add the Lambda function as a target.

Remember, no matter which method you choose, ensure that your Python environment has access to the `boto3` library, and that AWS credentials are properly configured for the environment running the script.

#### Instructions For eecute_s3_script.sh

To use S3 as the location for your Python scripts, you'll need to fetch the script from the bucket before you can execute it. This is typically done using the AWS CLI. Note that this requires AWS CLI to be configured on your system.

Here's an example of a bash script that you could run via a cron job. This script downloads the Python script from S3 and then executes it:

```bash
#!/bin/bash

# Define the S3 bucket and Python script location
bucket_name="mybucket"
script_name="myscript.py"

# Download the script from S3 to your local system
aws s3 cp s3://$bucket_name/$script_name /path/to/local/copy/of/script.py

# Execute the script
/usr/bin/python3 /path/to/local/copy/of/script.py
```

You can save this script as, for example, `execute_s3_script.sh`, give it execute permissions with `chmod +x execute_s3_script.sh`, and then add it to your crontab. Here's the crontab entry to run this script every day at 2AM:

```cron
0 2 * * * /path/to/execute_s3_script.sh
```

Just replace `/path/to/execute_s3_script.sh` with the actual path to the bash script, and `/path/to/local/copy/of/script.py` with the path where you want to store the downloaded Python script on your local system.

Be aware that this method downloads the Python script anew from S3 each time it's run. If the script updates frequently in S3, this ensures you're always running the latest version. If not, you may want to consider different strategies to avoid unnecessary downloads.