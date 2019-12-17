from __future__ import print_function

from urllib.parse import quote
import boto3
import paramiko

print('Loading function')

s3 = boto3.client('s3')

#ec2_key_pair_file_name = 'ec2-py-keypair.pem' # La llave para conectarse al ec2
ec2_key_pair_file_name = 'paulati_integrador.pem' # La llave para conectarse al ec2
ec2_public_ip = '3.95.132.193' # La IP del EC2
ami_user = 'ec2-user'


def lambda_handler(event, context):
    key = quote(event['Records'][0]['s3']['object']['key'].encode('utf8'))
    origin_bucket = quote(event['Records'][0]['s3']['object']['key'].encode('utf8'))
    try:
        obj = s3.get_object(
            Bucket = origin_bucket,
            Key = key,
        )
        
        key = paramiko.RSAKey.from_private_key_file(ec2_key_pair_file_name)
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        client.connect(
            hostname = ec2_public_ip,
            username = ami_user,
            pkey = key
        )

        cmd = 'echo ' + origin_bucket
        stdin, stdout, stderr = client.exec_command(cmd)

        client.close()
    except Exception as e:
        print(e)
        raise e