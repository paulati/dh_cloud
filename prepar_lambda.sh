#!/bin/sh
rm -r ./pytemp
mkdir ./pytemp
cp s3_lambda_lambda.py ./pytemp
cp paulati_integrador.pem ./pytemp
cd pytemp
pip install boto3 paramiko --target .
chmod -R 755 .
zip -r ../lambda.zip .
unzip -l ../lambda.zip
