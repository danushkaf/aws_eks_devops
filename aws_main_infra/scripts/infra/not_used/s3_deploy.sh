#!/bin/bash
bucket_name=$1
infrastructure_profile=$2

aws --profile ${infrastructure_profile} s3 sync ../../../src/ s3://${bucket_name}/ --delete
