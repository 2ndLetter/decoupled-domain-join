#!/usr/bin/env python3

import io
import boto3
import json

AWS_REGION = "us-east-1"
S3_BUCKET_NAME = "cfn-stack-environment-s3bucket-1hha15ive92u"

s3_resource = boto3.resource("s3", region_name=AWS_REGION)

#s3_object = s3_resource.Object(S3_BUCKET_NAME, 'bootstrap')
s3_object = s3_resource.Object(S3_BUCKET_NAME, 'passwords.json')

with io.BytesIO() as f:
    s3_object.download_fileobj(f)

    f.seek(0)
    #print(f'Downloaded content:\n{f.read()}')
    #print(f.read())
    json_object = json.loads(f.read())

    print(json_object["password"])
