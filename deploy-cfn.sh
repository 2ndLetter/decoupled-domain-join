#!/bin/bash

echo "**THIS SCRIPT VALIDATES AND CREATES/UPDATES THE CF STACK**"

aws cloudformation deploy --stack-name temp --template-file ec2.yml --parameter-overrides file://paramerts/ec2.json --no-fail-on-empty-changeset --capabilities CAPABILITY_IAM #--no-execute-changeset