#!/usr/bin/env python3

import paramiko

# Userdata script:
# - Returns the private ip address and S3 bucket name
# - Invokes the lambda function (payload is private ip address, S3 bucket)
# Lambda Function:
# - Retrieve private ip address and S3 bucket name from payload
# - Retrieve private ssh key and AD credentials from S3 bucket
# - SSH to server using private ip address
# - Run domain join command

#########################

k = paramiko.RSAKey.from_private_key_file("/home/bmchadwick/.ssh/bootstrap")
c = paramiko.SSHClient()
c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
print("connecting")
c.connect( hostname = "44.205.134.62", username = "bootstrap", pkey = k )
print("connected")
commands = [ "echo \"P@\$\$Word123\" | sudo realm join -v -U admin lab.example.com", "date" ]
#commands = [ "echo \"P@\$\$Word123\" | sudo realm leave -v -U admin lab.example.com", "date" ]
for command in commands:
    print("Executing {}".format( command ))
    stdin , stdout, stderr = c.exec_command(command)
    print(stdout.read())
    print( "Errors")
    print(stderr.read())
c.close()
