#!/bin/bash

echo "**THIS SCRIPT VALIDATES AND CREATES/UPDATES THE CF STACK**"

aws cloudformation deploy --stack-name ec2-stack --template-file ec2.yml --parameter-overrides file://parameters/ec2.json --no-fail-on-empty-changeset --capabilities CAPABILITY_IAM #--no-execute-changeset