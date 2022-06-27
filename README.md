# decoupled-domain-join

# Steps:
1. Log into AWS account. I'm using ACloudGuru's AWS Cloud Sandbox
2. Run `aws configure` to configure the aws cli with your credentials
3. Run `./environment.sh lab` to create a new keypair and configure parameter file
4. Run `./deploy-cfn.sh -n environment` to deploy the environment resources
5. Run `./automate_create_layer.sh` to deploy an Amazon Linux 2 ec2 instance that will package up the python layer files and upload to s3
6. Run `./function.sh` to zip the python script, upload it to s3, and configure the parameters file
7. Run `./deploy-cfn.sh -n function` to deploy the lambda function
8. Run `./deploy-cfn.sh -n lab -r` to deploy the lab resources
9. (Optional) Log into the Windows server and [install the AD admin tools](https://docs.aws.amazon.com/directoryservice/latest/admin-guide/ms_ad_install_ad_tools.html) (Todo: Create a script to automate this)
10. (Optional) Run `./downloadpem.sh` to download the bootstrap pem file and test locally

- Python module used: [paramiko 2.11.0](https://pypi.org/project/paramiko/)
------
# Automated Execution
## - Run `./execute_lab.sh` in order to execute the entire lab from end to end
------
# Todo:
## Environment Script (environment.sh):
### - [x] Create ec2 keypair
### - [x] Upload AD credentials to s3 bucket
### - [x] Upload Code to S3
------
## Environment CloudFormation Stack (environment.yml):
### - [x] S3 bucket for SSH keypairs 
### - [x] Microsoft AD
### - [x] Server 2019
### - [x] Create Lambda Function
### - [x] Create Lambda Layer
### - [x] Create IAM Role
### - [x] Create Security group
------
## Lab CloudFormation Stack (lab.yml):
### - [x] RHEL8 Instance (userdata)
### - [x] Instance Profile (IAM Role/Policies)
### - [x] Security Group(s)
------
## Userdata Script (lab cfn stack):
### - [x] Install SSM Agent, cfn-bootstrap, unzip, wget, python3, Chef Client
### - [x] Install temp user and add to wheel group
### - [x] Create SSH keypair
### - [x] Add public key to temp user
### - [x] Upload private key to S3Bucket
### - [x] Install Chef Client
### - [x] Invoke Lambda Function (payload: private ip, s3 bucket, username, passwords.json)
### - [ ] Delete temp user
------
## Lambda Function Script (function.sh):
### - [x] Zip and upload python script to s3 bucket
### - [x] Configure function.json parameters file
------
## Lambda Function: (payload: private ssh key + AD domain credentials + private IP address)
### - [x] Retrieve private ip address and s3 bucket from userdata payload (via aws lambda)
### - [x] Retrieve private ssh key from S3 (via aws lambda)
### - [x] Retrieve AD credentials from S3 (via aws lambda)
### - [x] Connect to ec2 instance via SSH (via aws lambda)
### - [x] Joins ec2 instance to AD Domain (via aws lambda)
### - [x] Put it all together (via CloudFormation and scripts)
------
## Notes:
### - Work within venv: `source ~/venv/bin/activate`
