#!/bin/bash

while getopts 'n:rc' OPTION; do
  case "$OPTION" in
    n)
      argN="$OPTARG"
      ;;
    r)
      RanNumGen=-$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)
      ;;
    c)
      argC="--no-execute-changeset"
      ;;
    ?)
      echo "Usage: $(basename $0) [-n argument] [-r] [-c]"
      exit 1
      ;;
  esac
done

if [ -z $1 ]
then
  echo "Error, this script requires flags to execute!"
  exit 1
fi

echo "This script valdates a CloudFormation template, and creates/updates a CloudFormation Stack"

aws cloudformation deploy \
    --stack-name cfn-stack-$argN$RanNumGen \
    --template-file $argN.yml \
    --parameter-overrides file://parameters/$argN.json \
    --no-fail-on-empty-changeset \
    --capabilities CAPABILITY_NAMED_IAM \
    $argC
