import json
from botocore.vendored import requests
import boto3
import os
import string
import psycopg2
from os import path

secret_name = os.environ['secret_name']
stg_schema = os.environ['stg_schema']
envPrefix = os.environ['env_prefix']
redshiftRoleArn = os.environ['role_arn']
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

def prepare_sql_files():
  secret=json.loads(get_secret())
  dbname = secret['dbname']
  schemaName = secret['schema']
  host = secret['host']
  print(dbname)
  print(schemaName)
  print(host)
  for dname, dirs, files in os.walk("db-scripts"):
    for fname in files:
      fpath = os.path.join(dname, fname)
      fwpath = os.path.join("/tmp", dname, fname)
      fwdir = os.path.join("/tmp", dname)
      if not os.path.exists(fwdir):
        os.makedirs(fwdir)
      with open(fpath) as f:
        s = f.read()
      s = s.replace("DATABASE_NAME", dbname)
      s = s.replace("REDSHIFT_SCHEMA_NAME", schemaName)
      s = s.replace("REDSHIFT_STG_SCHEMA_NAME", stg_schema)
      s = s.replace("SPRECTRUM_ROLE_ARN", redshiftRoleArn)
      with open(fwpath, "w") as f:
        f.write(s)

def handler(event, context):
  """
  Lambda main handler
  """
  physicalResourceId = envPrefix + '-redshift-init-custom-resource'
  try:
    print('Request: start - event ' + json.dumps(event))
    if event['RequestType'] == "Create":
      connection = get_connection()
      prepare_sql_files()
      cursor=connection.cursor()
      cursor.execute(open("/tmp/db-scripts/tables/xyz_DWH_DDL.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/tables/xyz_EXT_DDL.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/tables/xyz_EXT_DML.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/tables/xyz_STG_DDL.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_addresslines_dwh.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_acctinterestschedule.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_countrymaster.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_custaddrdetails.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_custcitizenship.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_customeraddresshistory.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_customerdetailshistory.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_customer_x_account.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_custtaxresidency.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_dimaccount.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_dimcurrency.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_dimcustomer.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_dimgeography.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_dimglaccount.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_dimnominatedaccount.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_dimproduct.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_dimsavingsaccount.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_dwh.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_factaccountinterest.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_factacctbalssdaily.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_factapplication.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_factgljournal.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_factsavingstrans.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_nationalitymaster.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_notificationhistory.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_load_unittestresult.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/procedures/prc_unload_almis.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/views/vw_DimProduct.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/views/vw_Factapplication.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/views/vw_Deposits_Report2.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/views/vw_Deposits_Report2_Profile.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/views/vw_deposits_report3.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/views/vw_fscs_aggregate_balance.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/views/vw_fscs_contact_details.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/views/vw_fscs_customer_details.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/views/vw_fscs_details_of_accounts.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/views/vw_dep_regext_Almis.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/views/vw_deposits_report1.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/views/vw_deposits_report5.sql", "r").read())
      cursor.execute(open("/tmp/db-scripts/views/vw_deposits_report7.sql", "r").read())
      send(event, context, SUCCESS, {'Data' : 'Success'}, physicalResourceId=physicalResourceId)
    else :
      send(event, context, SUCCESS, {'Data' : 'Success'}, physicalResourceId=physicalResourceId)

  except Exception as ex:
    print('Unexpected exception' + str(ex))
    send(event, context, FAILED, {'Data' : str(ex)})
    raise
  finally:
    print('Request: end')
