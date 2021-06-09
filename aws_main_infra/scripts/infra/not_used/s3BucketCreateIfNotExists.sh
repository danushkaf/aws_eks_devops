#!/bin/bash

if [ -z "$1" ]
then
	echo "specify bucketName as first argument"
	exit 1
fi

if [ -z "$2" ]
then
	echo "specify region as second argument"
	exit 1
fi

bucketName=$1
region=$2
infrastructure_profile=$3
searchedBucketName=$(aws --profile ${infrastructure_profile} s3 ls | grep $bucketName | awk '{print $3}')
if [ -n "$searchedBucketName" ]
then
  echo "The bucket ${bucketName} already exists"
else
  echo "The bucket ${bucketName} does not exists"
  echo "Creating the S3 bucket"
  bucketCreationResp=$(aws --profile ${infrastructure_profile} s3api create-bucket --acl=private --bucket=$bucketName --create-bucket-configuration=LocationConstraint=$region)
	aws --profile ${infrastructure_profile} s3api put-bucket-encryption --bucket=$bucketName --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}' | echo "bucket encryption settings exists."
  createdBucketUrl=$(echo $bucketCreationResp | jq .Location | tr -d '"' )
	aws --profile ${infrastructure_profile} s3api put-public-access-block --bucket $bucketName --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true" | echo "bucket public settings exists."
	cat << EOF > bucket-policy.json
{
  "Statement":[
    {
      "Action": "s3:*",
      "Effect":"Deny",
      "Principal": "*",
      "Resource":"arn:aws:s3:::${bucketName}/*",
      "Condition":{
        "Bool":
          { "aws:SecureTransport": false }
      }
    }
  ]
}
EOF
	aws --profile ${infrastructure_profile} s3api put-bucket-policy --bucket $bucketName --policy file://bucket-policy.json | echo "policy exists"
	echo "Bucket created with bucketUrl ${createdBucketUrl}"
fi

# unzip and zip are already present on the ami. still we can optionally validate that they are really present. if not present, the script can install them
if ! type "unzip" > /dev/null; then
	echo "unzip utility is not installed. installing it."
	sudo yum -y install unzip
	sleep 10
fi

if ! type "zip" > /dev/null; then
	echo "zip utility is not installed. installing it."
	sudo yum -y install zip
	sleep 10
fi
