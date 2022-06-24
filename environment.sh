#!/bin/bash -xe

# Remove old keypair
rm -fr ~/.ssh/$1.pem ~/.ssh/$1.pub

# Create keypair in aws account and local ~/.ssh folder
aws ec2 create-key-pair --key-name $1 --query "KeyMaterial" --output text > ~/.ssh/$1.pem
chmod 400 ~/.ssh/$1.pem

# Return VPC
VPC=$(aws ec2 describe-vpcs | jq -r '.Vpcs[]' | jq -r .VpcId)

# Return Subnets
SUBNET_A=$(aws ec2 describe-subnets | jq -r '.Subnets[0]' | jq -r '.SubnetId')
SUBNET_B=$(aws ec2 describe-subnets | jq -r '.Subnets[1]' | jq -r '.SubnetId')

# Configure parameters file
cp environment_template.json parameters/environment.json

sed -i "s/VPC_ID/$VPC/" parameters/environment.json
sed -i "s/SUBNET_A/$SUBNET_A/" parameters/environment.json
sed -i "s/SUBNET_B/$SUBNET_B/" parameters/environment.json
