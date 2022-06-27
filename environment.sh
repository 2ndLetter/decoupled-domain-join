#!/bin/bash -e

set +e
# Remove local private key
echo "Removing local private key"
rm -fr ~/.ssh/$1.pem ~/.ssh/$1.pub

# Delete aws keypair
echo "Deleting aws keypair if it exists"
aws ec2 delete-key-pair --key-name $1
set -e

# Create keypair in aws account and local ~/.ssh folder
echo "Creating new keypair and placing private key in ~/.ssh"
aws ec2 create-key-pair --key-name $1 --query "KeyMaterial" --output text > ~/.ssh/$1.pem
chmod 400 ~/.ssh/$1.pem

# Return VPC
echo "Returning VPC ID"
VPC=$(aws ec2 describe-vpcs | jq -r '.Vpcs[]' | jq -r .VpcId)

# Return Subnets
echo "Returning two subnets"
SUBNET_A=$(aws ec2 describe-subnets | jq -r '.Subnets[0]' | jq -r '.SubnetId')
SUBNET_B=$(aws ec2 describe-subnets | jq -r '.Subnets[1]' | jq -r '.SubnetId')

# Return Route Table
echo "Returning route table"
ROUTE_TABLE=$(aws ec2 describe-route-tables | jq -r '.RouteTables[0]' | jq -r '.RouteTableId')

# Configure parameters file
echo "Configuring parameter file"
cp templates/environment_template.json parameters/environment.json

sed -i "s/VPC_ID/$VPC/" parameters/environment.json
sed -i "s/SUBNET_A/$SUBNET_A/" parameters/environment.json
sed -i "s/SUBNET_B/$SUBNET_B/" parameters/environment.json
sed -i "s/ROUTE_TABLE/$ROUTE_TABLE/" parameters/environment.json

echo "Script completed successfully!"
