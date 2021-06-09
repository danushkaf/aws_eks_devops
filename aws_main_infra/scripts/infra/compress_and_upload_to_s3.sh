#!/bin/bash

if [ -z "$1" ]
then
	echo "specify path of a root directory containing all the lambda packages as subdirectories"
	exit 1
fi

if [ -z "$2" ]
then
	echo "specify name of an s3 bucket where the lambda packages should be uploaded"
	exit 1
fi

rootDirLambdaPkgs=$1
environment_prefix=$2
infrastructure_profile=$3
region=$4

# now compress each folder inside main folder having all lambda packages and upload to s3 bucket
s3bucketName="${environment_prefix}-xyz-il-lambda-code-distributions"

aws --profile ${infrastructure_profile} s3api create-bucket --acl=private --bucket=$s3bucketName --create-bucket-configuration=LocationConstraint=$region | echo "bucket exists."
aws --profile ${infrastructure_profile} s3api put-bucket-encryption --bucket=$s3bucketName --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}' | echo "bucket encryption settings exists."
aws --profile ${infrastructure_profile} s3api put-public-access-block --bucket $s3bucketName --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true" | echo "bucket public settings exists."
cat << EOF > bucket-policy.json
{
    "Statement":[
        {
            "Action": "s3:*",
            "Effect":"Deny",
            "Principal": "*",
            "Resource":"arn:aws:s3:::${s3bucketName}/*",
            "Condition":{
                "Bool":
                { "aws:SecureTransport": false }
            }
        }
    ]
}
EOF
aws --profile ${infrastructure_profile} s3api put-bucket-policy --bucket $s3bucketName --policy file://bucket-policy.json | echo "policy exists"

lambdaPackageDirs=$(find $rootDirLambdaPkgs -maxdepth 1  -not -path "*/.git" -type d | tail -n +2)

for lambdaPkgDir in $lambdaPackageDirs
do
	echo "directory: $lambdaPkgDir"
	baseName=$(basename $lambdaPkgDir)
	echo "baseName: $baseName"
	zipFileName=$baseName".zip"
	echo "zipFileName: $zipFileName"
	cd $lambdaPkgDir
	find . | tail -n +2 | xargs zip  $zipFileName
	if [ $? -eq 0 ]; then
	    echo "zip file created for lambda package in $lambdaPkgDir, now uploading to s3 bucket"
	    aws --profile ${infrastructure_profile} s3 cp $zipFileName "s3://"$s3bucketName
	    if [ $? -eq 0 ]; then
		    echo "lambda pkg in $lambdaPkgDir uploaded successfully to s3 bucket $s3bucketName"
	    else
	            echo "failed uploading lambda pkg in $lambdaPkgDir"
	    fi
        else
	    echo "zip file creation failed for $lambdaPkgDir , skipping this one"
	fi
	cd -  #go back to prev dir
done
