import json
from botocore.vendored import requests
import boto3
import os
import time
import datetime
import dateutil.parser
from datetime import date

clusterId = os.environ['cluster_id']
kmsKeyId = os.environ['kms_key_id']
drRegion = os.environ['dr_region']
region_name = os.environ['AWS_REGION']

client = boto3.client('rds')
drclient = boto3.client('rds', region_name=drRegion)

def describe_db_cluster_snapshots(marker):
  response = client.describe_db_cluster_snapshots(
    DBClusterIdentifier=clusterId,
    SnapshotType='automated',
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
    delta = datetime.timedelta(days = 1)
    while True:
      response = describe_db_cluster_snapshots(marker)
      for i in response['DBClusterSnapshots']:
        if i['SnapshotCreateTime'].date() == today - delta:
          print (i['SnapshotCreateTime'].date())
          snapshot_dict = {
            "id" : i['DBClusterSnapshotIdentifier'],
            "arn" : 'arn:aws:rds:' + region_name + ':' + aws_account_id + ':cluster-snapshot:' + i['DBClusterSnapshotIdentifier']
          }
          selected_snapshots.append(snapshot_dict)
      if 'Marker' in response:
        marker = response['Marker']
      else:
        break
    for snapshot_dict in selected_snapshots:
      snapshotId = snapshot_dict['id']
      snapshotId = snapshotId.replace(":", "-")
      print(snapshotId)
      snapshotArn = snapshot_dict['arn']
      response = drclient.copy_db_cluster_snapshot(
        SourceDBClusterSnapshotIdentifier=snapshotArn,
        TargetDBClusterSnapshotIdentifier='dr-' + snapshotId,
        KmsKeyId=kmsKeyId,
        CopyTags=False,
        Tags=[
            {
                'Key': 'Name',
                'Value': 'dr-' + snapshotId
            }
        ],
        SourceRegion=region_name
      )

    print('Request: start - response ' + str(response))

  except Exception as ex:
    print('Unexpected exception' + str(ex))
    raise
  finally:
    print('Request: end')
