#!/bin/bash -e

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
