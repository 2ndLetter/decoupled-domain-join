#!/bin/bash

echo "This script valdates a CloudFormation template, and creates/updates a CloudFormation Stack"

RanNumGen=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)

aws cloudformation deploy \
    --stack-name cfn-stack-$1-$RanNumGen \
    --template-file $1.yml \
    --parameter-overrides file://parameters/$1.json \
    --no-fail-on-empty-changeset \
    --capabilities CAPABILITY_IAM \
    #--no-execute-changeset
