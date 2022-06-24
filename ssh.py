#!/usr/bin/env python3

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

#########################

k = paramiko.RSAKey.from_private_key_file("/home/bmchadwick/.ssh/bootstrap")
c = paramiko.SSHClient()
c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
print("connecting")
c.connect( hostname = "34.231.230.249", username = "bootstrap", pkey = k )
print("connected")

# Join Domain
#commands = [ "echo \"P@\$\$Word123\" | sudo realm join -v -U admin lab.example.com", "date" ]

# Leave Domain
#commands = [ "echo \"P@\$\$Word123\" | sudo realm leave -v -U admin lab.example.com", "date" ]

# Join, pause, Leave Domain
commands = [ "echo \"P@\$\$Word123\" | sudo realm join -v -U admin lab.example.com", "sleep 5", "echo \"P@\$\$Word123\" | sudo realm leave -v -U admin lab.example.com" ]

for command in commands:
    print("Executing {}".format( command ))
    stdin , stdout, stderr = c.exec_command(command)
    print(stdout.read())
    print( "Errors")
    print(stderr.read())
c.close()
