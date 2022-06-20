#!/bin/bash

#Todo: Script doesn't work when choosing a specific stack name

while getopts 'n:u:c' OPTION; do
  case "$OPTION" in
    n)
      argN="$OPTARG"
      NAME=$argN-$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)
      ;;
    u)
      argU="$OPTARG"
      NAME=$argN-$argU
      ;;
    c)
      argC="--no-execute-changeset"
      ;;
    ?)
      echo "Usage: $(basename $0) [-n argument] [-u argument] [-c]"
      exit 1
      ;;
  esac
done

if [ -z $1 ]
then
  echo "Error, this script requires flags to execute!"
  exit 1
fi

#echo $NAME
#exit 0

echo "This script valdates a CloudFormation template, and creates/updates a CloudFormation Stack"

aws cloudformation deploy \
    --stack-name cfn-stack-$NAME \
    --template-file $argN.yml \
    --parameter-overrides file://parameters/$argN.json \
    --no-fail-on-empty-changeset \
    --capabilities CAPABILITY_NAMED_IAM \
    $argC
