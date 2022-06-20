#!/bin/bash -xe

# Create keypair in aws account and local ~/.ssh folder
aws ec2 create-key-pair --key-name $1 --query "KeyMaterial" --output text > ~/.ssh/$1.pem

chmod 400 ~/.ssh/$1.pem

aws ec2 describe-key-pairs
