#!/bin/bash -e

zip python_function.zip lambda_function.py

S3Bucket=$(aws cloudformation list-exports --query "Exports[?Name=='cfn-stack-environment-s3bucket'].Value" --output text)

aws s3 cp python_function.zip s3://$S3Bucket

# Return Subnets
echo "Returning two subnets"
SUBNET_A=$(aws ec2 describe-subnets | jq -r '.Subnets[0]' | jq -r '.SubnetId')
SUBNET_B=$(aws ec2 describe-subnets | jq -r '.Subnets[1]' | jq -r '.SubnetId')

echo $SUBNET_A
echo $SUBNET_B

# Configure parameters file
echo "Configuring parameter file"
cp function_template.json parameters/function.json

sed -i "s/SUBNET_A/$SUBNET_A/" parameters/function.json
sed -i "s/SUBNET_B/$SUBNET_B/" parameters/function.json

echo "Script completed successfully!"
