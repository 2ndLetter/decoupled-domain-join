#!/bin/bash -xe

# Remove old keypair
rm -fr ~/.ssh/$1.pem ~/.ssh/$1.pub

# Create keypair in aws account and local ~/.ssh folder
aws ec2 create-key-pair --key-name $1 --query "KeyMaterial" --output text > ~/.ssh/$1.pem

chmod 400 ~/.ssh/$1.pem

#aws ec2 describe-key-pairs
