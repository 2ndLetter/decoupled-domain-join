#!/bin/bash -e

echo "This script runs the lab from end to end resulting in a RHEL8 ec2 instance joined to the AWS Managed AD"
echo "Ensure you already configured your aws cli via \"aws configure\""


echo "running: ./environment.sh"
./environment.sh lab

echo "running: ./deploy-cfn.sh -n environment"
./deploy-cfn.sh -n environment

echo "running: ./automate_create_layer.sh"
./automate_create_layer.sh

echo "running: ./function.sh"
./function.sh

echo "running: ./deploy-cfn.sh -n function"
./deploy-cfn.sh -n function

echo "running: ./deploy-cfn.sh -n lab -r"
./deploy-cfn.sh -n lab -r
