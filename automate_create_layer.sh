#!/bin/bash

echo "Returning aws resource Ids"
SUBNET=$(aws ec2 describe-subnets | jq -r '.Subnets[0]' | jq -r '.SubnetId')
SG_EXPORT=$(aws cloudformation list-exports --query "Exports[?Name=='cfn-stack-environment-InstanceSecurityGroup'].Value" --output text)
INSTANCE_PROFILE=$(aws cloudformation list-exports --query "Exports[?Name=='cfn-stack-environment-EC2InstanceProfile'].Value" --output text)
SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=$SG_EXPORT | jq -r .SecurityGroups[0] | jq -r .GroupId)

#echo $SG_EXPORT
#echo $SG_ID
#exit 0

echo "Starting an ec2 instance which will package/upload the python_layer.zip to s3 and terminate itself"
aws ec2 run-instances \
    --image-id ami-0cff7528ff583bf9a \
    --instance-type t2.medium \
    --count 1 \
    --iam-instance-profile Name=$INSTANCE_PROFILE \
    --subnet-id $SUBNET \
    --key-name lab \
    --associate-public-ip-address \
    --security-group-ids $SG_ID \
    --user-data file://create_layer.sh \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=create_layer}]' \
    > /dev/null
