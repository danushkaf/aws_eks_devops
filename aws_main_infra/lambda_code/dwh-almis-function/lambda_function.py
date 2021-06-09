import json
import psycopg2
import boto3
import base64
import os
from botocore.exceptions import ClientError
from datetime import datetime

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
                                host=secret['host'],#'10.0.5.145',
                                port=secret['port'],
                                user=secret['username'],
                                password=secret['password'])
    except Exception as e:
        print("Error while connectimg to redshift {error}".format(error=e.response))

    else:
        print("Connected to redshift successfully!!!")

    return conn


def lambda_handler(event, context):
    try:
        bucket=os.environ['s3_bucket_name']
        client = boto3.client('s3')
        response = client.list_objects(
        Bucket = bucket
        )
        conn=get_connection()
        for content in response['Contents']:
            #Considers only filename having 'ssi000' extension inside almis folder
            if content['Key'].startswith('almis/') and content['Key'].endswith('.ssi000'):
                #File name to renamed
                old_name=content['Key']
                source = {'Bucket':bucket, 'Key': old_name}
                #New file name with 'ssi' extension
                new_name=old_name.replace('ssi000','ssi')
                print(new_name)
                cursor=conn.cursor()
                result=cursor.execute('select count(*) from xyz_dwh.vw_dep_regext_almis;')
                count=cursor.fetchall()[0][0]
                try:
                    #Copy older file content in new file
                    client.copy(CopySource=source, Bucket=bucket, Key=new_name)
                    #Delete older file
                    client.delete_object(Bucket=bucket, Key=old_name)

                except Exception as e:
                    sql="insert into xyz_stg.stg_extract_log values('{extracttype}','{extractfilename}','{createdondate}','{status}');".format(extracttype='Almis',extractfilename=new_name.lstrip('almis/'),createdondate=datetime.now(),status='Failed')
                    #print(sql)
                    cursor.execute(sql)
                    conn.commit()
                else:
                    sql="insert into xyz_stg.stg_extract_log values('{extracttype}','{extractfilename}','{createdondate}','{accountsreported}','{status}');".format(extracttype='Almis',extractfilename=new_name.lstrip('almis/'),createdondate=datetime.now(),accountsreported=count,status='Success')
                    #print(sql)
                    cursor.execute(sql)
                    conn.commit()

    except Exception as e:
        print("Error Ocuured while renaming file ",e)
    else:
            conn.close()
    return {
        'statusCode': 200,
        'body': json.dumps('Success')
    }
