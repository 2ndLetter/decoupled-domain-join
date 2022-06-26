import io
import boto3
import json
import paramiko

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

    def ssh():
        k = paramiko.RSAKey.from_private_key_file("/tmp/bootstrap.pem")
        c = paramiko.SSHClient()
        c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        print("connecting")
        c.connect( hostname = "172.31.4.242", username = "bootstrap", pkey = k )
        print("connected")
        #commands = [ "date", "sleep 5", "date" ]
        commands = [ "echo \"P@\$\$Word123\" | sudo realm join -v -U admin lab.example.com", "sleep 5", "echo \"P@\$\$Word123\" | sudo realm leave -v -U admin lab.example.com" ]

        for command in commands:
            print("Executing {}".format( command ))
            stdin , stdout, stderr = c.exec_command(command)
            print(stdout.read())
            print( "Errors")
            print(stderr.read())
        c.close()

    def main():
        returned_un = get_auth("username")
        print(returned_un)
        returned_pw = get_auth("password")
        print(returned_pw)
        returned_dm = get_auth("domain")
        print(returned_dm)
        get_ssh_key()
        ssh()

    main()
