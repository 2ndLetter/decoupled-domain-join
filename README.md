# decoupled-domain-join

## Environment CloudFormation Stack:
### - [x] S3 bucket for SSH keypairs 
### - [x] Microsoft AD
### - [x] Server 2019
### - [ ] Lambda Function
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
### - [ ] Invoke Lambda Function
### - [ ] Delete temp user
------
## Lambda Function: (payload: private ssh key + AD domain credentials + private IP address)
### - [ ] Retrieve private key from Secrets Manager
### - [ ] Retrieve AD credentials from s3 bucket
### - [ ] Connect to ec2 instance via SSH
### - [ ] Joins ec2 instance to AD Domain
------
