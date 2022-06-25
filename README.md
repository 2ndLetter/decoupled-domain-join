# decoupled-domain-join
#
# Steps:
1. Log into AWS account. I'm using ACloudGuru Cloud Sandbox
2. Run `aws configure` to configure the aws cli
3. Run `./environment.sh lab` to create a new keypair and configure parameter file
4. Run `./deploy-cfn.sh -n environment` to deploy the environment resources
5. Log into the Windows server and [install the AD admin tools](https://docs.aws.amazon.com/directoryservice/latest/admin-guide/ms_ad_install_ad_tools.html) (Todo: Create a script to automate this)
6. Run `./deploy-cfn.sh -n lab -r` to deploy the lab resources
7. (If testing locally) Run `./downloadpem.sh` to download the bootstrap pem file

- Python module imported: [paramiko 2.11.0](https://pypi.org/project/paramiko/)

# Todo:
## Environment CloudFormation Stack:
### - [x] S3 bucket for SSH keypairs 
### - [x] Microsoft AD
### - [x] Server 2019
### - [ ] Create Lambda Function
### - [ ] Create Lambda Layer
------
## Environment Script:
### - [x] Create ec2 keypair
### - [x] Upload AD credentials to s3 bucket
------
## Lab CloudFormation Stack:
### - [x] RHEL8 Instance (userdata)
### - [x] Instance Profile (IAM Role/Policies)
### - [x] Security Group(s)
------
## Lab Script (userdata):
### - [x] Install SSM Agent, cfn-bootstrap, unzip, wget, python3, Chef Client
### - [x] Install temp user and add to wheel group
### - [x] Create SSH keypair
### - [x] Add public key to temp user
### - [x] Upload private key to S3Bucket
### - [x] Install Chef Client
### - [ ] Invoke Lambda Function (payload: private ip address, s3 bucket)
### - [ ] Delete temp user
------
## Lambda Function: (payload: private ssh key + AD domain credentials + private IP address)
### - [ ] Retrieve private ip address from userdata payload (via aws lambda)
### - [x] Retrieve private ssh key from S3 (via aws lambda)
### - [x] Retrieve AD credentials from S3 (via aws lambda)
### - [x] Connect to ec2 instance via SSH (via aws lambda)
### - [x] Joins ec2 instance to AD Domain (via aws lambda)
### - [ ] Put it all together (via CloudFormation)
------
## Notes:
### - Install paramiko: `pip install paramiko`
### - Work within venv: `source ~/venv/bin/activate`
### - Manual Steps: Create IAM Role, Security Group, Create Lambda Function (30s timeout, test event), package up dependencies or create lambda layer


