#!/bin/bash -e

# Run from within Cloud9 (or an AWS Linux 2 ec2 instance)
# create within a python virtual environment

packageArray=("bcrypt" "cffi" "cryptography" "paramiko" "pycparser" "PyNaCl" "six")

for i in ${packageArray[@]};
do
  echo "Packaging $i"
  pip install \
      --platform manylinux2014_x86_64 \
      --target=python \
      --implementation cp \
      --python 3.9 \
      --only-binary=:all: --upgrade \
      $i
done
