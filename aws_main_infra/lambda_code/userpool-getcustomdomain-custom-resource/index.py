import json
from botocore.vendored import requests
import boto3
import os

domainName = os.environ['user_pool_domain']
cognitoClient = boto3.client('cognito-idp')
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
  try:
    print('Request: start - event ' + json.dumps(event))
    response = cognitoClient.describe_user_pool_domain(
       Domain=domainName
    )
    print('Request: start - response ' + json.dumps(response))
    physicalResourceId = response['DomainDescription']['CloudFrontDistribution']
    send(event, context, SUCCESS, {'Data' : 'Success'}, physicalResourceId=physicalResourceId)

  except Exception as ex:
    print('Unexpected exception' + str(ex))
    send(event, context, FAILED, {'Data' : str(ex)})
    raise
  finally:
    print('Request: end')
