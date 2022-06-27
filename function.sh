#!/bin/bash -e

# Return S3 bucket name
S3Bucket=$(aws cloudformation list-exports --query "Exports[?Name=='cfn-stack-environment-s3bucket'].Value" --output text)

# Zip python script
zip python_function.zip lambda_function.py

# Copy zip file to s3
aws s3 cp python_function.zip s3://$S3Bucket

# Return two subnets for the Function
echo "Returning two subnets"
SUBNET_A=$(aws ec2 describe-subnets | jq -r '.Subnets[0]' | jq -r '.SubnetId')
SUBNET_B=$(aws ec2 describe-subnets | jq -r '.Subnets[1]' | jq -r '.SubnetId')

# Configure parameters file
echo "Configuring parameter file"
cp function_template.json parameters/function.json
sed -i "s/SUBNET_A/$SUBNET_A/" parameters/function.json
sed -i "s/SUBNET_B/$SUBNET_B/" parameters/function.json

echo "Script completed successfully!"
