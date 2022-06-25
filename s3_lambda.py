import io
import boto3
import json

def lambda_handler(event, context):
    
    def get_passwords():
    
        #print(event['aws_region'])
        #print(event['s3_object_pw'])
        #print(event['s3_bucket_name'])
        
        s3_resource = boto3.resource("s3", region_name=event['aws_region'])
        s3_object = s3_resource.Object(event['s3_bucket_name'], event['s3_object_pw'])
        
        with io.BytesIO() as f:
            s3_object.download_fileobj(f)
            f.seek(0)
            json_object = json.loads(f.read())
            print(json_object["password"])
            
    def get_ssh_key():
        #AWS_REGION = "us-east-1"
        #S3_BUCKET_NAME = "cfn-stack-environment-s3bucket-1pq7lgfwwy8qj"
        s3_resource = boto3.resource("s3", region_name=event['aws_region'])
        s3_object = s3_resource.Object(event['s3_bucket_name'], event['s3_object_k'])
        with io.BytesIO() as f:
            s3_object.download_fileobj(f)
            f.seek(0)
            print(f.read())
        
    get_passwords()
    get_ssh_key()
    
    #message = 'Hello {} {}!'.format(event['first_name'], event['last_name'])
    #message = 'Hello {} {} {}!'.format(event['first_name'], event['last_name'], event['aws_region'])  
    #return { 
    #    'message' : message
    #}
