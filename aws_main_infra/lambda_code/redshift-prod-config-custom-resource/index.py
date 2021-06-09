import json
from botocore.vendored import requests
import boto3
import os
import string
import random

envPrefix = os.environ['env_prefix']
clusterId = os.environ['cluster_id']
snapshotRetentionPeriod = os.environ['sapshot_retention_period']
drRegion = os.environ['dr_region']
snapshotCopyGrantName = os.environ['snapshot_copy_grant_name']
kmsKeyId = os.environ['kms_key_id']
client = boto3.client('redshift')
drclient = boto3.client('redshift', region_name=drRegion)
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

def handler(event, context):
  """
  Lambda main handler
  """
  physicalResourceId = envPrefix + '-redshift-update-custom-resource'
  try:
    print('Request: start - event ' + json.dumps(event))
    if event['RequestType'] == "Delete" :
      send(event, context, SUCCESS, {'Data' : 'Success'}, physicalResourceId=physicalResourceId)
    else :
      response = drclient.create_snapshot_copy_grant(
        SnapshotCopyGrantName=snapshotCopyGrantName,
        KmsKeyId=kmsKeyId,
        Tags=[
            {
                'Key': 'Name',
                'Value': snapshotCopyGrantName
            },
        ]
      )
      print('Request: start - response ' + json.dumps(response))
      response = client.enable_snapshot_copy(
        ClusterIdentifier=clusterId,
        DestinationRegion=drRegion,
        RetentionPeriod=int(snapshotRetentionPeriod),
        SnapshotCopyGrantName=snapshotCopyGrantName,
        ManualSnapshotRetentionPeriod=int(snapshotRetentionPeriod)
      )
      print('Request: start - response ' + json.dumps(response))
      send(event, context, SUCCESS, {'Data' : 'Success'}, physicalResourceId=physicalResourceId)

  except Exception as ex:
    print('Unexpected exception' + str(ex))
    send(event, context, FAILED, {'Data' : str(ex)})
    raise
  finally:
    print('Request: end')
