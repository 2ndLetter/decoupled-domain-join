#!/bin/bash -e

# Run from within Cloud9 (or an AWS Linux 2 ec2 instance)

echo "Create (and activate) a python virtual environment"
python3 -m venv venv
source venv/bin/activate

echo "Create python folder"
mkdir python

echo "Create Array of python packages installed via `pip install paramiko`"
packageArray=("bcrypt" "cffi" "cryptography" "paramiko" "pycparser" "PyNaCl" "six")

echo "Install each package as per aws documentation"
# https://aws.amazon.com/premiumsupport/knowledge-center/lambda-python-package-compatible/
for i in ${packageArray[@]};
do
  echo "Packaging $i !!"
  sleep 2
  pip install \
      --platform manylinux2014_x86_64 \
      --target=python \
      --implementation cp \
      --python 3.9 \
      --only-binary=:all: --upgrade \
      $i
done

echo "Zip up packages for upload/import"
zip -r python.zip python/

echo "Upload to s3"
S3Bucket=$(aws s3 ls | grep cfn-stack | awk '{print $NF}')
aws s3 cp python.zip s3://$S3Bucket

echo "deactivate venv"
deactivate
