import json
from botocore.vendored import requests
import boto3
import os
import time
import datetime
import dateutil.parser
from datetime import date

kmsKeyId = os.environ['kms_key_id']
bucketName = os.environ['bucket_name']
retentionDays = os.environ['retention_days']
iamRoleArn = os.environ['iam_role_arn']
region_name = os.environ['AWS_REGION']

client = boto3.client('rds')

def describe_db_cluster_snapshots(marker):
  response = client.describe_db_cluster_snapshots(
    SnapshotType='manual',
    MaxRecords=100,
    Marker=marker
  )
  return response

def describe_db_snapshots(marker):
  response = client.describe_db_snapshots(
    SnapshotType='manual',
    MaxRecords=100,
    Marker=marker
  )
  return response

def handler(event, context):
  """
  Lambda main handler
  """
  try:
    print('Request: start - event ' + json.dumps(event))
    aws_account_id = context.invoked_function_arn.split(":")[4]
    marker = ''
    selected_snapshots = []
    today = date.today()
    delta = datetime.timedelta(days = int(retentionDays))
    while True:
      response = describe_db_cluster_snapshots(marker)
      for i in response['DBClusterSnapshots']:
        if i['SnapshotCreateTime'].date() <= today - delta:
          print (i['SnapshotCreateTime'].date())
          snapshot_dict = {
            "type" : "cluster",
            "id" : i['DBClusterSnapshotIdentifier'],
            "arn" : 'arn:aws:rds:' + region_name + ':' + aws_account_id + ':cluster-snapshot:' + i['DBClusterSnapshotIdentifier']
          }
          selected_snapshots.append(snapshot_dict)
      if 'Marker' in response:
        marker = response['Marker']
      else:
        break
    while True:
      response = describe_db_snapshots(marker)
      for i in response['DBSnapshots']:
        if i['SnapshotCreateTime'].date() <= today - delta:
          print (i['SnapshotCreateTime'].date())
          snapshot_dict = {
            "type" : "instance",
            "id" : i['DBSnapshotIdentifier'],
            "arn" : 'arn:aws:rds:' + region_name + ':' + aws_account_id + ':snapshot:' + i['DBSnapshotIdentifier']
          }
          selected_snapshots.append(snapshot_dict)
      if 'Marker' in response:
        marker = response['Marker']
      else:
        break
    for snapshot_dict in selected_snapshots:
      taskId = 'archive-task-' + snapshot_dict['id']
      response = client.start_export_task(
        ExportTaskIdentifier=taskId,
        SourceArn=snapshot_dict['arn'],
        S3BucketName=bucketName,
        IamRoleArn=iamRoleArn,
        KmsKeyId=kmsKeyId
      )

  except Exception as ex:
    print('Unexpected exception' + str(ex))
    raise
  finally:
    print('Request: end')
