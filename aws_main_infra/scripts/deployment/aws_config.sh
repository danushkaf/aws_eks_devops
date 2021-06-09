#!/bin/bash
ACC=$1
temp_role=$(aws sts assume-role --role-arn "arn:aws:iam::$ACC:role/AWSControlTowerExecution" --role-session-name "userAct-$ACC")
AWS_ACCESS_KEY_ID=$(echo $temp_role | jq .Credentials.AccessKeyId | xargs)
AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq .Credentials.SecretAccessKey | xargs)
AWS_SESSION_TOKEN=$(echo $temp_role | jq .Credentials.SessionToken | xargs)
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID --profile $2
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY --profile $2
aws configure set aws_session_token $AWS_SESSION_TOKEN --profile $2
