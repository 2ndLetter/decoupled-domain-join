import io
import boto3
import json
import paramiko

# Userdata script:
# - Returns the private ip address and S3 bucket name
# - Invokes the lambda function (payload is private ip address, S3 bucket)
# Lambda Function:
# - *Include paramiko in the lambda function
# - Retrieve private ip address and S3 bucket name from payload
# - Retrieve private ssh key and AD credentials from S3 bucket
# - SSH to server using private ip address
# - Run domain join command

def lambda_handler(event, context):

    #print(event['aws_region'])
    #print(event['s3_object_pw'])
    #print(event['s3_object_k'])
    #print(event['s3_bucket_name'])

    def get_auth(arg1):
        s3_resource = boto3.resource("s3", region_name=event['aws_region'])
        s3_object = s3_resource.Object(event['s3_bucket_name'], event['s3_object_pw'])
        with io.BytesIO() as f:
            s3_object.download_fileobj(f)
            f.seek(0)
            json_object = json.loads(f.read())
            output = json_object[arg1]
            return output

    def get_ssh_key():
        s3_resource = boto3.resource("s3", region_name=event['aws_region'])
        s3_object = s3_resource.Object(event['s3_bucket_name'], event['s3_object_k'])
        with io.BytesIO() as f:
            s3_object.download_fileobj(f)
            f.seek(0)
            ssh_key = (f.read())
            ssh_key_str = ssh_key.decode(encoding="utf-8")
            #print(ssh_key_str)
            file = open("/tmp/bootstrap.pem", "w")
            file.write(ssh_key_str)
            file.close

    def ssh(arg1, arg2, arg3):
        priv_ip_addr = event['ip_address']
        #print(arg1)
        #print(arg2)
        #print(arg3)
        env_dict={"LC_NAME":arg1,"LC_IDENTIFICATION":arg2,"LC_ADDRESS":arg3}
        k = paramiko.RSAKey.from_private_key_file("/tmp/bootstrap.pem")
        c = paramiko.SSHClient()
        c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        print("connecting")
        #c.connect( hostname = "172.31.4.242", username = "bootstrap", pkey = k )
        c.connect( hostname = priv_ip_addr, username = "bootstrap", pkey = k )
        print("connected")
        #commands = [ "echo $LC_NAME", "echo $LC_IDENTIFICATION", "echo $LC_ADDRESS" ]
        #commands = [ "date", "sleep 5", "date" ]
        #commands = [ "echo \"P@\$\$Word123\" | sudo realm join -v -U admin lab.example.com", "sleep 5", "echo \"P@\$\$Word123\" | sudo realm leave -v -U admin lab.example.com" ]
        commands = [ "echo \"$LC_IDENTIFICATION\" | sudo realm join -v -U $LC_NAME $LC_ADDRESS", "sleep 5", "echo \"$LC_IDENTIFICATION\" | sudo realm leave -v -U $LC_NAME $LC_ADDRESS" ]

        for command in commands:
            print("Executing {}".format( command ))
            #stdin , stdout, stderr = c.exec_command(command)
            stdin , stdout, stderr = c.exec_command(command, environment=env_dict)
            print(stdout.read())
            print( "Errors")
            print(stderr.read())
        c.close()

    def main():
        returned_un = get_auth("username")
        #print(returned_un)
        returned_pw = get_auth("password")
        #print(returned_pw)
        returned_dm = get_auth("domain")
        #print(returned_dm)
        get_ssh_key()
        ssh(returned_un, returned_pw, returned_dm)

    main()
