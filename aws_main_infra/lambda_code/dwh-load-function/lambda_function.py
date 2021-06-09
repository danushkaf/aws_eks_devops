import json
import psycopg2
import boto3
import base64
import os
from botocore.exceptions import ClientError

def get_secret():

    secret_name = os.environ['redshift_secret_name']
    region_name = os.environ['AWS_REGION']

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        if e.response['Error']['Code'] == 'DecryptionFailureException':
            print('DecryptionFailureException')
            raise e
        elif e.response['Error']['Code'] == 'InternalServiceErrorException':
            print('InternalServiceErrorException')
            raise e
        elif e.response['Error']['Code'] == 'InvalidParameterException':
            print('InvalidParameterException')
            raise e
        elif e.response['Error']['Code'] == 'InvalidRequestException':
            print('InvalidRequestException')
            raise e
        elif e.response['Error']['Code'] == 'ResourceNotFoundException':
            print(ResourceNotFoundException)
            raise e
    else:
        # Decrypts secret using the associated KMS CMK.
        # Depending on whether the secret is a string or binary, one of these fields will be populated.
        if 'SecretString' in get_secret_value_response:
            secret = get_secret_value_response['SecretString']
        else:
            secret = base64.b64decode(get_secret_value_response['SecretBinary'])
    return secret

def get_connection():
    secret=json.loads(get_secret())
    try:
        conn = psycopg2.connect(dbname=secret['dbname'],
                                host=secret['host'],
                                port=secret['port'],
                                user=secret['username'],
                                password=secret['password'])
    except Exception as e:
        print("Error while connectimg to redshift {error}".format(error=e.response))

    else:
        print("Connected to redshift successfully!!!")

    return conn


def lambda_handler(event, context):
    conn=get_connection()
    cursor=conn.cursor()
    cursor.execute(event['sql'])
    return {
        "statusCode": 200,
        "body": json.dumps('Success!!')
    }
