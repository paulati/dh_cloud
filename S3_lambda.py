#!/usr/bin/env python
# coding: utf-8

# Imports
import boto3
import json


# Constants
# profile_name = 'digitalhouse' # or default
region_name ='us-east-1'
origin_bucket = 'grupo5-plot2do'
arn_origin_bucket = 'arn:aws:s3:::' + origin_bucket
role_lambda_s3_name = 'LambdaExecutionFullS3'
arn_aws_lambda_execution_fulls3_role = 'arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole'
arn_amazon_s3_full_access = 'arn:aws:iam::aws:policy/AmazonS3FullAccess'
function_name = 'grupo5-S3events'
runtime = 'python3.7'
handler = 's3_lambda_lambda.lambda_handler'
lambda_zip_file_path = './lambda.zip'


# Clients
# boto3.setup_default_session(profile_name = profile_name)

s3_client = boto3.client('s3', region_name = region_name)
iam_client = boto3.client('iam', region_name = region_name)
lambda_client = boto3.client('lambda', region_name = region_name)
logs_client = boto3.client('logs', region_name = region_name)


# S3
s3_create_bucket_destiny_response = s3_client.create_bucket(Bucket = origin_bucket)

# Role
role_policy_document = {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
json_role_policy_document = json.dumps(role_policy_document)

iam_create_role_response = iam_client.create_role(
  RoleName = role_lambda_s3_name,
  AssumeRolePolicyDocument = json_role_policy_document,
)

arn_role = iam_create_role_response.get('Role').get('Arn')

iam_attach_role_1_response = iam_client.attach_role_policy(
    RoleName = role_lambda_s3_name,
    PolicyArn = arn_aws_lambda_execution_fulls3_role,
)

iam_attach_role_2_response = iam_client.attach_role_policy(
    RoleName = role_lambda_s3_name,
    PolicyArn = arn_amazon_s3_full_access
)

iam_get_role = iam_client.get_role(RoleName = role_lambda_s3_name)

# Lambda
env_variables = dict()

with open(lambda_zip_file_path, 'rb') as f:
    zipped_code = f.read()

lambda_create_func_response = lambda_client.create_function(
    FunctionName = function_name,
    Runtime = runtime,
    Role = iam_get_role['Role']['Arn'],
    Handler = handler,
    Code = dict(ZipFile = zipped_code),
    Timeout = 300,
    Environment = dict(Variables = env_variables),
)

arn_lambda = lambda_create_func_response.get('FunctionArn')

print(arn_lambda)

lambda_add_permission_response = lambda_client.add_permission(
    FunctionName = function_name,
    StatementId = 'sid-deflater',
    Action = 'lambda:InvokeFunction',
    Principal = 's3.amazonaws.com',
    SourceArn = arn_origin_bucket
)

notification_configuration = { 
  "LambdaFunctionConfigurations":[ 
    { 
      "LambdaFunctionArn":arn_lambda,
      "Events":[ 
        "s3:ObjectCreated:*"
      ]
    }
  ]
}

json_notification_configuration = json.dumps(notification_configuration)

s3_put_notif_response = s3_client.put_bucket_notification_configuration(
    Bucket = origin_bucket,
    NotificationConfiguration = notification_configuration
)








