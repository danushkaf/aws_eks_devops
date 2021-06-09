#!/bin/bash

shared_account_id=$1
LOG_RETENTION=$2
aws_region=$3
shared_profile=$4

loggroups=$(aws --profile ${shared_profile} logs describe-log-groups)
for k in $(jq '.logGroups | keys | .[]' <<< "$loggroups"); do
  loggroup=$(jq -r ".logGroups[$k]" <<< "$loggroups")
  name=$(jq -r '.logGroupName' <<< "$loggroup")
  aws --profile ${shared_profile} logs put-retention-policy --log-group-name ${name} --retention-in-days ${LOG_RETENTION}
done
