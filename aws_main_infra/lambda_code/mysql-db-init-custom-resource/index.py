import json
from botocore.vendored import requests
import boto3
import os
import string
import pymysql
from os import path

secret_name = os.environ['secret_name']
envPrefix = os.environ['env_prefix']
region_name = os.environ['AWS_REGION']
client = boto3.client('secretsmanager',region_name=region_name)
SUCCESS = "SUCCESS"
FAILED = "FAILED"

def send(event, context, responseStatus, response_data, physicalResourceId=None, noEcho=False):
  responseUrl = event['ResponseURL']
  responseBody = {}
  responseBody['Status'] = responseStatus
  responseBody['Reason'] = 'See the details in CloudWatch Log Stream: ' + context.log_stream_name
  responseBody['PhysicalResourceId'] = physicalResourceId
  responseBody['StackId'] = event['StackId']
  responseBody['RequestId'] = event['RequestId']
  responseBody['LogicalResourceId'] = event['LogicalResourceId']
  responseBody['NoEcho'] = noEcho
  responseBody['Data'] = response_data
  json_responseBody = json.dumps(responseBody)
  print('Response body: ' + json_responseBody)
  headers = {
    'content-type' : '',
    'content-length' : str(len(json_responseBody))
  }
  try:
    response = requests.put(responseUrl,
                data=json_responseBody,
                headers=headers)
    print('Status code: ' + response.reason)
  except Exception as ex:
    print('send(..) failed executing requests.put(..): ' + str(ex))

def get_secret():
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
    return str(secret)

def get_connection():
  secret=json.loads(get_secret())
  try:
    conn = pymysql.connect(database=secret['dbname'],
                           host=secret['host'],
                           port=secret['port'],
                           user=secret['username'],
                           password=secret['password'],
                           cursorclass=pymysql.cursors.DictCursor)
  except Exception as e:
    print("Error while connectin to mysql error".format(error=e.response))
  else:
    print("Connected to mysql successfully!!!")

  return conn

def get_sql_from_file():
  """
  Get the SQL instruction from a file

  :return: a list of each SQL query whithout the trailing ";"
  """

  # File did not exists
  filename = os.environ['LAMBDA_TASK_ROOT'] + "/init.sql"
  with open(filename, "r") as sql_file:
    # Split file in list
    ret = sql_file.read().split(';')
    # drop last empty entry
    ret.pop()
    return ret

def handler(event, context):
  """
  Lambda main handler
  """
  physicalResourceId = envPrefix + '-mysql-init-custom-resource'
  try:
    print('Request: start - event ' + json.dumps(event))
    if event['RequestType'] == "Create":
      connection = get_connection()
      with connection:
        with connection.cursor() as cursor:
          request_list = get_sql_from_file()
          for idx, sql_request in enumerate(request_list):
            cursor.execute(sql_request + ';')
          connection.commit()
          send(event, context, SUCCESS, {'Data' : 'Success'}, physicalResourceId=physicalResourceId)
    else :
      send(event, context, SUCCESS, {'Data' : 'Success'}, physicalResourceId=physicalResourceId)

  except Exception as ex:
    print('Unexpected exception' + str(ex))
    send(event, context, FAILED, {'Data' : str(ex)})
    raise
  finally:
    print('Request: end')
