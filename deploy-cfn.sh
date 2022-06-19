#!/bin/bash

while getopts 'nr:' OPTION; do
  case "$OPTION" in
    n)
      argN="$OPTARG"
      echo "Option n used with: $argN"
      ;;
    r)
      RanNumGen=-$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)
      ;;
    ?)
      echo "Usage: $(basename $0) [-n argument] [-r]"
      exit 1
      ;;
  esac
done


echo "This script valdates a CloudFormation template, and creates/updates a CloudFormation Stack"

#RanNumGen=-$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)

aws cloudformation deploy \
    --stack-name cfn-stack-$argN$RanNumGen \
    --template-file $argN.yml \
    --parameter-overrides file://parameters/$argN.json \
    --no-fail-on-empty-changeset \
    --capabilities CAPABILITY_NAMED_IAM \
    #--no-execute-changeset
