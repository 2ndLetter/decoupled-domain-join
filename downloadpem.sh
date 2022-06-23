#!/bin/bash -xe

# Remove old keypair
rm -fr ~/.ssh/bootstrap

# Download private key from s3
S3Bucket=$(aws cloudformation list-exports --query "Exports[?Name=='cfn-stack-environment-s3bucket'].Value" --output text)
aws s3 cp s3://$S3Bucket/bootstrap ~/.ssh/bootstrap
