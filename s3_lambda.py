import io
import boto3
import json

def lambda_handler(context, event):
    
    def get_passwords():      
        AWS_REGION = "us-east-1"
        S3_BUCKET_NAME = "cfn-stack-environment-s3bucket-6lz191zpubr"
        s3_resource = boto3.resource("s3", region_name=AWS_REGION)
        s3_object = s3_resource.Object(S3_BUCKET_NAME, 'passwords.json')
        with io.BytesIO() as f:
            s3_object.download_fileobj(f)
            f.seek(0)
            json_object = json.loads(f.read())
            print(json_object["password"])
            
    def get_ssh_key():
        AWS_REGION = "us-east-1"
        S3_BUCKET_NAME = "cfn-stack-environment-s3bucket-6lz191zpubr"
        s3_resource = boto3.resource("s3", region_name=AWS_REGION)
        s3_object = s3_resource.Object(S3_BUCKET_NAME, 'bootstrap')
        with io.BytesIO() as f:
            s3_object.download_fileobj(f)
            f.seek(0)
            print(f.read())
    
    get_passwords()
    get_ssh_key()
