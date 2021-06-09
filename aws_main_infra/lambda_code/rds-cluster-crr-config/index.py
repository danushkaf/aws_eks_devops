import json
from botocore.vendored import requests
import boto3
import os
import time

clusterId = os.environ['cluster_id']
kmsKeyId = os.environ['kms_key_id']
drRegion = os.environ['dr_region']
region_name = os.environ['AWS_REGION']

client = boto3.client('rds')
drclient = boto3.client('rds', region_name=drRegion)
def handler(event, context):
  """
  Lambda main handler
  """
  try:
    print('Request: start - event ' + json.dumps(event))
    ts = int(time.time() * 10000)
    snapshotId = clusterId + "-" + str(ts)
    aws_account_id = context.invoked_function_arn.split(":")[4]
    response = client.create_db_cluster_snapshot(
      DBClusterSnapshotIdentifier=snapshotId,
      DBClusterIdentifier=clusterId,
      Tags=[
          {
              'Key': 'Name',
              'Value': snapshotId
          },
          {
              'Key': 'TimeStamp',
              'Value': str(ts)
          },
      ]
    )
    print('Request: start - response ' + str(response))
    try:
      snapshot_complete_waiter = client.get_waiter('db_cluster_snapshot_available')
      snapshot_complete_waiter.wait(DBClusterSnapshotIdentifier=snapshotId)
    except botocore.exceptions.WaiterError as e:
      print(e)
    response = drclient.copy_db_cluster_snapshot(
      SourceDBClusterSnapshotIdentifier='arn:aws:rds:' + region_name + ':' + aws_account_id + ':cluster-snapshot:' + snapshotId,
      TargetDBClusterSnapshotIdentifier='dr-' + snapshotId,
      KmsKeyId=kmsKeyId,
      CopyTags=False,
      Tags=[
          {
              'Key': 'Name',
              'Value': 'dr-' + snapshotId
          },
          {
              'Key': 'TimeStamp',
              'Value': str(ts)
          },
      ],
      SourceRegion=region_name
    )
    print('Request: start - response ' + str(response))

  except Exception as ex:
    print('Unexpected exception' + str(ex))
    raise
  finally:
    print('Request: end')
