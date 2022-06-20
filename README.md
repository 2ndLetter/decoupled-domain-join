# decoupled-domain-join

## CloudFormation Stack:
### - [ ] Microsoft AD
### - [ ] RHEL8 Instance (Userdata)
### - [ ] Windows 10 Instance
### - [ ] Instance Profile
### - [ ] Lambda Function
### - [ ] s3 bucket
------
## Preparation Script:
### - [ ] Add AD credentials to s3 bucket
------
## Userdata Script:
### - [x] Install SSM Agent, cfn-bootstrap, unzip, wget, python3, Chef Client
### - [ ] Install temp user and add to wheel group
### - [ ] Create SSH keypair
### - [ ] Add public key to temp user
### - [ ] Add private key to Secrets Manager
### - [ ] Install Chef Client
### - [ ] Invoke Lambda Function
------
## Lambda Function:
### - [ ] Retrieve private key from Secrets Manager
### - [ ] Retrieve AD credentials from s3 bucket
### - [ ] Connect to ec2 instance via SSH
### - [ ] Joins ec2 instance to AD Domain
------
## Bootstrap Script:
### - [ ] Delete temp user
