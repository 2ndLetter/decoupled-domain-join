import io
import boto3
import json

def lambda_handler(event, context):

    #print(event['aws_region'])
    #print(event['s3_object_pw'])
    #print(event['s3_bucket_name'])

    def get_passwords():
        s3_resource = boto3.resource("s3", region_name=event['aws_region'])
        s3_object = s3_resource.Object(event['s3_bucket_name'], event['s3_object_pw'])
        with io.BytesIO() as f:
            s3_object.download_fileobj(f)
            f.seek(0)
            json_object = json.loads(f.read())
            print(json_object["password"])

    def get_ssh_key():
        s3_resource = boto3.resource("s3", region_name=event['aws_region'])
        s3_object = s3_resource.Object(event['s3_bucket_name'], event['s3_object_k'])
        with io.BytesIO() as f:
            s3_object.download_fileobj(f)
            f.seek(0)
            print(f.read())

    get_passwords()
    get_ssh_key()
